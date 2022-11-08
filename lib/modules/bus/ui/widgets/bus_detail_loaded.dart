import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:readmore/readmore.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/dotIndicators.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../model/bus_booking_detail_parameters.dart';
import '../../model/bus_detail.dart';
import '../../model/bus_seat.dart';
import '../../services/cubit/bus_detail/bus_detail_cubit.dart';

// ignore: must_be_immutable
class BusDetailLoadedW extends StatefulWidget {
  BusDetailLoadedW({super.key, required this.busDetail});

  BusDetail? busDetail;

  @override
  _BusDetailLoadedWState createState() => _BusDetailLoadedWState();
}

class _BusDetailLoadedWState extends State<BusDetailLoadedW> {
  BusDetail? busDetail;
  ValueNotifier<int>? currentIndexGalleryCarousel;
  BusDesign? design;
  BusBookingDetailParameters? parameters;
  List<BusSeat> selectedBusSeats = [];

  @override
  void initState() {
    super.initState();
    busDetail = widget.busDetail;
    design = busDetail?.busDesign;
    currentIndexGalleryCarousel = ValueNotifier<int>(0);
    parameters = locator<BusBookingDetailParameters>();
  }

  String getSelectedSeatsName() {
    if (selectedBusSeats.isEmpty) {
      return "";
    } else {
      String seatNames = "";

      for (BusSeat x in selectedBusSeats) {
        seatNames = "$seatNames, ${x.name}";
      }
      return seatNames.substring(2, seatNames.length);
    }
  }

  double getInitialTotalAmount() {
    if (!parameters!.selectedBus!.offer!.offerAvailableStatus!) {
      return selectedBusSeats.length *
          double.parse(parameters!.selectedBus!.price!);
    } else {
      if (parameters?.selectedBus?.offer?.discountPricingType == "rate") {
        return selectedBusSeats.length *
            double.parse(parameters!.selectedBus!.price!) *
            (1 - double.parse(parameters!.selectedBus!.offer!.rate!) / 100);
      } else if (parameters?.selectedBus?.offer?.discountPricingType ==
          "amount") {
        return selectedBusSeats.length *
            (double.parse(parameters!.selectedBus!.price!) -
                double.parse(parameters?.selectedBus?.offer?.amount));
      }
    }
    return 0.0;
  }

  buildBusSeatImage(String image, {Color? color}) {
    return Image.asset(
      image,
      height: 20,
      width: 20,
      color: color,
    );
  }

