import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/features/profile/domain/models/member_status_model.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class MemberPointStatusWidget extends StatelessWidget {
  static const int membershipPointTarget = 6500;

  final UserInfoModel? userInfoModel;
  final MemberStatusModel? memberStatusModel;
  final bool compact;

  const MemberPointStatusWidget({super.key, this.userInfoModel, this.memberStatusModel, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final int nextMilestone = (memberStatusModel?.nextMilestone ?? membershipPointTarget) > 0 ? memberStatusModel?.nextMilestone ?? membershipPointTarget : membershipPointTarget;
    final int totalPointValue = memberStatusModel?.totalPointValue ?? userInfoModel?.totalPointValue ?? 0;
    final bool isMember = (memberStatusModel?.isMember ?? userInfoModel?.isMember ?? false) || totalPointValue >= nextMilestone;
    final int remainingPointValue = (memberStatusModel?.remainingPoints ?? (nextMilestone - totalPointValue)).clamp(0, nextMilestone).toInt();
    final double progress = memberStatusModel != null ? (memberStatusModel!.progressPercent / 100).clamp(0.0, 1.0).toDouble() : (totalPointValue / nextMilestone).clamp(0.0, 1.0).toDouble();
    final Color statusColor = isMember ? Theme.of(context).primaryColor : Theme.of(context).hintColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final Widget title = Text(getTranslated('membership_progress', context), style: poppinsMedium.copyWith(fontSize: compact ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault));
              final Widget status = Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(30)),
                child: Text(
                  getTranslated(isMember ? 'member' : 'not_member', context),
                  style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: statusColor),
                ),
              );

              if (constraints.maxWidth < 300) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    status,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: title),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  status,
                ],
              );
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          LayoutBuilder(
            builder: (context, constraints) {
              final Widget label = Text(
                getTranslated('total_point_value', context),
                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              );
              final Widget value = CustomDirectionalityWidget(
                child: Text(
                  '$totalPointValue / $nextMilestone ${getTranslated('points', context)}',
                  textAlign: TextAlign.end,
                  style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              );

              if (constraints.maxWidth < 330) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [label, const SizedBox(height: 2), value]);
              }

              return Row(
                children: [
                  Expanded(child: label),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Flexible(child: value),
                ],
              );
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(minHeight: compact ? 6 : 8, value: progress, backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.16), valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            isMember ? getTranslated('membership_achieved', context) : '$remainingPointValue ${getTranslated('points_left_to_become_member', context)}',
            style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}
