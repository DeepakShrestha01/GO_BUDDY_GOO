import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../common/widgets/shimmer.dart';
import '../../../../configs/theme.dart';

class HotelShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height * 0.4;
    double width = mediaQuery.size.width * 0.9;

    return Container(
      // height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(10, 10),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShimmerWidget(
            child: Center(
              child: Container(
                width: width,
                height: height * 0.425,
                color: Colors.white,
              ),
            ),
          ),
          ShimmerWidget(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.5),
                        child: Container(
                          height: 18,
                          width: 200,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        child: ListView.separated(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return Container(
                              height: 30,
                              width: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 0.5, height: 25),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const PNGIconWidget(
                              asset: "assets/images/address.png",
                              color: MyTheme.primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                height: 14,
                                width: width,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RatingBarIndicator(
                        rating: 5,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
