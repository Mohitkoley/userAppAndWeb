import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_handel_deep_link_widget.dart';
import 'package:flutter_grocery/features/refer_and_earn/helper/refer_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/not_login_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'refer_hint_widget.dart';

class ReferAndEarnScreen extends StatefulWidget {
  final bool showAppBar;
  const ReferAndEarnScreen({super.key, this.showAppBar = true});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
<<<<<<< HEAD
  final List<String> shareItem = ['messenger', 'whatsapp', 'gmail', 'viber', 'share'];
=======
  final List<String> shareItem = [
    'messenger',
    'whatsapp',
    'gmail',
    'viber',
    'share',
  ];
>>>>>>> origin/development
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
=======
    _isLoggedIn = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).isLoggedIn();
>>>>>>> origin/development
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
<<<<<<< HEAD
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
=======
    final ConfigModel? configModel = Provider.of<SplashProvider>(
      context,
      listen: false,
    ).configModel;
>>>>>>> origin/development

    return CustomPopScopeHandelDeepLinkWidget(
      child: Scaffold(
        appBar: widget.showAppBar
            ? ResponsiveHelper.isDesktop(context)
<<<<<<< HEAD
                  ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
                  : CustomAppBarWidget(title: getTranslated('refer_and_earn', context)) as PreferredSizeWidget
            : null,

        body: _isLoggedIn
            ? configModel != null && (configModel.referEarnStatus ?? false)
=======
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(100),
                      child: WebAppBarWidget(),
                    )
                  : CustomAppBarWidget(
                          title: getTranslated('refer_and_earn', context),
                        )
                        as PreferredSizeWidget
            : null,

        body: _isLoggedIn
            ? !widget.showAppBar ||
                      (configModel != null &&
                          (configModel.referEarnStatus ?? false))
>>>>>>> origin/development
                  ? Consumer<ProfileProvider>(
                      builder: (context, profileProvider, _) {
                        return profileProvider.userInfoModel != null
                            ? SingleChildScrollView(
<<<<<<< HEAD
                                padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
=======
                                padding: ResponsiveHelper.isDesktop(context)
                                    ? EdgeInsets.zero
                                    : const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault,
                                        vertical:
                                            Dimensions.paddingSizeExtraSmall,
                                      ),
>>>>>>> origin/development
                                child: Column(
                                  children: [
                                    ResponsiveHelper.isDesktop(context)
                                        ? Padding(
<<<<<<< HEAD
                                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
                                            child: Center(
                                              child: Text("refer_and_earn".tr, style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
=======
                                            padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .paddingSizeExtraLarge,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "refer_and_earn".tr,
                                                style: poppinsSemiBold.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                ),
                                              ),
>>>>>>> origin/development
                                            ),
                                          )
                                        : const SizedBox(),

                                    Center(
                                      child: ConstrainedBox(
<<<<<<< HEAD
                                        constraints: BoxConstraints(maxWidth: ResponsiveHelper.isDesktop(context) ? 750 : double.infinity),
                                        child: !ResponsiveHelper.isDesktop(context)
                                            ? SingleChildScrollView(
                                                child: DetailsView(size: size, shareItem: shareItem, hintList: profileProvider.hintList),
                                              )
                                            : DetailsView(size: size, shareItem: shareItem, hintList: profileProvider.hintList),
                                      ),
                                    ),

                                    const FooterWebWidget(footerType: FooterType.nonSliver),
                                  ],
                                ),
                              )
                            : CustomLoaderWidget(color: Theme.of(context).primaryColor);
=======
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              ResponsiveHelper.isDesktop(
                                                context,
                                              )
                                              ? 750
                                              : double.infinity,
                                        ),
                                        child:
                                            !ResponsiveHelper.isDesktop(context)
                                            ? SingleChildScrollView(
                                                child: DetailsView(
                                                  size: size,
                                                  shareItem: shareItem,
                                                  hintList:
                                                      profileProvider.hintList,
                                                ),
                                              )
                                            : DetailsView(
                                                size: size,
                                                shareItem: shareItem,
                                                hintList:
                                                    profileProvider.hintList,
                                              ),
                                      ),
                                    ),

                                    const FooterWebWidget(
                                      footerType: FooterType.nonSliver,
                                    ),
                                  ],
                                ),
                              )
                            : CustomLoaderWidget(
                                color: Theme.of(context).primaryColor,
                              );
>>>>>>> origin/development
                      },
                    )
                  : NoDataWidget(title: getTranslated('not_found', context))
            : const NotLoggedInWidget(),
      ),
    );
  }
}

// expandableContent: ResponsiveHelper.isDesktop(context)
//     ? const SizedBox() : ReferHintWidget(hintList: hintList),

