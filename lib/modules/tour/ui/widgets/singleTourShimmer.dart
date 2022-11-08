import 'package:flutter/material.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../common/widgets/shimmer.dart';
import '../../../../configs/theme.dart';

class SingleTourShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(bottom: 20),
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
            offset: const Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ShimmerWidget(
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.95,
                  color: Colors.white,
                ),
              ),
              ShimmerWidget(
                child: Container(
                  height: 200,
                  color: Colors.black.withOpacity(0.65),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 3,
                        left: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShimmerWidget(
                              child: Container(
                                height: 14,
                                width: 50,
                                color: Colors.white,
                              ),
                            ),
                            ShimmerWidget(
                              child: Container(
                                height: 16,
                                width: 75,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ShimmerWidget(
                        child: Container(
                          height: 28,
                          width: 100,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        right: 3,
                        child: ShimmerWidget(
                          child: Container(
                            height: 16,
                            width: 90,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  child: Container(
                    height: 15,
                    width: MediaQuery.of(context).size.width * 0.85,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                ShimmerWidget(
                  child: Container(
                    height: 15,
                    width: 125,
                    color: Colors.white,
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25,
                ),
                ShimmerWidget(
                  child: Row(
                    children: [
                      // Icon(
                      //   Icons.location_on,
                      //   color: MyTheme.primaryColor,
                      // ),
                      const PNGIconWidget(
                        asset: "assets/images/address.png",
                        color: MyTheme.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 15,
                        width: MediaQuery.of(context).size.width * 0.75,
                        color: Colors.white,
                      ),
                    ],
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
