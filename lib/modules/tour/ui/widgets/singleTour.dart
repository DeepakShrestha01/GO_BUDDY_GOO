import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/facility.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/model/hotel.dart';
import '../../model/tour.dart';

class SingleTourWidget extends StatelessWidget {
  final TourPackage? tour;

  const SingleTourWidget(this.tour);

  @override
  Widget build(BuildContext context) {
    String bestTimeString = "";

    if (tour!.bestTime!.isNotEmpty) {
      for (var x in tour!.bestTime!) {
        bestTimeString = "$bestTimeString, $x";
      }

      bestTimeString = bestTimeString.substring(2, bestTimeString.length);
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed("/tourDetail", arguments: tour?.id);
      },
      child: Container(
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
              offset: const Offset(10, 10),
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
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: showNetworkImage(tour!.bannerImage.toString()),
                ),
                SizedBox(
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: const BoxDecoration(
                            color: MyTheme.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              AutoSizeText(
                                tour?.packageCostingType == "per_group"
                                    ? "Rs. ${tour?.tourCost}"
                                    : "Rs. ${tour?.costPerPerson}",
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              AutoSizeText(
                                tour?.packageCostingType == "per_group"
                                    ? "per group"
                                    : "per person",
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                  Text(
                    tour!.packageName.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (bestTimeString.isNotEmpty)
                    Text(
                      "Best time: $bestTimeString",
                      style: const TextStyle(fontSize: 14),
                    ),
                  const SizedBox(height: 5),
                  if (tour?.packageCostingType == "per_group")
                    Text(
                      "Group Size: ${tour?.groupSize} person",
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    "From: ${tour?.startCity?.name}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (tour!.facilities!.isNotEmpty)
                        Expanded(
                          child: Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListView.separated(
                              itemCount: tour!.facilities!.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                return Facility(
                                  facility: HotelFacility(
                                    name: tour?.facilities?[i].name,
                                    image: tour?.facilities?[i].image,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 10);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (tour?.cancellationPolicy != null)
                    if (tour?.cancellationPolicy?.cancellationType ==
                        "Non-refundable")
                      Text(
                        tour!.cancellationPolicy!.cancellationType.toString(),
                        style: const TextStyle(fontSize: 14),
                      )
                    else
                      Text(
                        "${tour?.cancellationPolicy?.cancellationType}, if cancelled before ${tour?.cancellationPolicy?.hour} hours.",
                        style: const TextStyle(fontSize: 14),
                      ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const PNGIconWidget(
                          asset: "assets/images/address.png",
                          color: MyTheme.primaryColor,
                        ),

                        // Icon(
                        //   Icons.location_on,
                        //   color: MyTheme.primaryColor,
                        // ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            tour!.destinationCity!.name.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 5),
                        RatingBarIndicator(
                          rating: tour?.reviews == null
                              ? 0.0
                              : tour!.reviews!.averageReviewRating!.toDouble(),
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

class SingleTourHomeWidget extends StatelessWidget {
  final TourPackage tour;

  const SingleTourHomeWidget(this.tour);

  @override
  Widget build(BuildContext context) {
    String bestTimeString = "";

    if (tour.bestTime!.isNotEmpty) {
      for (var x in tour.bestTime!) {
        bestTimeString = "$bestTimeString, $x";
      }

      bestTimeString = bestTimeString.substring(2, bestTimeString.length);
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed("/tourDetail", arguments: tour.id);
      },
      child: Container(
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
              offset: const Offset(10, 10),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.95,
                    child: showNetworkImage(tour.bannerImage.toString()),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: const BoxDecoration(
                        color: MyTheme.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          AutoSizeText(
                            tour.packageCostingType == "per_group"
                                ? "Rs. ${tour.tourCost}"
                                : "Rs. ${tour.costPerPerson}",
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          AutoSizeText(
                            tour.packageCostingType == "per_group"
                                ? "per group"
                                : "per person",
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.packageName.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (bestTimeString.isNotEmpty)
                    Text(
                      "Best time: $bestTimeString",
                      style: const TextStyle(fontSize: 14),
                    ),
                  const SizedBox(height: 5),
                  if (tour.packageCostingType == "per_group")
                    Text(
                      "Group Size: ${tour.groupSize} person",
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    "From: ${tour.startCity?.name}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (tour.facilities!.isNotEmpty)
                        Expanded(
                          child: Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListView.separated(
                              itemCount: tour.facilities!.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                return Facility(
                                  facility: HotelFacility(
                                    name: tour.facilities?[i].name,
                                    image: tour.facilities?[i].image,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 10);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const PNGIconWidget(
                          asset: "assets/images/address.png",
                          color: MyTheme.primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            tour.destinationCity!.name.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 5),
                        RatingBarIndicator(
                          rating: tour.reviews == null
                              ? 0.0
                              : tour.reviews!.averageReviewRating!.toDouble(),
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