class DetailsView extends StatelessWidget {
<<<<<<< HEAD
  const DetailsView({super.key, required Size size, required this.shareItem, required this.hintList}) : _size = size;
=======
  const DetailsView({
    super.key,
    required Size size,
    required this.shareItem,
    required this.hintList,
  }) : _size = size;
>>>>>>> origin/development

  final Size _size;
  final List<String> shareItem;
  final List<String?> hintList;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        return profileProvider.userInfoModel != null
            ? Column(
                children: [
<<<<<<< HEAD
                  Image.asset(Images.referBanner, height: _size.height * 0.3, width: _size.width * 0.7),
=======
                  Image.asset(
                    Images.referBanner,
                    height: _size.height * 0.3,
                    width: _size.width * 0.7,
                  ),
>>>>>>> origin/development
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(
                    getTranslated('invite_friend_and_businesses', context),
                    textAlign: TextAlign.center,
<<<<<<< HEAD
                    style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
=======
                    style: poppinsMedium.copyWith(
                      fontSize: Dimensions.fontSizeOverLarge,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
>>>>>>> origin/development
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    getTranslated('copy_your_code', context),
                    textAlign: TextAlign.center,
<<<<<<< HEAD
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
=======
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
>>>>>>> origin/development
                  ),
                  const SizedBox(height: 40),

                  Text(
                    getTranslated('your_personal_code', context),
                    textAlign: TextAlign.center,
<<<<<<< HEAD
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w200, color: Theme.of(context).hintColor),
=======
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).hintColor,
                    ),
>>>>>>> origin/development
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  DottedBorder(
<<<<<<< HEAD
                    options: RoundedRectDottedBorderOptions(padding: const EdgeInsets.all(4), radius: const Radius.circular(Dimensions.radiusSizeLarge), dashPattern: const [5, 5], color: Theme.of(context).primaryColor.withValues(alpha: 0.5), strokeWidth: 2),
=======
                    options: RoundedRectDottedBorderOptions(
                      padding: const EdgeInsets.all(4),
                      radius: const Radius.circular(Dimensions.radiusSizeLarge),
                      dashPattern: const [5, 5],
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.5),
                      strokeWidth: 2,
                    ),
>>>>>>> origin/development
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
<<<<<<< HEAD
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: Text(
                              profileProvider.userInfoModel!.referCode ?? '',
                              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
=======
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                            ),
                            child: Text(
                              profileProvider.userInfoModel!.referCode ?? '',
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              ),
>>>>>>> origin/development
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
<<<<<<< HEAD
                            if (profileProvider.userInfoModel!.referCode != null && profileProvider.userInfoModel!.referCode != '') {
                              Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}'));
                              showCustomSnackBarHelper(getTranslated('referral_code_copied', context), isError: false);
=======
                            if (profileProvider.userInfoModel!.referCode !=
                                    null &&
                                profileProvider.userInfoModel!.referCode !=
                                    '') {
                              Clipboard.setData(
                                ClipboardData(
                                  text:
                                      '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}',
                                ),
                              );
                              showCustomSnackBarHelper(
                                getTranslated('referral_code_copied', context),
                                isError: false,
                              );
>>>>>>> origin/development
                            }
                          },
                          child: Container(
                            width: 85,
                            height: 40,
                            alignment: Alignment.center,
<<<<<<< HEAD
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(60)),
                            child: FittedBox(
                              child: Text(
                                getTranslated('copy', context),
                                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white.withValues(alpha: 0.9)),
=======
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: FittedBox(
                              child: Text(
                                getTranslated('copy', context),
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraLarge,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
>>>>>>> origin/development
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

<<<<<<< HEAD
                  Text(getTranslated('or_share', context), style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
=======
                  Text(
                    getTranslated('or_share', context),
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
>>>>>>> origin/development

                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(
<<<<<<< HEAD
                        title: ReferHelper.getSignUpLink(profileProvider.userInfoModel!.referCode!),
                        uri: Uri.parse(AppConstants.webHostUrl).replace(path: RouteHelper.createAccount, queryParameters: {'referral_code': profileProvider.userInfoModel?.referCode ?? ''}),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Image.asset(Images.getShareIcon('share'), height: 50, width: 50),
=======
                        title: ReferHelper.getSignUpLink(
                          profileProvider.userInfoModel!.referCode!,
                        ),
                        uri: Uri.parse(AppConstants.webHostUrl).replace(
                          path: RouteHelper.createAccount,
                          queryParameters: {
                            'referral_code':
                                profileProvider.userInfoModel?.referCode ?? '',
                          },
                        ),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall,
                      ),
                      child: Image.asset(
                        Images.getShareIcon('share'),
                        height: 50,
                        width: 50,
                      ),
>>>>>>> origin/development
                    ),
                  ),

                  if (ResponsiveHelper.isDesktop(context))
                    Column(
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        ReferHintWidget(hintList: hintList),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ],
                    ),
                ],
              )
            : const SizedBox();
      },
    );
  }
}
