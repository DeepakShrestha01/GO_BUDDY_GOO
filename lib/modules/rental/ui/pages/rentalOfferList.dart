import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/hotel_offers_shimmer.dart';
import '../../services/cubit/rental_offer/rental_offer_cubit.dart';
import '../widgets/rentalOfferWidget.dart';

class RentalOfferListPage extends StatelessWidget {
  const RentalOfferListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          RentalOfferCubit()..getAllRentalOffers(),
      child: const RentalOfferListBody(),
    );
  }
}

class RentalOfferListBody extends StatefulWidget {
  const RentalOfferListBody({super.key});

  @override
  _RentalOfferListBodyState createState() => _RentalOfferListBodyState();
}

class _RentalOfferListBodyState extends State<RentalOfferListBody> {
  @override
  Widget build(BuildContext context) {
    final RentalOfferCubit rentalOfferCubit =
        BlocProvider.of<RentalOfferCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Rental with discounts",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<RentalOfferCubit, RentalOfferState>(
        builder: (BuildContext context, state) {
          if (state is RentalOfferLoaded) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: rentalOfferCubit.rentalOffers.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemBuilder: (BuildContext context, int i) {
                return RentalOfferWidget(
                    rentalOffer: rentalOfferCubit.rentalOffers[i]);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 25),
            );
          } else if (state is RentalOfferNone) {
            return const Center(child: Text("No offers found!"));
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
