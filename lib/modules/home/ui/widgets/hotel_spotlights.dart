import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/dotIndicator_shimmer.dart';
import '../../../../common/widgets/dotIndicators.dart';
import '../../../../common/widgets/hote_spotlight_shimmer.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/hotel_spotlights/hotel_spotlights_cubit.dart';
import 'hotelSpotlightCarousel.dart';

class HotelSpotlights extends StatefulWidget {
  const HotelSpotlights({super.key});

  @override
  _HotelSpotlightsState createState() => _HotelSpotlightsState();
}

class _HotelSpotlightsState extends State<HotelSpotlights> {
  ValueNotifier<int>? currentIndexSuperOffers;

  @override
  void initState() {
    super.initState();
    currentIndexSuperOffers = ValueNotifier(0);
    BlocProvider.of<HotelSpotlightCubit>(context).getHotelSpotlights();
  }

  @override
  Widget build(BuildContext context) {
    final HotelSpotlightCubit hotelSpotlightCubit =
        BlocProvider.of<HotelSpotlightCubit>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BlocBuilder<HotelSpotlightCubit, HotelSpotlightState>(
        builder: (context, state) {
          if (state is HotelSpotlightLoaded) {
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Spotlight",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/hotelSpotlightList");
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
                const SizedBox(height: 10),
                HotelSpotlightCarousel(
                  hotelSpotlights: hotelSpotlightCubit.hotelSpotLights,
                  currentIndex: currentIndexSuperOffers,
                ),
                const SizedBox(height: 10),
                DotIndicatorWidget(
                  dotCount: hotelSpotlightCubit.hotelSpotLights.length,
                  currentIndex: currentIndexSuperOffers!,
                  activeColor: MyTheme.primaryColor,
                  color: Colors.grey,
                ),
              ],
            );
          } else if (state is HotelSpotlightNone) {
            return const SizedBox();
          }

          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Spotlight",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed("/hotelSpotlightList");
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
              const SizedBox(height: 10),
              HotelSpotlightShimmer(),
              const SizedBox(height: 10),
              const DotIndicatorShimmer(length: 5),
            ],
          );
        },
      ),
    );
  }
}
