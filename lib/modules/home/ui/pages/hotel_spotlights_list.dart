import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/hote_spotlight_shimmer.dart';
import '../../services/cubit/hotel_spotlights/hotel_spotlights_cubit.dart';
import '../widgets/hotelSpotlight.dart';

class HotelSpotlightListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HotelSpotlightCubit(),
      child: HotelSpotlightListBody(),
    );
  }
}

class HotelSpotlightListBody extends StatefulWidget {
  @override
  _HotelSpotlightListBodyState createState() => _HotelSpotlightListBodyState();
}

class _HotelSpotlightListBodyState extends State<HotelSpotlightListBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HotelSpotlightCubit>(context).getAllHotelSpotlights();
  }

  @override
  Widget build(BuildContext context) {
    final HotelSpotlightCubit hotelSpotlightCubit =
        BlocProvider.of<HotelSpotlightCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Super Offers",
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
      body: BlocBuilder<HotelSpotlightCubit, HotelSpotlightState>(
        builder: (BuildContext context, state) {
          if (state is HotelSpotlightLoaded) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: hotelSpotlightCubit.hotelSpotLights.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemBuilder: (BuildContext context, int i) {
                return HotelSpotlightW(
                    hotelSpotlight: hotelSpotlightCubit.hotelSpotLights[i]);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 25),
            );
          } else if (state is HotelSpotlightNone) {
            return const Center(child: Text("No spotlights found!"));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemBuilder: (BuildContext context, int i) {
              return HotelSpotlightShimmer();
            },
            separatorBuilder: (_, __) => const SizedBox(height: 25),
          );
        },
      ),
    );
  }
}
