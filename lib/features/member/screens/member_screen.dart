import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_handel_deep_link_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/not_login_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/member/domain/models/member_matrix_model.dart';
import 'package:flutter_grocery/features/member/providers/member_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/profile/widgets/member_point_status_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if (_isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(true);
        Provider.of<MemberProvider>(context, listen: false).getMemberDashboard(reload: true);
      });
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeHandelDeepLinkWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
            : AppBar(
                title: Text(getTranslated('member_network', context), style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor)),
                backgroundColor: Theme.of(context).cardColor,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              ),
        body: !_isLoggedIn
            ? const NotLoggedInWidget()
            : Consumer<MemberProvider>(
                builder: (context, memberProvider, _) {
                  if (memberProvider.isLoading && memberProvider.matrixStatus == null) {
                    return Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor));
                  }

                  return RefreshIndicator(
                    onRefresh: () => memberProvider.getMemberDashboard(reload: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: Dimensions.webScreenWidth),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer<ProfileProvider>(
                                  builder: (context, profileProvider, _) {
                                    return MemberPointStatusWidget(userInfoModel: profileProvider.userInfoModel, memberStatusModel: profileProvider.memberStatusModel);
                                  },
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                _StatusSection(status: memberProvider.matrixStatus),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                _TransferPointsSection(userIdController: _userIdController, amountController: _amountController, isLoading: memberProvider.isTransferLoading, onSubmit: () => _transferPoints(memberProvider)),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                _ResponsiveTwoColumn(
                                  first: _TeamSection(team: memberProvider.matrixTeam),
                                  second: _IncentiveSection(incentiveHistory: memberProvider.incentiveHistory),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                _ResponsiveTwoColumn(
                                  first: _TreeSection(node: memberProvider.matrixTree),
                                  second: _LevelsSection(levels: memberProvider.levels),
                                ),
                                if (ResponsiveHelper.isDesktop(context)) const FooterWebWidget(footerType: FooterType.nonSliver),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _transferPoints(MemberProvider memberProvider) async {
    final int? toUserId = int.tryParse(_userIdController.text.trim());
    final int? amount = int.tryParse(_amountController.text.trim());

    if (toUserId == null || toUserId < 1) {
      showCustomSnackBarHelper(getTranslated('enter_receiver_user_id', context));
      return;
    } else if (amount == null || amount < 1) {
      showCustomSnackBarHelper(getTranslated('enter_valid_point_amount', context));
      return;
    }

    final response = await memberProvider.transferPoints(toUserId: toUserId, amount: amount);
    showCustomSnackBarHelper(response.message ?? '', isError: !response.isSuccess);

    if (response.isSuccess) {
      _userIdController.clear();
      _amountController.clear();
    }
  }
}

class _ResponsiveTwoColumn extends StatelessWidget {
  final Widget first;
  final Widget second;

  const _ResponsiveTwoColumn({required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [
              first,
              const SizedBox(height: Dimensions.paddingSizeDefault),
              second,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.18)),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          child,
        ],
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  final MatrixStatusModel? status;

  const _StatusSection({required this.status});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: getTranslated('matrix_status', context),
      child: status == null
          ? _EmptyText(text: getTranslated('no_result_found', context))
          : Wrap(
              spacing: Dimensions.paddingSizeSmall,
              runSpacing: Dimensions.paddingSizeSmall,
              children: [
                _MetricTile(label: getTranslated('current_level', context), value: '${status!.currentLevel}'),
                _MetricTile(label: getTranslated('position', context), value: status!.currentPosition ?? '-'),
                _MetricTile(label: getTranslated('team_members', context), value: '${status!.totalTeamMembers}'),
                _MetricTile(label: getTranslated('direct_active', context), value: '${status!.directReferralsActive}/${status!.directReferralsFilled}'),
                _MetricTile(label: getTranslated('next_level', context), value: status!.nextLevel?.positionName ?? '-'),
                _MetricTile(label: getTranslated('remaining_members', context), value: '${status!.nextLevel?.remainingMembers ?? 0}'),
              ],
            ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
        ],
      ),
    );
  }
}

