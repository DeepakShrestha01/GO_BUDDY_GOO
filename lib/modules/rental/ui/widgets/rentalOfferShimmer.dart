import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/dotIndicator_shimmer.dart';
import '../../../../common/widgets/hotel_offers_shimmer.dart';

class RentalOffersShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Rental with discounts",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed("/rentalOffers");
              },
              child: const Text(
                "View all >>",
                style: TextStyle(fontSize: 12),
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

// class RentalOffersNoneWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Rental with discounts",
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Get.toNamed("/rentalOffers");
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 3.5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: MyTheme.primaryColor,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Text(
//                   "View All",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         SizedBox(
//             height: MediaQuery.of(context).size.height * 0.15,
//             width: MediaQuery.of(context).size.width * 0.9,
//             child: Center(child: Text("No offers found!"))),
//         SizedBox(height: 10),
//       ],
//     );
//   }
// }
