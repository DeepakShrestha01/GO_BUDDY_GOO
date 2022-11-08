import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../model/bus_booking.dart';
import '../../services/cubit/add_review/add_review_cubit.dart';

class BusBookingDetailPage extends StatelessWidget {
  const BusBookingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddReviewCubit(),
      child: const BusBookingDetailBody(),
    );
  }
}

class BusBookingDetailBody extends StatefulWidget {
  const BusBookingDetailBody({super.key});

  @override
  _BusBookingDetailBodyState createState() => _BusBookingDetailBodyState();
}

class _BusBookingDetailBodyState extends State<BusBookingDetailBody> {
  final BusBooking booking = Get.arguments[0];

  final int flag = Get.arguments[1];

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  final divider = Divider(
    color: Colors.grey.shade300,
    height: 15,
    thickness: 1,
    indent: 5,
    endIndent: 5,
  );

  final reviewController = TextEditingController();

  double rating = 0.0;

  AddReviewCubit? addReviewCubit;

  bool _permissionReady = false;
  String? _localPath;

  Future<bool> _checkPermission() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String?> _findLocalPath() async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory?.path;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = '${await _findLocalPath()}${Platform.pathSeparator}Download';

    final savedDir = Directory(_localPath.toString());
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  @override
  void initState() {
    super.initState();
    addReviewCubit = BlocProvider.of<AddReviewCubit>(context);
  }

  showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          // title: Text("Add a review"),
          // titleTextStyle: MyTheme.mainTextTheme.bodyText1
          //     .copyWith(fontSize: 17, color: Colors.black),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Rate your experience"),
              SizedBox(
                height: 30,
                child: RatingBar(
                  itemCount: 5,
                  itemSize: 25,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  onRatingUpdate: (double value) {
                    rating = value;
                  },
                  ratingWidget: RatingWidget(
                    empty: const Icon(
                      Icons.star_outline,
                      color: MyTheme.primaryColor,
                    ),
                    full: const Icon(
                      Icons.star,
                      color: MyTheme.primaryColor,
                    ),
                    half: const Icon(
                      Icons.star_half,
                      color: MyTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reviewController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Describe your experience",
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                reviewController.clear();
                rating = 0.0;
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: MyTheme.secondaryColor,
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                addReviewCubit?.addVehicleReview(
                  rating: rating,
                  review: reviewController.text,
                  vechicleInvId: booking.busDaily!.vehicleInventory!,
                );
                reviewController.clear();
                rating = 0.0;
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: MyTheme.secondaryColor,
              ),
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  showCancelDialog(BuildContext context) {
    String refundPolicyString = "";

    if (booking.cancellationType != null) {
      bool canBeRefunded = true;

      DateTime currentDateTime = DateTime.now();

      DateTime busDepartureDate = booking.bookedDate!.add(Duration(
        hours: int.parse(booking.busDaily!.boardingTime!.split(":").first),
        minutes: int.parse(booking.busDaily!.boardingTime!.split(":")[1]),
      ));

      int h;
      try {
        h = int.parse(booking.cancellationHour.toString());
      } catch (e) {
        h = 0;
      }

      if (currentDateTime
          .isAfter(busDepartureDate.subtract(Duration(hours: h)))) {
        canBeRefunded = false;
      }

      if (booking.cancellationType == "Non-refundable") {
        canBeRefunded = false;
      }

      if (canBeRefunded) {
        refundPolicyString += "Fully-refundable";
      } else {
        refundPolicyString += "Non-refundable";
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "You are about to cancel the booking. The amount of this booking is $refundPolicyString. Are you sure to continue? This action can not be undone.",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: MyTheme.primaryColor,
              ),
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                addReviewCubit?.cancelVehicleBooking(bookingId: booking.id!);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: MyTheme.secondaryColor,
              ),
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getTile({Widget? icon, String? label, String? value}) {
    return ListTile(
      leading: icon,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toString(),
            style: headerTextStyle,
          ),
          Text(
            value.toString(),
            style: valueTextStyle,
          ),
        ],
      ),
    );
  }

  Widget paymentDetailRow({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toString(),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  String getSeatString() {
    String busSeatsString = "";

    for (BookedSeat x in booking.bookedSeat!) {
      busSeatsString = "$busSeatsString, ${x.seatName}";
    }

    return busSeatsString.substring(2, busSeatsString.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bus Booking Detail",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: () {
                  Get.offNamedUntil("/", (route) => false);
                },
                child: const Icon(CupertinoIcons.multiply_circle_fill)),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                divider,
                getTile(
                  icon: const Icon(
                    CupertinoIcons.person_fill,
                    color: MyTheme.primaryColor,
                  ),
                  label: "Guest Name",
                  value: booking.name ?? "N/A",
                ),
                divider,
                getTile(
                  icon: const Icon(
                    CupertinoIcons.phone_fill,
                    color: MyTheme.primaryColor,
                  ),
                  label: "Guest Contact Number",
                  value: booking.phone ?? "N/A",
                ),
                divider,
                getTile(
                  icon: const Icon(
                    CupertinoIcons.mail_solid,
                    color: MyTheme.primaryColor,
                  ),
                  label: "Guest Email",
                  value: booking.email ?? "N/A",
                ),
                divider,
                getTile(
                  icon: const PNGIconWidget(
                    asset: "assets/images/bus.png",
                    color: MyTheme.primaryColor,
                  ),
                  label: "Bus",
                  value: booking.busDaily?.busTag,
                ),
                divider,
                getTile(
                  icon: const PNGIconWidget(
                    asset: "assets/images/calendar.png",
                    color: MyTheme.primaryColor,
                  ),
                  label: "Date",
                  value: DateTimeFormatter.formatDate(booking.bookedDate!),
                ),
                divider,
                getTile(
                  icon: const Icon(
                    Icons.airline_seat_recline_extra,
                    color: MyTheme.primaryColor,
                  ),
                  label: "Seats (${booking.bookedSeat?.length})",
                  value: getSeatString(),
                ),
                divider,
                getTile(
                  icon: const Icon(
                    Icons.navigation,
                    color: MyTheme.primaryColor,
                  ),
                  label: "From - To",
                  value:
                      "${booking.busDaily?.busFrom?.name} - ${booking.busDaily?.busTo?.name}",
                ),
                divider,
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Payment Details"),
                      ),
                      divider,
                      paymentDetailRow(
                          title: "Medium",
                          value: booking.payment?.paymentMethod == null
                              ? "N/A"
                              : booking.payment?.paymentMethod?.titleCase),
                      paymentDetailRow(
                        title: "Status",
                        value: booking.payment?.paymentStatus == null
                            ? "N/A"
                            : booking.payment?.paymentStatus?.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Via",
                        value: booking.payment?.paymentType == null
                            ? "N/A"
                            : booking.payment!.paymentType!.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Initial Price",
                        value: booking.payment?.sellingPrice == null
                            ? "N/A"
                            : "Rs. ${booking.payment?.sellingPrice}",
                      ),
                      paymentDetailRow(
                        title: "Promotion Discount",
                        value: booking.payment?.promotionDiscount == null
                            ? "N/A"
                            : "Rs. ${booking.payment?.promotionDiscount}",
                      ),
                      paymentDetailRow(
                        title: "Gift Card Discount",
                        value: booking.payment?.giftCard == null
                            ? "N/A"
                            : "Rs. ${booking.payment?.giftCard}",
                      ),
                      paymentDetailRow(
                        title: "Reward Point Discount",
                        value: booking.payment?.rewardPoints == null
                            ? "N/A"
                            : "Rs. ${booking.payment?.rewardPoints}",
                      ),
                      paymentDetailRow(
                        title: "Total Paying Price",
                        value: booking.payment?.usePayable == null
                            ? "N/A"
                            : "Rs. ${booking.payment?.usePayable}",
                      ),
                      paymentDetailRow(
                        title: "Transcation Date",
                        value: booking.payment?.paymentDate == null
                            ? "N/A"
                            : DateTimeFormatter.formatDate(
                                booking.payment!.paymentDate!),
                      ),
                      divider,
                    ],
                  ),
                ),
                if (booking.contactDetail!.status!)
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Bus Details"),
                              GestureDetector(
                                onTap: () {
                                  if (booking
                                          .contactDetail?.data?.contactNumber !=
                                      null) {
                                    launch(
                                        "tel://${booking.contactDetail?.data?.contactNumber}");
                                  }
                                },
                                child: const Text(
                                  "Call",
                                  style: TextStyle(color: MyTheme.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        divider,
                        paymentDetailRow(
                          title: "Bus Number",
                          value:
                              booking.contactDetail?.data?.numberPlate ?? "N/A",
                        ),
                        paymentDetailRow(
                          title: "Driver Name",
                          value:
                              booking.contactDetail?.data?.driverName ?? "N/A",
                        ),
                        paymentDetailRow(
                          title: "Contact Number",
                          value: booking.contactDetail?.data?.contactNumber ??
                              "N/A",
                        ),
                        divider,
                      ],
                    ),
                  )
                else
                  flag == 1
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Contact detail of bus will be available soon !",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )
                      : const SizedBox(),
                Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      if (booking.invoicePdf != null) {
                        _permissionReady = await _checkPermission();

                        if (_permissionReady) {
                          await _prepareSaveDir();
                          showToast(
                            text:
                                "Check notification bar for download progress",
                          );
                          await FlutterDownloader.enqueue(
                            url: booking.invoicePdf!.contains("http")
                                ? booking.invoicePdf.toString()
                                : backendServerUrl +
                                    booking.invoicePdf.toString(),
                            savedDir: _localPath.toString(),
                            fileName: booking.invoicePdf?.split("/").last,
                            showNotification: true,
                            openFileFromNotification: true,
                          );
                        } else {
                          showToast(
                            text:
                                "Storage permission is not granted. Check permission settings !",
                          );
                        }
                      } else {
                        showToast(text: "Error downloading pdf");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          MyTheme.gradientStart,
                          MyTheme.gradientEnd
                        ]),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Download invoice PDF",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.download_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70.0),
              ],
            ),
          ),
          if (flag == 0)
            Positioned(
              bottom: 5,
              child: GestureDetector(
                onTap: () {
                  showReviewDialog(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    color: MyTheme.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.5),
                  child: Center(
                    child: Text(
                      "Add Review",
                      style: MyTheme.mainTextTheme.headline4
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          else if (flag == 1)
            Positioned(
              bottom: 5,
              child: GestureDetector(
                onTap: () {
                  showCancelDialog(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    color: MyTheme.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.5),
                  child: Center(
                    child: Text(
                      "Cancel Booking",
                      style: MyTheme.mainTextTheme.headline4
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
