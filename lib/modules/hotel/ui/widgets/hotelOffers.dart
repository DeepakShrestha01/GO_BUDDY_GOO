import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/dotIndicator_shimmer.dart';
import '../../../../common/widgets/dotIndicators.dart';
import '../../../../common/widgets/hotel_offers_shimmer.dart';
import '../../../../configs/theme.dart';
import '../../../home/services/cubit/hotel_offer/hotel_offer_cubit.dart';
import '../../../home/ui/widgets/offer_carousel.dart';
import '../../model/value_notifier.dart';

class HotelOffers extends StatelessWidget {
  const HotelOffers({super.key});

  @override
  Widget build(BuildContext context) {
    final HotelOfferCubit hotelOffersCubit =
        BlocProvider.of<HotelOfferCubit>(context);

    return Column(
      children: [
        BlocBuilder<HotelOfferCubit, HotelOffersState>(
          builder: (context, state) {
            if (state is HotelOffersLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Hotels with discounts",
                          style: TextStyle(
                            color: Colors.black,
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
                  OffersCarousel(
                    offfers: hotelOffersCubit.hotelOffers,
                    currentIndex: currentIndexHotelHotDeals,
                  ),
                  const SizedBox(height: 10),
                  DotIndicatorWidget(
                    dotCount: hotelOffersCubit.hotelOffers.length,
                    currentIndex: currentIndexHotelHotDeals,
                    activeColor: MyTheme.primaryColor,
                    color: Colors.grey,
                  ),
                ],
              );
            } else if (state is HotelOffersNone) {
              return const SizedBox();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Hotels with discounts",
                        style: TextStyle(
                          color: Colors.black,
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
                HotelOffersShimmer(),
                const SizedBox(height: 10),
                const DotIndicatorShimmer(length: 5),
              ],
            );
          },
        ),
      ],
    );
  }
}