  buildBusSeat(BusSeat busSeat) {
    String image = "assets/images/seat_booked.png";
    Color? imageColor;

    if (busSeat.name == "P") {
      return Container(
        height: 30,
        width: 30,
        alignment: Alignment.center,
      );
    }

    if (busSeat.status == "SD") {
      image = "assets/images/seat_booked.png";
      imageColor = Colors.purple;
    } else if (busSeat.status == "UA") {
      image = "assets/images/seat_booked.png";
    } else if (busSeat.status == "RE") {
      imageColor = Colors.red;
      image = "assets/images/seat_booked.png";
    } else if (busSeat.status == "SL") {
      image = "assets/images/seat_available.png";
    } else if (busSeat.status == "D") {
      image = "assets/images/driver.png";
    } else if (busSeat.status == "CH") {
      image = "assets/images/seat_selected_2.png";
    } else if (busSeat.status?.toLowerCase() == "w") {
      image = "assets/images/wc.png";
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (busSeat.canBeSelected!) {
          if (selectedBusSeats.contains(busSeat)) {
            busSeat.status = "SL";
            selectedBusSeats.remove(busSeat);
          } else {
            if (selectedBusSeats.length < 6) {
              busSeat.status = "CH";
              selectedBusSeats.add(busSeat);
            } else {
              showToast(text: "You can only book 6 seats in one booking.");
            }
          }
          setState(() {});
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            height: 30,
            width: 30,
            alignment: Alignment.center,
            color: imageColor,
          ),
          Text(
            busSeat.name.toString(),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  String getCancString() {
    BusBookingDetailParameters parameters =
        locator<BusBookingDetailParameters>();

    DateTime departureTime = parameters.departureDate!.add(Duration(
      hours: DateTimeFormatter.formatTimeWithAmPm(
              busDetail!.boardingTime.toString())
          .hour,
      minutes: DateTimeFormatter.formatTimeWithAmPm(
              busDetail!.boardingTime.toString())
          .minute,
    ));

    DateTime refundableDate = departureTime.subtract(Duration(
        hours: int.parse(busDetail!.cancellationPolicy!.hour.toString())));

    bool canBeRefunded;

    if (DateTime.now().isBefore(refundableDate)) {
      canBeRefunded = true;
    } else {
      canBeRefunded = false;
    }

    if (canBeRefunded) {
      return "${"${"${widget.busDetail?.cancellationPolicy?.cancellationType}, if cancelled before ${DateTimeFormatter.formatTime(refundableDate.toIso8601String().split("T").last)}"}, ${DateTimeFormatter.formatDate(refundableDate)}"}.";
    } else {
      return "Non-refundable";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> galleryUrls = [];

    if (busDetail!.vehicleInventory!.galleryList!.isNotEmpty) {
      for (var x in busDetail!.vehicleInventory!.galleryList!) {
        galleryUrls.add(x.image.toString());
      }
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.5),
                        child: Wrap(
                          runSpacing: 20.0,
                          spacing: 30.0,
                          alignment: WrapAlignment.spaceEvenly,
                          // runAlignment: WrapAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text("Selected"),
                                buildBusSeatImage(
                                    "assets/images/seat_selected_2.png"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Available"),
                                buildBusSeatImage(
                                    "assets/images/seat_available.png"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Unavailable"),
                                buildBusSeatImage(
                                    "assets/images/seat_booked.png"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Sold"),
                                buildBusSeatImage(
                                    "assets/images/seat_selected_2.png",
                                    color: Colors.purple),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Reserved"),
                                buildBusSeatImage(
                                    "assets/images/seat_selected_2.png",
                                    color: Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                          height: 9, thickness: 1, color: Colors.grey),
                      // SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: busDetail?.busDesign?.seatList?.length,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: busDetail!.busDesign!.numColumn!,
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          // return Text(i.toString());
                          return Center(
                              child: buildBusSeat(
                                  busDetail!.busDesign!.seatList![i]));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 100.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 5.0,
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: MyTheme.secondaryColor,
                        ),
                        Positioned(
                          left: 20.0,
                          child: Column(
                            children: [
                              Text(busDetail!.busFrom!.name!),
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyTheme.primaryColor,
                                ),
                              ),
                              Text(DateTimeFormatter.formatTime(
                                  busDetail!.boardingTime.toString())),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20.0,
                          child: Column(
                            children: [
                              Text(busDetail!.busTo!.name!),
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyTheme.primaryColor,
                                ),
                              ),
                              Text(DateTimeFormatter.formatTime(
                                  busDetail!.droppingTime.toString())),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (busDetail!.boardingAreaList!.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Boarding Areas"),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.generate(
                            busDetail!.boardingAreaList!.length, (i) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 7.5, horizontal: 10.0),
                            leading: Icon(
                              Icons.place_outlined,
                              color: Colors.grey.shade400,
                            ),
                            title: Text(
                              busDetail!.boardingAreaList![i][0].titleCase,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            dense: true,
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            trailing: Text(DateTimeFormatter.formatTime(
                                busDetail!.boardingAreaList![i][1])),
                          );

                          // BoardingAreaRow(
                          //   place: busDetail.boardingAreaList[i][0],
                          //   time: DateTimeFormatter.formatTime(
                          //       busDetail.boardingAreaList[i][1]),
                          // );
                        }),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                if (busDetail!.breakAreaList!.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Break Areas"),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.generate(
                            busDetail!.breakAreaList!.length, (i) {
                          return ListTile(
                            leading: Icon(
                              Icons.place_outlined,
                              color: Colors.grey.shade400,
                            ),
                            title: Text(
                              busDetail!.breakAreaList![i][0].titleCase,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            dense: true,
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            trailing: Text(DateTimeFormatter.formatTime(
                                busDetail!.breakAreaList![i][1])),
                          );
                        }),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Cancellation Policy: ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: widget.busDetail?.cancellationPolicy
                                    ?.cancellationType ==
                                "Non-refundable"
                            ? widget
                                .busDetail?.cancellationPolicy?.cancellationType
                            : getCancString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                ReadMoreText(
                  busDetail!.vehicleInventory!.description.toString(),
                  style: const TextStyle(fontSize: 15),
                  trimLines: 8,
                  textAlign: TextAlign.justify,
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
                const SizedBox(height: 20),
                if (busDetail!.vehicleInventory!.galleryList!.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Gallery"),
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
                                galleryUrls.length,
                                (i) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: showNetworkImage(galleryUrls[i]),
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
                                dotCount: galleryUrls.length,
                                currentIndex: currentIndexGalleryCarousel!,
                                activeColor: MyTheme.primaryColor,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 75,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Selected Seats",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                getSelectedSeatsName(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 3),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Total Price",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Rs. ${getInitialTotalAmount().toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                  ),
                  onPressed: () {
                    if (selectedBusSeats.isNotEmpty) {
                      if (HiveUser.getLoggedIn()) {
                        parameters?.selectedSeats = selectedBusSeats;
                        Get.toNamed("/busBookingConfirm")?.whenComplete(() {
                          BlocProvider.of<BusDetailCubit>(context).getBusDetail(
                            busId: parameters?.selectedBusId,
                            bookingDate: DateTimeFormatter.formatDateServer(
                                parameters?.departureDate),
                          );
                        });
                      } else {
                        Get.toNamed("/accountPage");
                      }
                    } else {
                      showToast(text: "No seat selected.");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Proceed".toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BoardingAreaRow extends StatelessWidget {
  const BoardingAreaRow({
    Key? key,
    this.place,
    this.time,
  }) : super(key: key);

  final String? place;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Expanded(child: Text(place.toString())),
        Text(
          time.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
