import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/hotel_offers_shimmer.dart';
import '../../../hotel/model/hotel_booking_detail_parameters.dart';
import '../../services/cubit/hotel_offer/hotel_offer_cubit.dart';
import '../widgets/offer.dart';

class HotelOffersListPage extends StatelessWidget {
  const HotelOffersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HotelOfferCubit()..getAllHotelOffers(),
      child: const HotelOffersListBody(),
    );
  }
}

class HotelOffersListBody extends StatefulWidget {
  const HotelOffersListBody({super.key});

  @override
  _HotelOffersListBodyState createState() => _HotelOffersListBodyState();
}

class _HotelOffersListBodyState extends State<HotelOffersListBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HotelOfferCubit hotelOffersCubit =
        BlocProvider.of<HotelOfferCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "All Hotel with Discounts",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            HotelBookingDetailParameters parameters =
                locator<HotelBookingDetailParameters>();
            parameters.clearAllField();
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<HotelOfferCubit, HotelOffersState>(
        builder: (context, state) {
          if (state is HotelOffersLoaded) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: hotelOffersCubit.hotelOffers.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemBuilder: (BuildContext context, int i) {
                return HotelOfferW(offer: hotelOffersCubit.hotelOffers[i]);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 25),
            );
          } else if (state is HotelOffersNone) {
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
