import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart' as myDateFormatter;
import '../../../../common/functions/format_date.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/dotIndicators.dart';
import '../../../../common/widgets/facility.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/model/hotel.dart';
import '../../model/bus_booking_detail_parameters.dart';
import '../../model/bus_feed.dart';

class BusFeedWidget extends StatefulWidget {
  const BusFeedWidget({Key? key, @required this.buses}) : super(key: key);
  final List<BusFeed>? buses;

  @override
  _BusFeedWidgetState createState() => _BusFeedWidgetState();
}

class _BusFeedWidgetState extends State<BusFeedWidget> {
  ValueNotifier<int>? currentIndexBusFeed;

  @override
  void initState() {
    super.initState();
    currentIndexBusFeed = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buses!.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            "Buses",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        CarouselSlider(
          items: List<Widget>.generate(
            widget.buses!.length,
            (int index) => SingleBusFeedWidget(bus: widget.buses?[index]),
          ),
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            enlargeCenterPage: false,
            height: MediaQuery.of(context).size.height * 0.45,
            // aspectRatio: 1.3,
            onPageChanged: (index, reason) {
              currentIndexBusFeed?.value = index;
            },
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: DotIndicatorWidget(
            dotCount: widget.buses!.length,
            currentIndex: currentIndexBusFeed!,
            activeColor: MyTheme.primaryColor,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class SingleBusFeedWidget extends StatefulWidget {
  final BusFeed? bus;

  const SingleBusFeedWidget({Key? key, this.bus}) : super(key: key);

  @override
  _SingleBusFeedWidgetState createState() => _SingleBusFeedWidgetState();
}

class _SingleBusFeedWidgetState extends State<SingleBusFeedWidget> {
  DateTime? departureDate;

  String? departureDateS;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime currentDateTime = DateTime.now();
        DateTime? selectedDate = await showDatePicker(
          context: context,
          firstDate: currentDateTime,
          initialDate: departureDate ?? currentDateTime,
          lastDate: currentDateTime.add(const Duration(days: 28)),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData(
                dialogBackgroundColor: Colors.white,
                colorScheme:
                    const ColorScheme.light(primary: MyTheme.primaryColor),
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                highlightColor: MyTheme.primaryColor,
                textTheme: MyTheme.mainTextTheme,
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: Colors.grey,
                  selectionColor: MyTheme.primaryColor,
                ),
              ),
              child: child as Widget,
            );
          },
        );

        departureDate = selectedDate;
        departureDateS =
            myDateFormatter.DateTimeFormatter.formatDate(departureDate!);

        BusBookingDetailParameters parameters =
            locator<BusBookingDetailParameters>();
        parameters.from = widget.bus?.busFrom?.name;
        parameters.fromId = widget.bus?.busFrom?.id;
        parameters.to = widget.bus?.busTo?.name;
        parameters.toId = widget.bus?.busTo?.id;
        parameters.departureDate = departureDate;
        parameters.shift = widget.bus?.busShift;

        Get.toNamed("/busList");

        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 5),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(backendServerUrl +
                            widget.bus!.vehicleInventory!.galleryList![0].image
                                .toString()),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 125,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(1.0),
                              Colors.black.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.bus!.busTag.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${widget.bus?.busFrom?.name} - ${widget.bus?.busTo?.name}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                AutoSizeText(
                                  "Rs. ${widget.bus?.price}",
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " ${widget.bus?.seatDetail?.availableSeat} Seats Available",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.5, bottom: 3.5, right: 50),
                          child: LinearPercentIndicator(
                            percent: widget.bus!.seatDetail!.availableSeat! /
                                widget.bus!.seatDetail!.totalSeatCount!,
                            progressColor: Theme.of(context).primaryColor,
                            lineHeight: 7.5,
                          ),
                        ),
                        Text(
                          " ${widget.bus?.seatDetail?.totalSeatCount} Total Seats",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      Text(DateTimeFormatter.formatTime(
                          widget.bus!.boardingTime.toString())),
                      Text(
                        "${widget.bus?.busShift?.titleCase} shift",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // if (bus.cancellationPolicy != null)
            //   Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: Text(
            //       bus.cancellationPolicy.cancellationType,
            //       style: TextStyle(fontSize: 15.0),
            //     ),
            //   ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    widget.bus!.facilitiesList!.isEmpty
                        ? const SizedBox()
                        : Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.bus?.facilitiesList?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Facility(
                                  facility: HotelFacility(
                                    name: widget.bus?.facilitiesList?[index]
                                        .vehicleFacilities?.name,
                                    image: widget.bus?.facilitiesList?[index]
                                        .vehicleFacilities?.image,
                                  ),
                                );
                              },
                            ),
                          ),
                    const SizedBox(width: 5),
                    if (widget.bus?.vehicleInventory?.review != null)
                      RatingBarIndicator(
                        rating: widget.bus?.vehicleInventory?.review
                                ?.averageReviewRating ??
                            0.0,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                        direction: Axis.horizontal,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
