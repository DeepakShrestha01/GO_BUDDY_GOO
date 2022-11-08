import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../model/flight_booking.dart';

class FlightBookingDetailPage extends StatefulWidget {
  const FlightBookingDetailPage({Key? key}) : super(key: key);

  @override
  _FlightBookingDetailPageState createState() =>
      _FlightBookingDetailPageState();
}

class _FlightBookingDetailPageState extends State<FlightBookingDetailPage> {
  final FlightBooking booking = Get.arguments[0];

  //if flag==-1, the booking is cancelled
  //if flag==0, the booking is completed
  //if flag==1, the booking is upcoming
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
  }

  Widget getTile({IconData? icon, String? label, String? value}) {
    return ListTile(
      leading: Icon(
        icon,
        color: MyTheme.primaryColor,
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flight Booking Detail",
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
                  icon: CupertinoIcons.person_fill,
                  label: "Guest Name",
                  value: booking.customer?.name ?? "N/A",
                ),
                divider,
                getTile(
                  icon: CupertinoIcons.phone_fill,
                  label: "Guest Contact Number",
                  value: booking.customer?.phone ?? "N/A",
                ),
                divider,
                getTile(
                  icon: CupertinoIcons.mail_solid,
                  label: "Guest Email",
                  value: booking.customer?.email ?? "N/A",
                ),
                divider,
                getTile(
                  icon: Icons.event,
                  label: "Sector Pair",
                  value:
                      "${booking.flightDetails?.first.sectorFrom}-${booking.flightDetails?.first.sectorTo}",
                ),
                divider,
                getTile(
                  icon: CupertinoIcons.person_2_fill,
                  label: "Number of travellers",
                  value:
                      "${booking.flightDetails?.first.passengers?.length} travellers",
                ),
                divider,
                getTile(
                    icon: CupertinoIcons.calendar,
                    label: "Flight Date",
                    value: DateTimeFormatter.formatDate(
                      booking.flightDetails?.first.flightDate as DateTime,
                    )),
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
                        value: booking.bookingDetails?.paymentMethod == null
                            ? "N/A"
                            : booking.bookingDetails?.paymentMethod?.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Status",
                        value: booking.bookingDetails?.paymentStatus == null
                            ? "N/A"
                            : booking.bookingDetails?.paymentStatus?.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Via",
                        value: booking.bookingDetails?.paymentType == null
                            ? "N/A"
                            : booking.bookingDetails?.paymentType?.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Initial Price",
                        value: booking.bookingDetails?.sellingPrice == null
                            ? "N/A"
                            : "Rs. ${booking.bookingDetails?.sellingPrice}",
                      ),
                      paymentDetailRow(
                        title: "Adult Promotion Discount",
                        value: booking.bookingDetails
                                    ?.totalTotalGbgAdultDiscount ==
                                null
                            ? "N/A"
                            : "Rs. ${booking.bookingDetails?.totalTotalGbgAdultDiscount?.toStringAsFixed(2)}",
                      ),
                      paymentDetailRow(
                        title: "Child Promotion Discount",
                        value: booking.bookingDetails
                                    ?.totalTotalGbgChildDiscount ==
                                null
                            ? "N/A"
                            : "Rs. ${booking.bookingDetails?.totalTotalGbgChildDiscount?.toStringAsFixed(2)}",
                      ),
                      paymentDetailRow(
                        title: "Gift Card Discount",
                        value: booking.bookingDetails?.giftCardUsedAmount ==
                                null
                            ? "N/A"
                            : "Rs. ${booking.bookingDetails?.giftCardUsedAmount?.toStringAsFixed(2)}",
                      ),
                      paymentDetailRow(
                        title: "Reward Point Discount",
                        value: booking.bookingDetails?.rewardPointUsedAmount ==
                                null
                            ? "N/A"
                            : "Rs. ${booking.bookingDetails?.rewardPointUsedAmount?.toStringAsFixed(2)}",
                      ),
                      paymentDetailRow(
                        title: "Total Paying Price",
                        value: booking.bookingDetails?.finalUserPayable == null
                            ? "N/A"
                            : "Rs. ${booking.bookingDetails?.finalUserPayable}",
                      ),
                      paymentDetailRow(
                        title: "Transcation Date",
                        value: booking.bookingDetails?.bookedDate == null
                            ? "N/A"
                            : DateTimeFormatter.formatDate(
                                booking.bookingDetails!.bookedDate!,
                              ),
                      ),
                      divider,
                    ],
                  ),
                ),
                Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      if (booking.bookingDetails?.invoicePdf != null) {
                        _permissionReady = await _checkPermission();

                        if (_permissionReady) {
                          await _prepareSaveDir();
                          showToast(
                            text:
                                "Check notification bar for download progress",
                          );
                          await FlutterDownloader.enqueue(
                            url: booking.bookingDetails!.invoicePdf!
                                    .contains("http")
                                ? booking.bookingDetails!.invoicePdf.toString()
                                : backendServerUrl +
                                    booking.bookingDetails!.invoicePdf
                                        .toString(),
                            savedDir: _localPath.toString(),
                            fileName: booking.bookingDetails!.invoicePdf
                                ?.split("/")
                                .last,
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
        ],
      ),
    );
  }
}
