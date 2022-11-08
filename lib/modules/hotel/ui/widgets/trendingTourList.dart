import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/dotIndicators.dart';
import '../../../../configs/theme.dart';
import '../../../tour/servies/cubit/tour_search_result/tour_search_result_cubit.dart';
import '../../../tour/ui/widgets/singleTour.dart';
import '../../../tour/ui/widgets/singleTourShimmer.dart';

class TrendingTourList extends StatefulWidget {
  const TrendingTourList({super.key});

  @override
  _TrendingTourListState createState() => _TrendingTourListState();
}

class _TrendingTourListState extends State<TrendingTourList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TourSearchResultCubit>(context).getHomeTourList();
    currentIndex = ValueNotifier(0);
  }

  ValueNotifier<int>? currentIndex;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final TourSearchResultCubit tourCubit =
        BlocProvider.of<TourSearchResultCubit>(context);

    return BlocBuilder<TourSearchResultCubit, TourSearchResultState>(
      builder: (context, state) {
        if (state is TourSearchLoaded) {
          if (tourCubit.tourList.isEmpty) {
            return const SizedBox();
          }

          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15.0),
                child: const Text(
                  "Tours",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: const BoxDecoration(),
                clipBehavior: Clip.antiAlias,
                child: CarouselSlider(
                  items: List<Widget>.generate(
                    tourCubit.tourList.length,
                    (int i) => SingleTourHomeWidget(tourCubit.tourList[i]),
                  ),
                  options: CarouselOptions(
                    autoPlay: true,
                    height: MediaQuery.of(context).size.height * 0.55,
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    onPageChanged: (i, reason) {
                      currentIndex?.value = i;
                    },
                  ),
                ),
              ),
              DotIndicatorWidget(
                dotCount: tourCubit.tourList.length,
                currentIndex: currentIndex!,
                activeColor: MyTheme.primaryColor,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
            ],
          );
        } else if (state is TourSearchError) {
          return const SizedBox();
        }

        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15.0),
              child: const Text(
                "Tours",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SingleTourShimmerWidget(),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
