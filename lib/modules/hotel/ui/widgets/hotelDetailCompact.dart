import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/services/get_it.dart';
import '../../model/hotel.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import 'hotelDetailCompactBottom.dart';
import 'hotelDetailCompactTop.dart';

class HotelDetailCompact extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailCompact({Key? key, required this.hotel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height * 0.4;
    double width = mediaQuery.size.width * 0.9;

    return GestureDetector(
      onTap: () {
        HotelBookingDetailParameters parameters =
            locator<HotelBookingDetailParameters>();
        parameters.hotel = hotel;

        Get.toNamed("/hotelDetail", arguments: hotel);
      },
      child: Container(
        height: height,
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
            Expanded(
              child: HotelDetailCompactTop(
                imageUrl: hotel.hotelImage.toString(),
                price: hotel.minimumPrice == null
                    ? null
                    : double.parse(hotel.minimumPrice.toString()).toInt(),
              ),
            ),
            HotelDetailCompactBottom(
              facilities: hotel.hotelFacilities,
              latitude: double.parse(hotel.hotelLatitude.toString()),
              longitude: double.parse(hotel.hotelLongitude.toString()),
              distance: hotel.distance,
              rating: hotel.hotelRatingByUser,
              address: hotel.hotelAddress.toString(),
              hotelDescription: hotel.hotelDescription.toString(),
              hotelName: hotel.hotelName.toString(),
              star: hotel.hotelStarRating.toString(),
            )
          ],
        ),
      ),
    );
  }
}
