import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../../common/widgets/facility.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel.dart';

class HotelDetailCompactBottom extends StatelessWidget {
  final String hotelName;
  final String star;
  final String hotelDescription;
  final String address;
  final double? rating;
  final double? distance;
  final double latitude;
  final double longitude;
  final List<String>? attractiveAttributes;
  final List<HotelFacility>? facilities;

  const HotelDetailCompactBottom({
    Key? key,
    required this.hotelName,
    required this.star,
    required this.hotelDescription,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.distance,
    this.attractiveAttributes,
    this.facilities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String distanceString = "";
    if (distance != null) {
      distanceString = " (${distance?.toStringAsFixed(1)} km)";
    }

    // String attributesString = "";
    // for (String x in attractiveAttributes! ) {
    //   attributesString = "$attributesString$x, ";
    // }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                child: Text(
                  "$hotelName ($star)",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              if (facilities!.isNotEmpty)
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    itemCount: facilities?.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return Facility(facility: facilities![i]);
                    },
                  ),
                ),
              //   if (attributesString.isNotEmpty) const SizedBox(height: 7.5),
              // if (attributesString.isNotEmpty)
              //   Text(
              //     attributesString.substring(0, attributesString.length - 2),
              //     style: const TextStyle(fontSize: 14),
              //   ),
            ],
          ),
        ),
        const Divider(color: Colors.grey, thickness: 0.5, height: 25),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    MapsLauncher.launchCoordinates(latitude, longitude);
                  },
                  child: Row(
                    children: [
                      const PNGIconWidget(
                        asset: "assets/images/address.png",
                        color: MyTheme.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          address + distanceString,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RatingBarIndicator(
                rating: rating ?? 0,
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
    );
  }
}
