import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/dotIndicator_shimmer.dart';
import '../../../../common/widgets/dotIndicators.dart';
import '../../../../common/widgets/hotel_offers_shimmer.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../model/tour_offer.dart';
import '../../servies/cubit/tour_offer/tour_offer_cubit.dart';

class TourWithDiscounts extends StatefulWidget {
  const TourWithDiscounts({super.key});

  @override
  _TourWithDiscountsState createState() => _TourWithDiscountsState();
}

class _TourWithDiscountsState extends State<TourWithDiscounts> {
  ValueNotifier<int>? currentIndexHotDeals;

  @override
  void initState() {
    super.initState();
    currentIndexHotDeals = ValueNotifier(0);
    BlocProvider.of<TourOfferCubit>(context).getTourHotDeals(getAll: false);
  }

  @override
  Widget build(BuildContext context) {
    final TourOfferCubit hotDealsTourCubit =
        BlocProvider.of<TourOfferCubit>(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        BlocBuilder<TourOfferCubit, TourOfferState>(
          builder: (context, state) {
            if (state is TourOfferLoaded) {
              if (hotDealsTourCubit.tourWithDiscounts.isEmpty) {
                return const SizedBox();
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Tour Packages with discounts",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed("/tourWithDiscounts");
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TourWithDisCarousel(
                    tourWithDiscounts: hotDealsTourCubit.tourWithDiscounts,
                    currentIndex: currentIndexHotDeals!,
                  ),
                  const SizedBox(height: 10),
                  DotIndicatorWidget(
                    dotCount: hotDealsTourCubit.tourWithDiscounts.length,
                    currentIndex: currentIndexHotDeals!,
                    activeColor: MyTheme.primaryColor,
                    color: Colors.grey,
                  ),
                ],
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Tour Packages with discounts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/tourWithDiscounts");
                        },
                        child: const Text(
                          "View all >>",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                HotelOffersShimmer(),
                const SizedBox(height: 10),
                const DotIndicatorShimmer(length: 5),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class TourWithDisCarousel extends StatelessWidget {
  final List<TourWithDiscount>? tourWithDiscounts;
  final ValueNotifier? currentIndex;

  const TourWithDisCarousel(
      {Key? key, this.tourWithDiscounts, this.currentIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    return SizedBox(
      height: height * 0.15,
      width: width * 0.9,
      child: CarouselSlider(
        items: List<Widget>.generate(
          tourWithDiscounts!.length,
          (int index) => TourWithDiscountWidget(tourWithDiscounts![index]),
        ),
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            currentIndex?.value = index;
          },
        ),
      ),
    );
  }
}

class TourWithDiscountWidget extends StatelessWidget {
  final TourWithDiscount tourWithDiscount;
  const TourWithDiscountWidget(this.tourWithDiscount);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.toNamed("/tourDetail", arguments: tourWithDiscount.tourPackage?.id);
      },
      child: Container(
        height: height * 0.15,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: width * 0.3,
              child: Stack(
                children: [
                  showNetworkImageSmall(
                      tourWithDiscount.offer!.bannerImage.toString()),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      // width: 100,
                      // height: 35,
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
                      decoration: const BoxDecoration(
                        color: MyTheme.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          // bottomLeft: Radius.circular(7.5),
                        ),
                      ),
                      child: AutoSizeText(
                        tourWithDiscount.offer?.discountPricingType == "amount"
                            ? "${"Rs. ${tourWithDiscount.offer?.amount}"} off"
                            : tourWithDiscount.offer?.rate + " %off",
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7.5),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(right: 3, top: 3),
                    //     child: Text(
                    //       "Expires in: " + tourHotDeal.expiresOn,
                    //       style: TextStyle(
                    //         fontSize: 10,
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tourWithDiscount.tourPackage!.packageName
                                  .toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              tourWithDiscount.offer!.offerName.toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Text(
                              tourWithDiscount.offer!.description.toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       "Rs." + tourOffer.price.toInt().toString(),
                            //       maxLines: 3,
                            //       overflow: TextOverflow.ellipsis,
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //         color: Colors.black,
                            //         decoration: TextDecoration.lineThrough,
                            //       ),
                            //     ),
                            //     SizedBox(width: 5),
                            //     Text(
                            //       "Rs." +
                            //           ((tourOffer.price) *
                            //                   (1 - tourOffer.discountRate / 100))
                            //               .toInt()
                            //               .toString(),
                            //       maxLines: 3,
                            //       overflow: TextOverflow.ellipsis,
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         color: MyTheme.secondaryColor,
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
