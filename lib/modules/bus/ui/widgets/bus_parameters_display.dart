import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recase/recase.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../model/bus.dart';
import '../../model/bus_booking_detail_parameters.dart';

class BusSearchParameterDisplay extends StatelessWidget {
  final String? from, to;
  final String? date;
  final ValueNotifier<int>? noOfBuses;

  const BusSearchParameterDisplay({
    Key? key,
    this.from,
    this.to,
    this.noOfBuses,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BusBookingDetailParameters parameters =
        locator<BusBookingDetailParameters>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      width: MediaQuery.of(context).size.width,
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
            "Route: ${from?.titleCase}  to  ${to?.titleCase}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          noOfBuses == null
              ? Text(
                  date.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                )
              : ValueListenableBuilder(
                  builder: (BuildContext context, value, Widget? child) {
                    return Text(
                      "$date | ${noOfBuses?.value} Buses | ${parameters.shift?.titleCase} shift",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    );
                  },
                  valueListenable: noOfBuses!,
                ),
        ],
      ),
    );
  }
}

class BusDetailTopPart extends StatelessWidget {
  final String date;
  final String busTag;
  final String from;
  final String to;
  final String shift;
  final BusReview reviews;

  const BusDetailTopPart({
    Key? key,
    required this.date,
    required this.busTag,
    required this.from,
    required this.to,
    required this.shift,
    required this.reviews,
  }) : super(key: key);

  showReviewsModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black12.withOpacity(0.75),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Text(
                  "Reviews",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                reviews.reviewList!.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text("No reviews yet."),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: reviews.reviewList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    showNetworkImageSmallCircular(
                                      reviews.reviewList![index].avatar
                                          .toString(),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reviews.reviewList?[index].userName ??
                                              "User",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        RatingBarIndicator(
                                          rating: reviews
                                                  .reviewList?[index].rating ??
                                              0.0,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 16,
                                          direction: Axis.horizontal,
                                        ),
                                        Text(
                                          timeago.format(reviews
                                              .reviewList![index].createdAt!),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(reviews.reviewList![index].review! * 10),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 15,
                              color: Colors.grey.shade200,
                              thickness: 1,
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showReviewsModalSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.5),
        width: MediaQuery.of(context).size.width,
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
              busTag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              "${from.titleCase}  to  ${to.titleCase} | $date | ${shift.titleCase} shift",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            RatingBarIndicator(
              rating: reviews.averageReviewRating ?? 0.0,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 16,
              direction: Axis.horizontal,
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
