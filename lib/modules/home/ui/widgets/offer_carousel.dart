import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../common/model/offer.dart';
import 'offer.dart';

class OffersCarousel extends StatelessWidget {
  final List<Offer> offfers;
  final ValueNotifier currentIndex;

  const OffersCarousel(
      {super.key, required this.offfers, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    return Container(
      height: height * 0.15,
      width: width * 0.9,
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
      clipBehavior: Clip.antiAlias,
      child: CarouselSlider(
        items: List<Widget>.generate(
            offfers.length,
            (int index) => HotelOfferW(
                  offer: offfers[index],
                )),
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            currentIndex.value = index;
          },
        ),
      ),
    );
  }
}
