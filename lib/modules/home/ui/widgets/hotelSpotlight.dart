import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/model/hotel.dart';
import '../../../hotel/model/hotel_booking_detail_parameters.dart';

class HotelSpotlightW extends StatelessWidget {
  final Hotel hotelSpotlight;

  const HotelSpotlightW({Key? key, required this.hotelSpotlight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HotelBookingDetailParameters parameters =
            locator<HotelBookingDetailParameters>();
        parameters.hotel = hotelSpotlight;

        Get.toNamed("/hotelDetail", arguments: hotelSpotlight);
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: width * 0.3,
              height: height * 0.15,
              decoration: BoxDecoration(
                color: MyTheme.secondaryColor,
              ),
              child: showNetworkImage(hotelSpotlight.hotelImage.toString()),
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
                          Text(
                            hotelSpotlight.hotelName ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              hotelSpotlight.hotelDescription.toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
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
      ),
    );
  }
}
