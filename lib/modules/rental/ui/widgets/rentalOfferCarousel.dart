import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/modules/rental/ui/widgets/rentalOfferWidget.dart';

import '../../model/rental_offer.dart';

class RentalOfferCarousel extends StatelessWidget {
  final List<RentalOffer>? offers;
  final ValueNotifier? currentIndex;

  const RentalOfferCarousel({Key? key, this.offers, this.currentIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: CarouselSlider(
        items: List<Widget>.generate(
          offers!.length,
          (int index) => RentalOfferWidget(rentalOffer: offers?[index]),
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
