import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:readmore/readmore.dart';
import 'package:recase/recase.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../common/widgets/facility.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/model/hotel.dart';
import '../../../hotel/ui/widgets/hotelRoomDetail.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../model/tour.dart';

class TourDetail extends StatelessWidget {
  final TourPackage? tour;

  const TourDetail(this.tour, {super.key});

  @override
  Widget build(BuildContext context) {
    const headerTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
    );

    String themeString = "";

    for (var x in tour!.themes!) {
      themeString = "${x.title.toString()}, ";
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Column(
            children: [
              TourDetailTopPart(
                reviews: tour!.reviews!,
                packageName: tour!.packageName.toString(),
                themeName: themeString.substring(0, themeString.length - 2),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              const Text(
                                "Gallery",
                                style: headerTextStyle,
                              ),
                              const SizedBox(height: 2),
                              GalleryWithCarousel(
                                gallery: tour!.galleries!
                                    .map((x) => x.image!)
                                    .toList(),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "About Tour",
                                style: headerTextStyle,
                              ),
                              ReadMoreText(
                                tour!.description.toString(),
                                style: const TextStyle(fontSize: 15),
                                textAlign: TextAlign.justify,
                                trimLines: 8,
                                colorClickableText: MyTheme.primaryColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                                delimiter: "  ",
                                moreStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: MyTheme.primaryColor,
                                ),
                                lessStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: MyTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ListView.separated(
                            itemCount: tour!.facilities!.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return Facility(
                                facility: HotelFacility(
                                  name: tour?.facilities?[i].name.toString(),
                                  image: tour?.facilities?[i].image.toString(),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 10);
                            },
                          ),
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 3,
                          children: List<Widget>.generate(
                            tour!.activities!.length,
                            (i) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: MyTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tour!.activities![i],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                "Itinerary"
                                " (${tour?.nightCount} nights, ${tour?.dayCount} days)",
                                style: headerTextStyle,
                              ),
                              const SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List<Widget>.generate(
                                  tour!.itinerary!.length,
                                  (i) => SingleItinerary(
                                    index: i,
                                    itinerary: tour!.itinerary![i],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (tour!.included!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                const Text(
                                  "What's included?",
                                  style: headerTextStyle,
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List<Widget>.generate(
                                    tour!.included!.length,
                                    (i) {
                                      return BulletItemWidget(
                                          text: tour?.included?[i].description);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (tour!.excluded!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                const Text(
                                  "What's not included?",
                                  style: headerTextStyle,
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List<Widget>.generate(
                                    tour!.excluded!.length,
                                    (i) {
                                      return BulletItemWidget(
                                          text: tour?.excluded?[i].description);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Cancellation Policy: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: tour?.cancellationPolicy
                                              ?.cancellationType ==
                                          "Non-refundable"
                                      ? tour
                                          ?.cancellationPolicy?.cancellationType
                                      : "${tour?.cancellationPolicy?.cancellationType}, if cancelled before ${tour?.cancellationPolicy?.hour} hours.",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 75),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              // height: 75,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(15),
                //   topRight: Radius.circular(15),
                // ),
                border: Border(
                  top: BorderSide(width: 1, color: Colors.grey.shade400),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tour?.offer?.id != null)
                        Text(
                          tour?.packageCostingType == "per_person"
                              ? "Rs. ${tour?.costPerPerson} per person"
                              : "Rs. ${tour?.tourCost} per group",
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      tour?.offer?.id != null
                          ? Text(
                              tour?.packageCostingType == "per_person"
                                  ? tour?.offer?.discountPricingType == "amount"
                                      ? "Rs. ${(double.parse(tour!.costPerPerson.toString()) - double.parse(tour!.offer!.amount.toString())).toStringAsFixed(2)} per person"
                                      : "Rs. ${(double.parse(tour!.costPerPerson.toString()) * (1 - double.parse(tour!.offer!.rate.toString()) / 100)).toStringAsFixed(2)} per person"
                                  : tour?.offer?.discountPricingType == "amount"
                                      ? "Rs. ${(double.parse(tour!.tourCost.toString()) - double.parse(tour!.offer!.amount.toString())).toStringAsFixed(2)} per group"
                                      : "Rs. ${(double.parse(tour!.tourCost.toString()) * (1 - double.parse(tour!.offer!.rate.toString()) / 100)).toStringAsFixed(2)} per group",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            )
                          : Text(
                              tour?.packageCostingType == "per_person"
                                  ? "Rs. ${tour?.costPerPerson} per person"
                                  : "Rs. ${tour?.tourCost} per group",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bool loggedIn = HiveUser.getLoggedIn();

                      if (loggedIn) {
                        Get.toNamed("/tourBookingDetail", arguments: tour);
                      } else {
                        Get.toNamed("/accountPage");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryColor,
                    ),
                    child: Text(
                      "Book".toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SingleItinerary extends StatelessWidget {
  const SingleItinerary({
    Key? key,
    required this.itinerary,
    required this.index,
  }) : super(key: key);

  final Itinerary itinerary;
  final int index;

  @override
  Widget build(BuildContext context) {
    String meals = "";

    for (String x in itinerary.meal!) {
      meals = "$meals, $x";
    }

    String activities = "";

    for (String y in itinerary.activities!) {
      if (y.trim().isNotEmpty) activities = "$activities, $y";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Day ${index + 1}: ${itinerary.day}",
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 5),
          Center(
            child: GestureDetector(
              onTap: () {
                Get.toNamed("/photoView",
                    arguments: [itinerary.image.toString()]);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: showNetworkImage(itinerary.image.toString()),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          if (itinerary.hotel != null && itinerary.hotel!.isNotEmpty)
            getFacilityRow(
              const PNGIconWidget(
                asset: "assets/images/hotel.png",
                color: MyTheme.primaryColor,
              ),
              itinerary.hotel.toString(),
            ),
          if (meals.isNotEmpty)
            getFacilityRow(
                const PNGIconWidget(
                  asset: "assets/images/meal.png",
                  color: MyTheme.primaryColor,
                ),
                meals.substring(2, meals.length)),
          if (activities.isNotEmpty)
            getFacilityRow(
                const Icon(
                  Icons.sports_kabaddi,
                  size: 24.0,
                  color: MyTheme.primaryColor,
                ),
                activities.substring(2, activities.length)),
          const SizedBox(height: 5),
          ReadMoreText(
            itinerary.description.toString(),
            style: const TextStyle(fontSize: 15),
            trimLines: 3,
            colorClickableText: MyTheme.primaryColor,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            delimiter: "  ",
            trimExpandedText: 'Show less',
            moreStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: MyTheme.primaryColor,
            ),
            lessStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: MyTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          divider(),
        ],
      ),
    );
  }

  Widget getFacilityRow(Widget icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class TourDetailTopPart extends StatelessWidget {
  final String packageName;
  final String themeName;
  final TourReview reviews;

  const TourDetailTopPart({
    Key? key,
    required this.packageName,
    required this.themeName,
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
                              children: [
                                Text(
                                  reviews.reviewList?[index].userName ?? "User",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(reviews.reviewList![index].review
                                    .toString()),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating:
                                          reviews.reviewList?[index].rating ??
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
        // if (reviews != null)

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
              packageName.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              themeName.titleCase,
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
