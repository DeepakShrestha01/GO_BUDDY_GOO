import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/common/widgets/shimmer.dart';

import '../../configs/theme.dart';

class HotelOffersShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    return Container(
      height: height * 0.15,
      width: width * 0.9,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(10, 10),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          ShimmerWidget(
            child: Container(
              width: width * 0.3,
              color: Colors.white,
              child: Align(
                alignment: Alignment.bottomRight,
                child: ShimmerWidget(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: const BoxDecoration(
                      color: MyTheme.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      height: 12,
                      width: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 7.5),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShimmerWidget(
                      child: Container(
                        height: 15,
                        width: 175,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    ShimmerWidget(
                      child: Container(
                        height: 14,
                        width: 150,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    ShimmerWidget(
                      child: Container(
                        height: 12,
                        width: 200,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    ShimmerWidget(
                      child: Container(
                        height: 12,
                        width: 200,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
