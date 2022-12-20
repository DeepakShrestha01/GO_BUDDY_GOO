import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo/modules/hotel/ui/widgets/hotelRoom.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../common/widgets/dotIndicators.dart';
import '../../../../common/widgets/facility.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel.dart';

class HotelDetail extends StatefulWidget {
  final Hotel? hotel;

  const HotelDetail({Key? key, this.hotel}) : super(key: key);

  @override
  _HotelDetailState createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  ValueNotifier<int>? currentIndexGalleryCarousel;

  List<String> galleryUrls = [];

  @override
  void initState() {
    super.initState();
    currentIndexGalleryCarousel = ValueNotifier(0);
    for (HotelGallery x in widget.hotel!.hotelGallery!) {
      galleryUrls.add(x.image.toString());
    }
  }

  final headerTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        HotelDetailTop(
          hotel: widget.hotel,
          rating: widget.hotel?.hotelRatingByUser,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 15, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Text(
                      "Gallery",
                      style: headerTextStyle,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            "/photoView",
                            arguments: galleryUrls,
                          );
                        },
                        child: CarouselSlider(
                          items: List<Widget>.generate(
                            widget.hotel!.hotelGallery!.length,
                            (i) => Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.9,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: showNetworkImage(widget
                                  .hotel!.hotelGallery![i].image
                                  .toString()),
                            ),
                          ),
                          options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              currentIndexGalleryCarousel?.value = index;
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        child: Container(
                          alignment: Alignment.center,
                          child: DotIndicatorWidget(
                            dotCount: widget.hotel!.hotelGallery!.length,
                            currentIndex: currentIndexGalleryCarousel!,
                            activeColor: MyTheme.primaryColor,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "About Hotel",
                    style: headerTextStyle,
                  ),
                  const SizedBox(height: 5),
                  ReadMoreText(
                    widget.hotel!.hotelDescription.toString(),
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
                  const SizedBox(height: 10),
                  if (widget.hotel?.offerDescription != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About Offer",
                          style: headerTextStyle,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.hotel!.hotelDescription.toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.hotel!.hotelFacilities!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Facility(
                              facility: widget.hotel!.hotelFacilities![index]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 10);
                        },
                      ),
                    ),
                  ),
                  if (widget.hotel!.hotelInventories != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Text(
                            "Rooms",
                            style: headerTextStyle,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List<Widget>.generate(
                              widget.hotel!.hotelInventories!.length, (i) {
                            return HotelRoom(
                                room: widget.hotel!.hotelInventories![i]);
                          }),
                        ),
                      ],
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

// ignore: must_be_immutable
class HotelDetailTop extends StatelessWidget {
  final Hotel? hotel;
  final List<Review>? inventoryReviews;
  final double? rating;

  const HotelDetailTop({
    Key? key,
    this.hotel,
    this.inventoryReviews,
    this.rating,
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
                inventoryReviews!.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text("No reviews yet."),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: inventoryReviews!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    showNetworkImageSmallCircular(
                                      inventoryReviews![index]
                                          .avatar
                                          .toString(),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          inventoryReviews?[index].userName ??
                                              "User",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        RatingBarIndicator(
                                          rating:
                                              inventoryReviews?[index].rating ??
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
                                          timeago.format(
                                              inventoryReviews![index]
                                                  .postedDate!),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                    inventoryReviews![index].review.toString()),
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
    return SizedBox(
      height: 75,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (inventoryReviews != null) showReviewsModalSheet(context);
              },
              child: Container(
                height: 75,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: MyTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 1),
                    Text(
                      hotel!.hotelName.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      hotel!.hotelAddress.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: rating ?? 0.0,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 16,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(height: 1),
                  ],
                ),
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
