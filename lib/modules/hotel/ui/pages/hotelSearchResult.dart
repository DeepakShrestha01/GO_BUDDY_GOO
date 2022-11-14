import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/services/get_it.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import '../../model/value_notifier.dart';
import '../../services/cubit/hotel_search_result/hotel_search_result_cubit.dart';
import '../widgets/hotelDetailCompactShimmer.dart';
import '../widgets/hotelSearchParameterDisplay.dart';
import '../widgets/hotelSearchResultList.dart';
import '../widgets/no_result_widget.dart';

class HotelSearchResultPage extends StatelessWidget {
  const HotelSearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HotelSearchResultCubit(),
      child: const HotelSearchResultBody(),
    );
  }
}

class HotelSearchResultBody extends StatefulWidget {
  const HotelSearchResultBody({super.key});
  @override
  _HotelSearchResultBodyState createState() => _HotelSearchResultBodyState();
}

class _HotelSearchResultBodyState extends State<HotelSearchResultBody> {
  HotelBookingDetailParameters? parameters;
  @override
  void initState() {
    super.initState();

    parameters = locator<HotelBookingDetailParameters>();

    BlocProvider.of<HotelSearchResultCubit>(context).getSearchResult();
  }

  @override
  void dispose() {
    hotelSearchResultNumber.value = 0;

    HotelBookingDetailParameters parameters =
        locator<HotelBookingDetailParameters>();
    parameters.clearAllExceptKeyWordOrLatlng();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HotelSearchResultCubit hotelSearchResultCubit =
        BlocProvider.of<HotelSearchResultCubit>(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Hotel List",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white)),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: () {
                  Get.offNamedUntil("/", (route) => false);
                },
                child: const Icon(CupertinoIcons.multiply_circle_fill)),
          ),
        ],
      ),
      body: Column(
        children: [
          HotelSearchParameterDisplay(
            mediaQuery: mediaQuery,
            dateRange: parameters!.dateRange!,
            noOfHotels: hotelSearchResultNumber,
            searchQuery: parameters!.query.toString(),
            totalGuests: parameters!.maxAdults! + parameters!.maxChildren!,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocConsumer<HotelSearchResultCubit, HotelSearchResultState>(
              listener: (context, state) {},
              builder: (BuildContext context, state) {
                if (state is HotelSearchLoaded ||
                    state is HotelSearchMoreLoading) {
                  return HotelSearchResultList(
                      hotels: hotelSearchResultCubit.hotelLists!);
                } else if (state is HotelSearchError) {
                  return const NoResultWidget();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (BuildContext context, int i) {
                    return AbsorbPointer(
                      absorbing: true,
                      child: HotelShimmerWidget(),
                    );
                  },
                );
                // return SpinKitLoading();
              },
            ),
          ),
        ],
      ),
    );
  }
}
