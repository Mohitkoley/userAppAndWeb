import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class ProductPointValueWidget extends StatelessWidget {
  final int pointValue;
  final bool compact;

  const ProductPointValueWidget({super.key, required this.pointValue, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.stars_rounded, size: compact ? 11 : 14, color: primaryColor),
        const SizedBox(width: 3),
        Text(
          compact ? '$pointValue pts' : 'Point value: $pointValue',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: poppinsSemiBold.copyWith(color: primaryColor, fontSize: compact ? Dimensions.fontSizeExtraSmall : Dimensions.fontSizeSmall),
        ),
      ],
    );

    return Tooltip(
      message: 'Point value: $pointValue',
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: compact ? 58 : 170),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: compact ? 4 : Dimensions.paddingSizeSmall, vertical: compact ? 1 : Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
            border: Border.all(color: primaryColor.withValues(alpha: 0.18)),
          ),
          child: FittedBox(fit: BoxFit.scaleDown, child: content),
        ),
      ),
    );
  }
}
