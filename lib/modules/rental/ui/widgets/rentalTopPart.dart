import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:go_buddy_goo/modules/bus/model/bus.dart' show BusReview;
import 'package:timeago/timeago.dart' as timeago;

import '../../../../configs/theme.dart';
import '../../../bus/model/bus.dart';

class RentalDetailTopPart extends StatelessWidget {
  final String? rentalName;

  final BusReview? reviews;

  const RentalDetailTopPart({
    Key? key,
    required this.rentalName,
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
                reviews!.reviewList!.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text("No reviews yet."),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: reviews!.reviewList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reviews?.reviewList?[index].userName ??
                                      "User",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(reviews!.reviewList![index].review
                                    .toString()),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating:
                                          reviews?.reviewList?[index].rating ??
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
                                    const SizedBox(width: 5.0),
                                    Text(
                                      timeago.format(reviews!
                                          .reviewList![index].createdAt!),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
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
        if (reviews != null) showReviewsModalSheet(context);
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
              rentalName.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            RatingBarIndicator(
              rating: reviews?.averageReviewRating ?? 0.0,
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
