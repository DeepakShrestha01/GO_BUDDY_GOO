import 'package:flutter/material.dart';

import '../../../../configs/theme.dart';
import '../../model/hotel_promotion.dart';

class HotelPromotionWidget extends StatelessWidget {
  final HotelPromotion? promotion;
  final bool? isSelected;
  final Function()? onTap;

  const HotelPromotionWidget({
    Key? key,
    required this.promotion,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String discountString = "";

    if (promotion!.percentageStatus!) {
      discountString = "${promotion?.rate} %";
    } else {
      discountString = "Rs. ${promotion?.rate}";
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: isSelected! ? MyTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              promotion!.promotionName.toString(),
              style: TextStyle(color: isSelected! ? Colors.white : Colors.black),
            ),
            Text(
              discountString,
              style: TextStyle(color: isSelected! ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