class _TransferPointsSection extends StatelessWidget {
  final TextEditingController userIdController;
  final TextEditingController amountController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _TransferPointsSection({required this.userIdController, required this.amountController, required this.isLoading, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: getTranslated('transfer_points', context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final Widget receiverField = TextField(
            controller: userIdController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: getTranslated('receiver_user_id', context), border: const OutlineInputBorder()),
          );
          final Widget amountField = TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: getTranslated('points', context), border: const OutlineInputBorder()),
          );
          final Widget button = CustomButtonWidget(isLoading: isLoading, buttonText: getTranslated('transfer', context), onPressed: onSubmit);

          if (constraints.maxWidth < 620) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                receiverField,
                const SizedBox(height: Dimensions.paddingSizeSmall),
                amountField,
                const SizedBox(height: Dimensions.paddingSizeSmall),
                button,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: receiverField),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(child: amountField),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              SizedBox(width: 160, child: button),
            ],
          );
        },
      ),
    );
  }
}

class _TeamSection extends StatelessWidget {
  final MatrixTeamModel? team;

  const _TeamSection({required this.team});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '${getTranslated('team_members', context)} (${team?.total ?? 0})',
      child: (team?.members.isNotEmpty ?? false)
          ? Column(
              children: team!.members.map((member) => _InfoRow(title: member.name, subtitle: '${member.phone} • ${getTranslated('position', context)} ${member.position}', trailing: member.isMember ? getTranslated('member', context) : getTranslated('not_member', context))).toList(),
            )
          : _EmptyText(text: getTranslated('no_result_found', context)),
    );
  }
}

class _IncentiveSection extends StatelessWidget {
  final MatrixIncentiveHistoryModel? incentiveHistory;

  const _IncentiveSection({required this.incentiveHistory});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '${getTranslated('incentive_history', context)} (${incentiveHistory?.totalIncentive.toStringAsFixed(0) ?? 0})',
      child: (incentiveHistory?.history.isNotEmpty ?? false)
          ? Column(
              children: incentiveHistory!.history.map((item) => _InfoRow(title: '${item.positionName} - ${item.amount.toStringAsFixed(0)}', subtitle: '${getTranslated('level', context)} ${item.level} • ${item.totalTeamMembers} ${getTranslated('team_members', context)}', trailing: item.status)).toList(),
            )
          : _EmptyText(text: getTranslated('no_result_found', context)),
    );
  }
}

class _TreeSection extends StatelessWidget {
  final MatrixTreeNodeModel? node;

  const _TreeSection({required this.node});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: getTranslated('matrix_tree', context),
      child: node == null ? _EmptyText(text: getTranslated('no_result_found', context)) : _TreeNodeView(node: node!),
    );
  }
}

class _TreeNodeView extends StatelessWidget {
  final MatrixTreeNodeModel node;

  const _TreeNodeView({required this.node});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: node.depth * Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(title: node.name, subtitle: node.phone, trailing: node.isMember ? getTranslated('member', context) : getTranslated('not_member', context)),
          ...node.children.map((child) => _TreeNodeView(node: child)),
        ],
      ),
    );
  }
}

class _LevelsSection extends StatelessWidget {
  final List<MatrixLevelModel> levels;

  const _LevelsSection({required this.levels});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: getTranslated('matrix_levels', context),
      child: levels.isNotEmpty
          ? Column(
              children: levels.map((level) => _InfoRow(title: '${getTranslated('level', context)} ${level.level} - ${level.positionName}', subtitle: '${getTranslated('required_members', context)} ${level.requiredMembers}', trailing: level.incentiveAmount.toStringAsFixed(0))).toList(),
            )
          : _EmptyText(text: getTranslated('no_result_found', context)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;

  const _InfoRow({required this.title, required this.subtitle, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(
            trailing,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  final String text;

  const _EmptyText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: poppinsRegular.copyWith(color: Theme.of(context).hintColor));
  }
}
