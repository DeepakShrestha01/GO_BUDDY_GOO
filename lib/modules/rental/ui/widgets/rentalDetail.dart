import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/widgets/facility.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/model/hotel.dart';
import '../../../hotel/ui/widgets/hotelRoomDetail.dart';
import '../../model/rental.dart';

class RentalDetailW extends StatelessWidget {
  final Rental? rental;

  const RentalDetailW({Key? key, required this.rental}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const headerTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
    );

    // double price;

    // if (rental.offer.id == null) {
    //   price = double.parse(rental.estRentalPrice);
    // } else {
    //   if (rental.offer.discountPricingType == "rate") {
    //     price = double.parse(rental.estRentalPrice) *
    //         (1 - double.parse(rental.offer.rate) / 100);
    //   } else {
    //     price = double.parse(rental.estRentalPrice) -
    //         double.parse(rental.offer.amount);
    //   }
    // }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Gallery",
                      style: headerTextStyle,
                    ),
                  ),

                  GalleryWithCarousel(
                    gallery: rental!.galleryList!.map((x) => x.image.toString()).toList(),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "About Vehicle",
                    style: headerTextStyle,
                  ),
                  const SizedBox(height: 5),

                  ReadMoreText(
                    rental!.description.toString(),
                    style: const TextStyle(fontSize: 15),
                    trimLines: 8,
                    textAlign: TextAlign.justify,
                    colorClickableText: MyTheme.primaryColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    delimiter: "  ",
                    moreStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: MyTheme.primaryColor,
                    ),
                    lessStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: MyTheme.primaryColor,
                    ),
                  ),

                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListView.separated(
                      itemCount: rental!.facilitiesList!.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Facility(
                          facility: HotelFacility(
                            name: rental?.facilitiesList?[index]
                                .vehicleFacilities?.name,
                            image: rental?.facilitiesList?[index]
                                .vehicleFacilities?.image,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 10);
                      },
                    ),
                  ),

                  Divider(
                    color: Colors.grey.shade300,
                    height: 15,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           // Text(
                  //           //   "Hosted By ${vehicle.companyName}".toUpperCase(),
                  //           //   maxLines: 2,
                  //           //   overflow: TextOverflow.ellipsis,
                  //           //   style: TextStyle(fontSize: 15),
                  //           // ),
                  //           SizedBox(height: 5),
                  //           Text(
                  //             "${rental.vehicleModel.vehicleBrand.name} ${rental.vehicleModel.model}"
                  //                 .titleCase,
                  //             maxLines: 2,
                  //             overflow: TextOverflow.ellipsis,
                  //             style: TextStyle(
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     // if (rental.offer.id != null)
                  //     //   Text(
                  //     //       rental.offer.discountPricingType == "amount"
                  //     //           ? "Rs. " + rental.offer.amount + " off"
                  //     //           : rental.offer.rate.toString() + " %off",
                  //     //       maxLines: 1,
                  //     //       style: TextStyle(
                  //     //         color: MyTheme.primaryColor,
                  //     //         fontWeight: FontWeight.bold,
                  //     //       )),
                  //   ],
                  // ),

                  if (rental?.vehicleModel?.gear != null)
                    ListTile(
                      dense: true,
                      leading: const PNGIconWidget(
                        asset: "assets/images/gear.png",
                        color: MyTheme.primaryColor,
                      ),
                      title: const Text(
                        "Gear",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        rental!.vehicleModel!.gear.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(vertical: -3),
                    ),

                  if (rental?.vehicleModel?.fuelType != null)
                    ListTile(
                      dense: true,
                      // isThreeLine: true,
                      leading: const Icon(
                        Icons.local_gas_station,
                        color: MyTheme.primaryColor,
                      ),
                      title: const Text(
                        "Fuel",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        rental!.vehicleModel!.fuelType.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(vertical: -3),
                    ),
                  if (rental?.vehicleModel?.brake != null)
                    ListTile(
                      dense: true,
                      // isThreeLine: true,
                      leading: const PNGIconWidget(
                        asset: "assets/images/breaks.png",
                        color: MyTheme.primaryColor,
                      ),

                      // Icon(
                      //   FontAwesomeIcons.bus,
                      //   color: MyTheme.primaryColor,
                      // ),
                      title: const Text(
                        "Braking System",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        rental!.vehicleModel!.brake.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(vertical: -3),
                    ),
                  if (rental?.vehicleModel?.seatingCapacity != null)
                    ListTile(
                      dense: true,
                      // isThreeLine: true,
                      leading: const Icon(
                        Icons.airline_seat_recline_extra,
                        color: MyTheme.primaryColor,
                      ),
                      title: const Text(
                        "Seating Capacity",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        rental!.vehicleModel!.seatingCapacity.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(vertical: -3),
                    ),

                  if (rental?.vehicleModel?.noOfDoors != null)
                    ListTile(
                      dense: true,
                      // isThreeLine: true,
                      leading: const PNGIconWidget(
                        asset: "assets/images/car-door.png",
                        color: MyTheme.primaryColor,
                      ),
                      title: const Text(
                        "Number of doors",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        rental!.vehicleModel!.noOfDoors.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(vertical: -3),
                    ),

                  if (rental?.vehicleModel?.tankCapacity != null)
                    ListTile(
                      dense: true,
                      // isThreeLine: true,
                      leading: const PNGIconWidget(
                        asset: "assets/images/mileage.png",
                        color: MyTheme.primaryColor,
                      ),

                      title: const Text(
                        "Tank Capacity",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        rental!.vehicleModel!.tankCapacity.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(vertical: -3),
                    ),

                  if (rental?.vehicleModel?.mileage != null)
                    ListTile(
                      dense: true,
                      leading: const PNGIconWidget(
                        asset: "assets/images/gas-station.png",
                        color: MyTheme.primaryColor,
                      ),
                      title: const Text(
                        "Mileage",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        rental!.vehicleModel!.mileage.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(vertical: -3),
                    ),
                  Divider(
                    color: Colors.grey.shade300,
                    height: 15,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),

                  const SizedBox(height: 75),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              // height: 75,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border(
                  top: BorderSide(width: 1, color: Colors.grey.shade400),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "Rs. " + price.toStringAsFixed(2) + "/ DAY",
                  //       style: TextStyle(fontWeight: FontWeight.w700),
                  //     ),
                  //     Text(
                  //       "* with discounts",
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed("/rentalBookingDetail", arguments: rental);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: MyTheme.primaryColor,
                    ),
                    child: Text(
                      "Book Now".toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
