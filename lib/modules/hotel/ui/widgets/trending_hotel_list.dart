import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/dotIndicators.dart';
import '../../../../configs/theme.dart';
import '../../../home/services/cubit/hotel_list/hotel_list_cubit.dart';
import 'hotelDetailCompact.dart';
import 'hotelDetailCompactShimmer.dart';

class TrendingHotelList extends StatefulWidget {
  const TrendingHotelList({super.key});

  @override
  State<TrendingHotelList> createState() => _TrendingHotelListState();
}

class _TrendingHotelListState extends State<TrendingHotelList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HotelListCubit>(context).getHotelNearMe();
    currentIndex = ValueNotifier(0);
  }

  ValueNotifier<int>? currentIndex;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final HotelListCubit hotelListCubit =
        BlocProvider.of<HotelListCubit>(context);

    return BlocBuilder<HotelListCubit, HotelListState>(
      builder: (context, state) {
        if (state is HotelListLoaded) {
          if (hotelListCubit.hotelLists.isEmpty) {
            return Container();
          }
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15.0),
                child: const Text(
                  "Hotels",
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
                    hotelListCubit.hotelLists.length,
                    (int i) {
                      return HotelDetailCompact(
                          hotel: hotelListCubit.hotelLists[i]);
                    },
                  ),
                  options: CarouselOptions(
                    autoPlay: true,
                    height: MediaQuery.of(context).size.height * 0.45,
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    onPageChanged: (i, reason) {
                      currentIndex?.value = i;
                    },
                  ),
                ),
              ),
              DotIndicatorWidget(
                dotCount: hotelListCubit.hotelLists.length,
                currentIndex: currentIndex!,
                activeColor: MyTheme.primaryColor,
                color: Colors.grey,
              ),
            ],
          );
        } else if (state is HotelListError) {
          return Container();
        }
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15.0),
              child: const Text(
                "Hotels",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 15),
            HotelShimmerWidget(),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
