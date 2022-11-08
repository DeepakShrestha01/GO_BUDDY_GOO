import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/common/widgets/shimmer.dart';

class HotelSpotlightShimmer extends StatelessWidget {
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
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: width * 0.3,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ShimmerWidget(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 3),
                            Container(
                              height: 12,
                              color: Colors.white,
                              margin: const EdgeInsets.only(right: 20),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 5,
                      right: 5,
                      left: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        ShimmerWidget(
                          child: Container(
                            height: 14,
                            width: 100,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ShimmerWidget(
                          child: Container(
                            height: 12,
                            width: 130,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        ShimmerWidget(
                          child: Container(
                            height: 12,
                            width: 130,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
