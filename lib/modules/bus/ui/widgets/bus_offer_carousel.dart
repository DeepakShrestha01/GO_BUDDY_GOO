import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_buddy_goo/modules/bus/ui/widgets/singlebusoffer_widget.dart';

import '../../model/bus_offer.dart';

class BusOfferCarousel extends StatelessWidget {
  final List<BusOffer>? offers;
  final ValueNotifier? currentIndex;

  const BusOfferCarousel({Key? key, this.offers, this.currentIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: CarouselSlider(
        items: List<Widget>.generate(
          offers!.length,
          (int index) => SingleBusOfferWidget(busoffer: offers?[index]),
        ),
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1,
          enlargeCenterPage: false,
          height: MediaQuery.of(context).size.height * 0.15,
          // aspectRatio: 1.3,
          onPageChanged: (index, reason) {
            currentIndex?.value = index;
          },
        ),
      ),
    );
  }
}
