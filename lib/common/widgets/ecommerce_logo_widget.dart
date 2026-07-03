import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:provider/provider.dart';

class EcommerceLogoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit fit;

  const EcommerceLogoWidget({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        final String image = splash.baseUrls != null
            ? '${splash.baseUrls!.ecommerceImageUrl}/${splash.configModel!.ecommerceLogo}'
            : '';

        return CustomImageWidget(
          image: image,
          placeholder: Images.placeHolder,
          height: height,
          width: width,
          fit: fit,
        );
      },
    );
  }
}
