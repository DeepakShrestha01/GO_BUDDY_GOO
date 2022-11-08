import 'package:flutter/material.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../common/widgets/shimmer.dart';
import '../../../../configs/theme.dart';

class RentalShimmer extends StatelessWidget {
  const RentalShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: MediaQuery.of(context).size.width * 0.9,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          ShimmerWidget(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Container(
                      height: 18,
                      width: 175,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 7.5),
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
                  const Divider(color: Colors.grey, thickness: 0.5, height: 25),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const PNGIconWidget(
                          asset: "assets/images/address.png",
                          color: MyTheme.primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 14,
                          width: 150,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
