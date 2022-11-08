import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../../../configs/theme.dart';
import '../../model/range.dart';

class HotelSearchParameterDisplay extends StatelessWidget {
  final String searchQuery;
  final Range dateRange;
  final int totalGuests;
  final ValueNotifier<int> noOfHotels;

  const HotelSearchParameterDisplay({
    Key? key,
    required this.mediaQuery,
    required this.searchQuery,
    required this.dateRange,
    required this.totalGuests,
    required this.noOfHotels,
  }) : super(key: key);

  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      width: mediaQuery.size.width,
      decoration: const BoxDecoration(
        color: MyTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Keyword: ${searchQuery.sentenceCase}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          ValueListenableBuilder(
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                "${dateRange.start} - ${dateRange.end} | $totalGuests Guests | ${noOfHotels.value} Hotels",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              );
            },
            valueListenable: noOfHotels,
          ),
        ],
      ),
    );
  }
}
