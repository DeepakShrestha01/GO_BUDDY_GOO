import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/model/city.dart';
import '../../../../common/model/city_list.dart';
import '../../../../common/services/get_it.dart';
import '../../model/bus_booking_detail_parameters.dart';
import '../../services/cubit/bus_feed/bus_feed_cubit.dart';
import '../../services/cubit/bus_offer/bus_offer_cubit.dart';
import '../widgets/bus_feed_widget.dart';
import '../widgets/bus_offer.dart';
import '../widgets/bus_offer_shimmer.dart';
import '../widgets/bus_widget_shimmer.dart';
import '../widgets/search_widget.dart';

class BusSearchPage extends StatelessWidget {
  const BusSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => BusOfferCubit()..getBusOffers(),
        ),
        BlocProvider(
          create: (BuildContext context) => BusFeedCubit()..getBusFeed(),
        )
      ],
      child: const BusSearchBody(),
    );
  }
}

class BusSearchBody extends StatefulWidget {
  const BusSearchBody({super.key});

  @override
  _BusSearchBodyState createState() => _BusSearchBodyState();
}

class _BusSearchBodyState extends State<BusSearchBody> {
  List<City>? cities;

  @override
  void initState() {
    super.initState();

    CityList cityList = locator<CityList>();
    cities = cityList.cities;
  }

  @override
  void dispose() {
    BusBookingDetailParameters parameters =
        locator<BusBookingDetailParameters>();
    parameters.clearAllField();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BusOfferCubit cubit = BlocProvider.of<BusOfferCubit>(context);
    final BusFeedCubit feedCubit = BlocProvider.of<BusFeedCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Search Bus",
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white)),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BusSearchBox(),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: BlocBuilder<BusOfferCubit, BusOfferState>(
                builder: (context, state) {
                  if (state is BusOfferLoaded) {
                    return BusOffer(
                      busOfferCubit: cubit,
                    );
                  } else if (state is BusOfferError) {
                    return const Center(
                        child: Text("Error loading bus with discounts"));
                  } else if (state is BusOfferNone) {
                    return const SizedBox();
                  }
                  return BusOffersShimmer();
                },
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<BusFeedCubit, BusFeedState>(
              builder: (context, state) {
                if (state is BusFeedLoaded) {
                  return BusFeedWidget(buses: feedCubit.buses);
                } else if (state is BusFeedError) {
                  return const SizedBox();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Buses",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    BusWidgetShimmer(),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
