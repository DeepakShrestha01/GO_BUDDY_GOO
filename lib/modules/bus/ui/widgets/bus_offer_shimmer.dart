import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/dotIndicator_shimmer.dart';
import '../../../../common/widgets/hotel_offers_shimmer.dart';

class BusOffersShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Bus with Discounts",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed("/busOffers");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3.5,
                ),
                child: const Text(
                  "View All >>",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        HotelOffersShimmer(),
        const SizedBox(height: 10),
        const Center(child: DotIndicatorShimmer(length: 5)),
      ],
    );
  }
}
