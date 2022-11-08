import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/appbar.dart';
import '../../../hotel/ui/widgets/trendingTourList.dart';
import '../../../hotel/ui/widgets/trending_hotel_list.dart';
import '../../../tour/servies/cubit/tour_search_result/tour_search_result_cubit.dart';
import '../../services/cubit/hotel_list/hotel_list_cubit.dart';
import '../../services/cubit/hotel_offer/hotel_offer_cubit.dart';
import '../../services/cubit/hotel_spotlights/hotel_spotlights_cubit.dart';
import '../widgets/hotel_spotlights.dart';
import '../widgets/welcome_with_hotel_offers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HotelOfferCubit()),
        BlocProvider(create: (context) => HotelSpotlightCubit()),
        BlocProvider(create: (context) => HotelListCubit()),
        BlocProvider(create: (context) => TourSearchResultCubit()),
      ],
      child: const HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getMainAppBar(context, "Home", null),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: const [
            WelcomeWithHotDeals(),
            SizedBox(height: 5),
            HotelSpotlights(),
            SizedBox(height: 5),
            TrendingHotelList(),
            SizedBox(height: 5),
            TrendingTourList(),
          ],
        ),
      ),
    );
  }
}
