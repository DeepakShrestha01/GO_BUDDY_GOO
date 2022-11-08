import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/model/city_list.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/search_delegate.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/ui/widgets/trendingTourList.dart';
import '../../servies/cubit/tour_offer/tour_offer_cubit.dart';
import '../../servies/cubit/tour_search_result/tour_search_result_cubit.dart';
import '../../servies/cubit/tour_theme/tour_theme_cubit.dart';
import '../widgets/tourSearchCitiesDelegate.dart';
import '../widgets/tourTheme.dart';
import '../widgets/tour_with_discount.dart';

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => TourThemeCubit()),
        BlocProvider(create: (BuildContext context) => TourOfferCubit()),
        BlocProvider(create: (BuildContext context) => TourSearchResultCubit())
      ],
      child: const TourBody(),
    );
  }
}

class TourBody extends StatefulWidget {
  const TourBody({super.key});

  @override
  _TourBodyState createState() => _TourBodyState();
}

class _TourBodyState extends State<TourBody> {
  final searchFieldController = TextEditingController();
  GlobalKey<AnimatorWidgetState>? _keySearch;

  CityList? cityList;

  @override
  void initState() {
    super.initState();
    _keySearch = GlobalKey<AnimatorWidgetState>();
    cityList = locator<CityList>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tour Packages",
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
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TourThemeW(cities: cityList?.cities),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Shake(
                        key: _keySearch,
                        preferences: const AnimationPreferences(
                            autoPlay: AnimationPlayStates.None),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(3, 3),
                                color: Colors.grey.shade300,
                                spreadRadius: 3,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: searchFieldController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search tour package",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (searchFieldController.text.isEmpty) {
                          _keySearch?.currentState?.forward();
                        } else {
                          showSearchCustom(
                            context: context,
                            delegate: TourSearchCitiesDelegate(
                                cityList?.cities, searchFieldController.text),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: MyTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              "Search",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const TourWithDiscounts(),
                const SizedBox(height: 15),
                const TrendingTourList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
