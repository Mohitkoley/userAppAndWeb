import 'package:flutter/material.dart';
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
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatefulWidget {
  final bool showAppBar;

  const MemberScreen({super.key, this.showAppBar = true});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).isLoggedIn();

    if (_isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(true);
        Provider.of<MemberProvider>(
          context,
          listen: false,
        ).getMemberDashboard(reload: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeHandelDeepLinkWidget(
      child: Scaffold(
        appBar: widget.showAppBar
            ? ResponsiveHelper.isDesktop(context)
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(100),
                      child: WebAppBarWidget(),
                    )
                  : AppBar(
                      title: Text(
                        getTranslated('member_network', context),
                        style: poppinsMedium.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      backgroundColor: Theme.of(context).cardColor,
                      iconTheme: IconThemeData(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
            : null,
        body: !_isLoggedIn
            ? const NotLoggedInWidget()
            : Consumer<MemberProvider>(
                builder: (context, memberProvider, _) {
                  if (memberProvider.isLoading &&
                      memberProvider.matrixStatus == null) {
                    return Center(
                      child: CustomLoaderWidget(
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        memberProvider.getMemberDashboard(reload: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: Dimensions.webScreenWidth,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer<ProfileProvider>(
                                  builder: (context, profileProvider, _) {
                                    return MemberPointStatusWidget(
                                      userInfoModel:
                                          profileProvider.userInfoModel,
                                      memberStatusModel:
                                          profileProvider.memberStatusModel,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                                _StatusSection(
                                  status: memberProvider.matrixStatus,
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                                _ResponsiveTwoColumn(
                                  first: _TeamSection(
                                    team: memberProvider.matrixTeam,
                                  ),
                                  second: _IncentiveSection(
                                    incentiveHistory:
                                        memberProvider.incentiveHistory,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                                _ResponsiveTwoColumn(
                                  first: _TreeSection(
                                    node: memberProvider.matrixTree,
                                  ),
                                  second: _LevelsSection(
                                    levels: memberProvider.levels,
                                  ),
                                ),
                                if (ResponsiveHelper.isDesktop(context))
                                  const FooterWebWidget(
                                    footerType: FooterType.nonSliver,
                                  ),
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
        border: Border.all(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: poppinsSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: Dimensions.paddingSizeSmall,
                  runSpacing: Dimensions.paddingSizeSmall,
                  children: [
                    _MetricTile(
                      label: getTranslated('current_level', context),
                      value: '${status!.currentLevel}',
                    ),
                    _MetricTile(
                      label: getTranslated('position', context),
                      value: status!.currentPosition ?? '-',
                    ),
                    _MetricTile(
                      label: getTranslated('team_members', context),
                      value: '${status!.totalTeamMembers}',
                    ),
                    _MetricTile(
                      label: getTranslated('direct_active', context),
                      value:
                          '${status!.directReferralsActive}/${status!.directReferralsFilled}',
                    ),
                    _MetricTile(
                      label: getTranslated('next_level', context),
                      value: status!.nextLevel?.positionName ?? '-',
                    ),
                    _MetricTile(
                      label: getTranslated('remaining_members', context),
                      value: '${status!.nextLevel?.remainingMembers ?? 0}',
                    ),
                    _MetricTile(
                      label: getTranslated('directs_ready', context),
                      value:
                          '${status!.nextLevel?.directsReady ?? 0}/${status!.nextLevel?.directsRequired ?? 0}',
                    ),
                    _MetricTile(
                      label: getTranslated('incentives_eligible', context),
                      value: getTranslated(
                        status!.incentivesEligible ? 'yes' : 'no',
                        context,
                      ),
                    ),
                  ],
                ),
                if (status!.nextLevel?.condition.isNotEmpty ?? false) ...[
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    status!.nextLevel!.condition,
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
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
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: poppinsSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        ],
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
              children: team!.members
                  .map(
                    (member) => _InfoRow(
                      title: member.name,
                      subtitle:
                          '${getTranslated('position', context)} ${member.position} • ${getTranslated('level', context)} ${member.level}',
                      trailing: member.positionName ?? '-',
                    ),
                  )
                  .toList(),
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
      title:
          '${getTranslated('incentive_history', context)} (${incentiveHistory?.totalIncentive.toStringAsFixed(0) ?? 0})',
      child: (incentiveHistory?.history.isNotEmpty ?? false)
          ? Column(
              children: incentiveHistory!.history
                  .map(
                    (item) => _InfoRow(
                      title:
                          '${item.positionName} - ${item.amount.toStringAsFixed(0)}',
                      subtitle:
                          '${getTranslated('level', context)} ${item.level} • ${_formatDate(item.creditedAt)}',
                      trailing: item.status,
                    ),
                  )
                  .toList(),
            )
          : _EmptyText(text: getTranslated('no_result_found', context)),
    );
  }
}

String _formatDate(String value) {
  final DateTime? date = DateTime.tryParse(value)?.toLocal();
  if (date == null) return value;
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _TreeSection extends StatelessWidget {
  final MatrixTreeNodeModel? node;

  const _TreeSection({required this.node});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: getTranslated('matrix_tree', context),
      child: node == null
          ? _EmptyText(text: getTranslated('no_result_found', context))
          : _TreeNodeView(node: node!),
    );
  }
}

class _TreeNodeView extends StatelessWidget {
  final MatrixTreeNodeModel node;

  const _TreeNodeView({required this.node});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: node.depth * Dimensions.paddingSizeDefault,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            title: node.name,
            subtitle:
                '${node.phone} • ${getTranslated('level', context)} ${node.matrixLevel}',
            trailing:
                node.matrixPosition ??
                (node.isMember
                    ? getTranslated('member', context)
                    : getTranslated('not_member', context)),
          ),
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
              children: levels
                  .map(
                    (level) => _InfoRow(
                      title:
                          '${getTranslated('level', context)} ${level.level} - ${level.positionName}',
                      subtitle:
                          '${getTranslated('required_members', context)} ${level.requiredMembers}',
                      trailing: level.incentiveAmount.toStringAsFixed(0),
                    ),
                  )
                  .toList(),
            )
          : _EmptyText(text: getTranslated('no_result_found', context)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;

  const _InfoRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeExtraSmall,
      ),
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
                  style: poppinsMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(
            trailing,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: poppinsMedium.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).primaryColor,
            ),
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
    return Text(
      text,
      style: poppinsRegular.copyWith(color: Theme.of(context).hintColor),
    );
  }
}
