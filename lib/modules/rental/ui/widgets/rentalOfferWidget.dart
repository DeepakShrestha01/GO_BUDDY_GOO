import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/network_image.dart';
import '../../model/rental_offer.dart';

class RentalOfferWidget extends StatelessWidget {
  final RentalOffer? rentalOffer;
  const RentalOfferWidget({Key? key, this.rentalOffer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    return GestureDetector(
      onTap: () {
        Get.toNamed("/vehicleDetail",
            arguments: rentalOffer?.vehicleInventory?.id);
      },
      child: Container(
        height: height * 0.15,
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
            SizedBox(
              width: width * 0.3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  showNetworkImage(rentalOffer!.offer!.bannerImage.toString()),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 3, horizontal: 5),
                  //     decoration: BoxDecoration(
                  //       color: MyTheme.primaryColor,
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(10),
                  //       ),
                  //     ),
                  //     child: AutoSizeText(
                  //       rentalOffer.offer.discountPricingType == "amount"
                  //           ? "Rs. " + rentalOffer.offer.amount + " off"
                  //           : rentalOffer.offer.rate.toString() + " %off",
                  //       maxLines: 1,
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(width: 7.5),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rentalOffer!.offer!.offerName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "On ${rentalOffer?.vehicleInventory?.vehicleBrand} ${rentalOffer?.vehicleInventory?.busModel}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "At ${rentalOffer?.vehicleInventory?.location?.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Valid till ${rentalOffer?.offer?.endDate}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
