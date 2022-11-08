import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel.dart';
import '../../services/cubit/hotel_search_result/hotel_search_result_cubit.dart';
import 'hotelDetailCompact.dart';
import 'hotelFilter.dart';
import 'no_result_widget.dart';

class HotelSearchResultList extends StatefulWidget {
  final List<Hotel>? hotels;

  const HotelSearchResultList({Key? key, this.hotels}) : super(key: key);

  @override
  _HotelSearchResultListState createState() => _HotelSearchResultListState();
}

class _HotelSearchResultListState extends State<HotelSearchResultList> {
  HotelSearchResultCubit? hotelSearchResultCubit;

  showFilterModalSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black12.withOpacity(0.75),
      builder: (BuildContext context) {
        return FilterHotel(hotelSearchResultCubit);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    hotelSearchResultCubit = BlocProvider.of<HotelSearchResultCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.hotels!.isEmpty
            ? const NoResultWidget()
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      scrollInfo is ScrollEndNotification) {
                    if (!hotelSearchResultCubit!.allDataLoaded) {
                      if (hotelSearchResultCubit!.filteredApplied) {
                        hotelSearchResultCubit?.applyFiltersMore();
                      } else {
                        hotelSearchResultCubit?.loadMoreHotels();
                      }
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.hotels!.length + 1,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (BuildContext context, int i) {
                    if (i == widget.hotels?.length) {
                      if (hotelSearchResultCubit!.allDataLoaded) {
                        return Container();
                      }

                      return const LoadingWidget();
                    }
                    return HotelDetailCompact(hotel: widget.hotels![i]);
                  },
                ),
              ),
        hotelSearchResultCubit!.hotelLists!.isEmpty
            ? Container()
            : Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    showFilterModalSheet();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: MyTheme.primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
