import 'package:flutter/material.dart';
import '../../helper/price_converter_helper.dart';
import '../../utill/dimensions.dart';
import '../../utill/styles.dart';
import '../models/product_model.dart';
class DiscountTag extends StatelessWidget {
  const DiscountTag({super.key, required this.product, required this.discountType,});

  final Product product;
  final DiscountType discountType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Dimensions.radiusSizeTen),
          bottomLeft: Radius.circular(Dimensions.radiusSizeTen),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              discountType == DiscountType.productDiscount
                  ? product.discountType == 'percent'
                  ? '-${product.discount} %'
                  : '-${PriceConverterHelper.convertPrice(context, product.discount)}'
                  : product.categoryDiscount?.discountType == 'percent'
                  ? '-${product.categoryDiscount?.discountAmount} %'
                  : '-${PriceConverterHelper.convertPrice(context, product.categoryDiscount?.discountAmount)}',
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
            ),
          ),
        ],
      ),
    );
  }
}