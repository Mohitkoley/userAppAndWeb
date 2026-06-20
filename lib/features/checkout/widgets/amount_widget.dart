import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter_grocery/common/providers/cart_provider.dart';
>>>>>>> origin/development
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/features/checkout/domain/models/check_out_model.dart';
import 'package:flutter_grocery/features/checkout/widgets/total_amount_widget.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class AmountWidget extends StatelessWidget {
  final double total;
  final double? weight;
  const AmountWidget({
    super.key,
    required this.total,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
      CheckOutModel? checkOutData = Provider.of<OrderProvider>(context, listen: false).getCheckOutData;
      bool isFreeDelivery = CheckOutHelper.isFreeDeliveryCharge(type: checkOutData?.orderType);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Column(children: [

              const SizedBox(height: Dimensions.paddingSizeLarge),
              if(ResponsiveHelper.isDesktop(context)) TotalAmountWidget(
                amount: checkOutData?.amount ?? 0,
                freeDelivery: isFreeDelivery,
                weight: weight,
                deliveryCharge: checkOutData?.deliveryCharge ?? 0,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Divider(height: 2, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if(orderProvider.partialAmount != null) Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    getTranslated('wallet_payment', context),
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),

                  CustomDirectionalityWidget(
                    child: PriceConverterHelper.convertAnimationPrice(context, orderProvider.partialAmount ?? 0,
                      textStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),



                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text( 
                    (orderProvider.paymentMethod != null || orderProvider.selectedOfflineMethod != null || orderProvider.paymentMethodIndex == 1)
                      ? '${orderProvider.selectedOfflineMethod != null
                        ? orderProvider.selectedOfflineMethod?.methodName
                        : (orderProvider.paymentMethod?.getWayTitle ?? getTranslated('cash_on_delivery', context))} (${getTranslated('due', context)})'
                      : getTranslated('due_amount', context),
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),

                  CustomDirectionalityWidget(
                    child: PriceConverterHelper.convertAnimationPrice(context, total + (weight ?? 0) - (orderProvider.partialAmount ?? 0),
                      textStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),

                ]),

                const SizedBox(height: Dimensions.paddingSizeLarge),

              ]),

              if(ResponsiveHelper.isDesktop(context))...[
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
<<<<<<< HEAD
=======
                  Text(getTranslated('total_point_value', context), style: poppinsSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  )),

                  Text('${Provider.of<CartProvider>(context).getTotalCartPointValue()} ${getTranslated('points', context)}', style: poppinsSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor,
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
>>>>>>> origin/development
                  Text(getTranslated('total_amount', context), style: poppinsSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  )),

                  CustomDirectionalityWidget(child: PriceConverterHelper.convertAnimationPrice(context, total + (weight ?? 0),
                    textStyle: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyMedium?.color),
                  )),

                ]),

              ],

            ]),
          );
        }
    );
  }
}
