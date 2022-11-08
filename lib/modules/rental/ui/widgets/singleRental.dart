import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:recase/recase.dart';

import '../../../../common/model/city_list.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/facility.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/model/hotel.dart';
import '../../model/rental.dart';

// ignore: must_be_immutable
class SingleRental extends StatelessWidget {
  final Rental? rental;

  SingleRental({Key? key, this.rental}) : super(key: key);

  CityList cityList = locator<CityList>();
  @override
  Widget build(BuildContext context) {
    // String distanceString = "";
    // if (rental.distance != null) {
    //   distanceString = " (" + rental.distance.toStringAsFixed(1) + " km)";
    // }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.toNamed("/vehicleDetail", arguments: rental?.id);
      },
      child: Container(
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
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: showNetworkImage(rental!.vehicleModel!.image.toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Text(
                      "  ${rental?.vehicleModel?.vehicleBrand?.name.toString()} ${rental?.vehicleModel?.model}"
                          .titleCase,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // Text(
                  //   rental.description,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(fontSize: 14),
                  // ),
                  // SizedBox(height: 7.5),
                  SizedBox(
                    height: 35,
                    child: ListView.builder(
                      itemCount: rental?.facilitiesList?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Facility(
                          facility: HotelFacility(
                            name: rental
                                ?.facilitiesList?[i].vehicleFacilities?.name,
                            image: rental
                                ?.facilitiesList?[i].vehicleFacilities?.image,
                          ),
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
                        // Icon(
                        //   Icons.location_on,
                        //   color: MyTheme.primaryColor,
                        // ),

                        const PNGIconWidget(
                          asset: "assets/images/address.png",
                          color: MyTheme.primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            cityList.getCityName(rental!.vehicleLocation!),
                            // +distanceString,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (rental?.review != null)
                          RatingBarIndicator(
                            rating: rental?.review?.averageReviewRating ?? 0.0,
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
      ),
    );
  }
}

// ignore: must_be_immutable
class SingleRentalSearch extends StatelessWidget {
  final Rental? rental;

  SingleRentalSearch({Key? key, this.rental}) : super(key: key);

  CityList cityList = locator<CityList>();
  @override
  Widget build(BuildContext context) {
    // String distanceString = "";
    // if (rental.distance != null) {
    //   distanceString = " (" + rental.distance.toStringAsFixed(1) + " km)";
    // }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.toNamed("/vehicleDetail", arguments: rental?.id);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.45,
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
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: showNetworkImage(rental!.vehicleModel!.image.toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Text(
                      "  ${rental?.vehicleModel?.vehicleBrand?.name.toString()} ${rental?.vehicleModel?.model}"
                          .titleCase,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // Text(
                  //   rental.description,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(fontSize: 14),
                  // ),
                  // SizedBox(height: 7.5),
                  SizedBox(
                    height: 35,
                    child: ListView.builder(
                      itemCount: rental?.facilitiesList?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Facility(
                          facility: HotelFacility(
                            name:
                                rental?.facilitiesList?[i].vehicleFacilities?.name,
                            image: rental
                                ?.facilitiesList?[i].vehicleFacilities?.image,
                          ),
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
                        // Icon(
                        //   Icons.location_on,
                        //   color: MyTheme.primaryColor,
                        // ),

                        const PNGIconWidget(
                          asset: "assets/images/address.png",
                          color: MyTheme.primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            cityList.getCityName(rental!.vehicleLocation!),
                            // +distanceString,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (rental?.review != null)
                          RatingBarIndicator(
                            rating: rental?.review?.averageReviewRating ?? 0.0,
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
      ),
    );
  }
}
