import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/dotIndicator_shimmer.dart';
import '../../../../common/widgets/dotIndicators.dart';
import '../../../../common/widgets/hotel_offers_shimmer.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/hotel_offer/hotel_offer_cubit.dart';
import 'circular_menu.dart';
import 'customShapeClipper.dart';
import 'offer_carousel.dart';

class WelcomeWithHotDeals extends StatefulWidget {
  const WelcomeWithHotDeals({super.key});

  @override
  _WelcomeWithHotDealsState createState() => _WelcomeWithHotDealsState();
}

class _WelcomeWithHotDealsState extends State<WelcomeWithHotDeals> {
  ValueNotifier<int>? currentIndexHotDeals;

  @override
  void initState() {
    super.initState();
    currentIndexHotDeals = ValueNotifier(0);
    BlocProvider.of<HotelOfferCubit>(context).getHotelOffers();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    final HotelOfferCubit hotelOffersCubit =
        BlocProvider.of<HotelOfferCubit>(context);

    return Column(
      children: [
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: mediaQuery.size.height * 0.3,
            width: mediaQuery.size.width,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  // "https://sbteam.c4cdev.live/media/mobile_banner/banner.jpg",
                  "https://vendor.gobuddygoo.com/media/mobile_banner/banner.jpg",
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.black.withOpacity(0),
                color: Colors.black.withOpacity(0.25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Container(
                    height: 75,
                    width: mediaQuery.size.width,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      children: [
                        CircularWidget(
                          bottom: null,
                          left: 30,
                          right: null,
                          top: 0,
                          backGroundColor: MyTheme.primaryColor,
                          icon: Icons.hotel,
                          onTap: () {
                            Get.toNamed("/searchHotel");
                          },
                          title: "Hotels",
                        ),
                        CircularWidget(
                          bottom: null,
                          left: (mediaQuery.size.width / 4),
                          right: null,
                          top: 15,
                          backGroundColor: MyTheme.primaryColor,
                          icon: FontAwesomeIcons.bus,
                          onTap: () {
                            Get.toNamed("/searchBus");
                          },
                          title: "Bus",
                        ),
                        CircularWidget(
                          bottom: 0,
                          left: (mediaQuery.size.width / 2) - 20,
                          right: null,
                          top: null,
                          backGroundColor: MyTheme.primaryColor,
                          icon: Icons.flight,
                          onTap: () {
                            Get.toNamed("/searchFlight");
                          },
                          title: "Flights",
                        ),
                        CircularWidget(
                          bottom: null,
                          left: null,
                          right: (mediaQuery.size.width / 4),
                          top: 15,
                          backGroundColor: MyTheme.primaryColor,
                          icon: Icons.monetization_on,
                          onTap: () {
                            Get.toNamed("/rentalPage");
                          },
                          title: "Rental",
                        ),
                        CircularWidget(
                          bottom: null,
                          left: null,
                          right: 30,
                          top: 0,
                          backGroundColor: MyTheme.primaryColor,
                          icon: Icons.tour,
                          onTap: () {
                            Get.toNamed("/tourPage");
                          },
                          title: "Tours",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
        BlocBuilder<HotelOfferCubit, HotelOffersState>(
          builder: (context, state) {
            if (state is HotelOffersLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: mediaQuery.size.width * 0.9,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Hotels with discounts",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed("/hotelOfferList");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3.5,
                            ),
                            child: const Text(
                              "View all >>",
                              style: TextStyle(
                                fontSize: 12,
                                color: MyTheme.secondaryColor2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  OffersCarousel(
                    offfers: hotelOffersCubit.hotelOffers,
                    currentIndex: currentIndexHotDeals!,
                  ),
                  const SizedBox(height: 10),
                  DotIndicatorWidget(
                    dotCount: hotelOffersCubit.hotelOffers.length,
                    currentIndex: currentIndexHotDeals!,
                    activeColor: MyTheme.primaryColor,
                    color: Colors.white,
                  ),
                ],
              );
            } else if (state is HotelOffersNone) {
              return const SizedBox();
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: mediaQuery.size.width * 0.9,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Hotels with discounts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/hotelOfferList");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3.5,
                          ),
                          child: const Text(
                            "View all >>",
                            style: TextStyle(
                              fontSize: 12,
                              color: MyTheme.secondaryColor2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                HotelOffersShimmer(),
                const SizedBox(height: 10),
                const DotIndicatorShimmer(length: 5),
              ],
            );
          },
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
