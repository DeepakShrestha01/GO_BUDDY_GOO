import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/hotel_offers_shimmer.dart';
import '../../../../configs/theme.dart';
import '../../servies/cubit/tour_offer/tour_offer_cubit.dart';
import '../widgets/tour_with_discount.dart';

class TourWithDiscountListPage extends StatelessWidget {
  const TourWithDiscountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          TourOfferCubit()..getTourHotDeals(getAll: true),
      child: const TourWithDiscountListBody(),
    );
  }
}

class TourWithDiscountListBody extends StatefulWidget {
  const TourWithDiscountListBody({super.key});

  @override
  _TourWithDiscountListBodyState createState() =>
      _TourWithDiscountListBodyState();
}

class _TourWithDiscountListBodyState extends State<TourWithDiscountListBody> {
  @override
  Widget build(BuildContext context) {
    final TourOfferCubit hotDealsTourCubit =
        BlocProvider.of<TourOfferCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Tour Packages with discounts",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: MyTheme.secondaryColor2),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<TourOfferCubit, TourOfferState>(
        builder: (context, state) {
          if (state is TourOfferLoaded) {
            if (hotDealsTourCubit.tourWithDiscounts.isEmpty) {
              return const Center(child: Text("No offers found!"));
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: hotDealsTourCubit.tourWithDiscounts.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemBuilder: (BuildContext context, int i) {
                return TourWithDiscountWidget(
                    hotDealsTourCubit.tourWithDiscounts[i]);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 25),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemBuilder: (BuildContext context, int i) {
              return HotelOffersShimmer();
            },
            separatorBuilder: (_, __) => const SizedBox(height: 25),
          );
        },
      ),
    );
  }
}
