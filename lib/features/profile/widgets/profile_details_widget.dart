import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/profile/widgets/member_point_status_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class ProfileDetailsWidget extends StatelessWidget {
  const ProfileDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final bool showWallet = Provider.of<SplashProvider>(context, listen: false).configModel?.walletStatus ?? false;
        final bool showReferAndEarn = (Provider.of<SplashProvider>(context, listen: false).configModel?.referEarnStatus ?? false);

        return profileProvider.isLoading
            ? CustomLoaderWidget(color: Theme.of(context).primaryColor)
            : Center(
                child: Container(
                  width: ResponsiveHelper.isDesktop(context) ? Dimensions.webScreenWidth * 0.7 : double.infinity,
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated('name', context),
                                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor.withValues(alpha: 0.6)),
                                ),
                                const SizedBox(height: 6),
                                Text('${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                const Divider(),
                              ],
                            )
                          : Center(
                              child: Text('${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel?.lName ?? ''}', style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                            ),
                      const SizedBox(height: 30),

                      // for first name section
                      Text(
                        getTranslated('mobile_number', context),
                        style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor.withValues(alpha: 0.6)),
                      ),
                      const SizedBox(height: 6),

                      Text(profileProvider.userInfoModel!.phone ?? '', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const Divider(),

                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      Text(
                        getTranslated('email', context),
                        style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor.withValues(alpha: 0.6)),
                      ),
                      const SizedBox(height: 6),

                      Text(profileProvider.userInfoModel?.email ?? '', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const Divider(),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      if (profileProvider.userInfoModel != null) ...[MemberPointStatusWidget(userInfoModel: profileProvider.userInfoModel, memberStatusModel: profileProvider.memberStatusModel), const SizedBox(height: Dimensions.paddingSizeExtraLarge)],

                      // if (profileProvider.userInfoModel != null) ...[
                      //   InkWell(
                      //     borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                      //     onTap: () => RouteHelper.getMemberRoute(),
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      //       child: Row(
                      //         children: [
                      //           Icon(Icons.groups_outlined, size: 24, color: Theme.of(context).primaryColor),
                      //           const SizedBox(width: Dimensions.paddingSizeDefault),
                      //           Expanded(
                      //             child: Text(getTranslated('member_network', context), style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      //           ),
                      //           Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).hintColor),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      //   const Divider(),
                      //   const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      // ],

                      if (showWallet) ...[
                        InkWell(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                          onTap: () => RouteHelper.getWalletRoute(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Row(
                              children: [
                                Icon(Icons.account_balance_wallet_outlined, size: 24, color: Theme.of(context).primaryColor),
                                const SizedBox(width: Dimensions.paddingSizeDefault),
                                Expanded(
                                  child: Text(getTranslated('wallet', context), style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).hintColor),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      ],

                      if (showReferAndEarn) ...[
                        InkWell(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                          onTap: () => RouteHelper.getReferAndEarnRoute(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Row(
                              children: [
                                Image.asset(Images.referralIcon, height: 24, width: 24, color: Theme.of(context).primaryColor),
                                const SizedBox(width: Dimensions.paddingSizeDefault),
                                Expanded(
                                  child: Text(getTranslated('refer_and_earn', context), style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).hintColor),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      ],
                    ],
                  ),
                ),
              );
      },
    );
  }
}
