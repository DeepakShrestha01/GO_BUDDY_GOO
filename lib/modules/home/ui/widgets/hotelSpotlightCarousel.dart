import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../hotel/model/hotel.dart';
import 'hotelSpotlight.dart';

class HotelSpotlightCarousel extends StatelessWidget {
  final List<Hotel> hotelSpotlights;
  final ValueNotifier? currentIndex;

  const HotelSpotlightCarousel(
      {Key? key, required this.hotelSpotlights, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    return Container(
      height: height * 0.15,
      width: width * 0.9,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(10, 10),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CarouselSlider(
        items: List<Widget>.generate(
          hotelSpotlights.length,
          (int index) =>
              HotelSpotlightW(hotelSpotlight: hotelSpotlights[index]),
        ),
        options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              currentIndex?.value = index;
            }),
      ),
    );
  }
}
