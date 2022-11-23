import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/services/get_it.dart';
import '../../../home/services/cubit/hotel_list/hotel_list_cubit.dart';
import '../../../home/services/cubit/hotel_offer/hotel_offer_cubit.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import '../../model/value_notifier.dart';
import '../../services/cubit/keyword_search/keyword_search_cubit.dart';
import '../widgets/hotelOffers.dart';
import '../widgets/hotelSearch.dart';
import '../widgets/title.dart';
import '../widgets/trending_hotel_list.dart';

class SearchHotelPage extends StatelessWidget {
  const SearchHotelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HotelOfferCubit()),
        BlocProvider(create: (context) => HotelListCubit()),
        BlocProvider(create: (context) => KeywordSearchCubit()),
      ],
      child: const SearchHotelBody(),
    );
  }
}

class HotelOffersCubitbit {}

class SearchHotelBody extends StatefulWidget {
  const SearchHotelBody({super.key});

  @override
  _SearchHotelBodyState createState() => _SearchHotelBodyState();
}

class _SearchHotelBodyState extends State<SearchHotelBody> {
  ScrollController? _scrollController;

  Widget? title;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController?.addListener(listener);
    title = null;
    BlocProvider.of<HotelOfferCubit>(context).getHotelOffers();
  }

  listener() {
    if (_scrollController!.offset > 250) {
      if (title == null) {
        title = TitleWidget(
          onTap: () {
            _scrollController?.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
            );
          },
        );
        setState(() {});
      }
    } else if (_scrollController!.offset < 250) {
      title = null;
      setState(() {});
    }
  }

  @override
  void dispose() {
    searchHotelString.value = "Search";
    HotelBookingDetailParameters parameters =
        locator<HotelBookingDetailParameters>();
    parameters.clearAllField();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Search Hotels",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HotelSearch(),
            SizedBox(height: 10),
            HotelOffers(),
            SizedBox(height: 10),
            Center(child: TrendingHotelList()),
          ],
        ),
      ),
    );
  }
}
