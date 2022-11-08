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

import '../../../../common/functions/format_date.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../model/tour_booking.dart';
import '../../services/cubit/add_review/add_review_cubit.dart';

class TourBookingDetailPage extends StatelessWidget {
  const TourBookingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddReviewCubit(),
      child: const TourBookingDetailBody(),
    );
  }
}

class TourBookingDetailBody extends StatefulWidget {
  const TourBookingDetailBody({super.key});

  @override
  _TourBookingDetailBodyState createState() => _TourBookingDetailBodyState();
}

class _TourBookingDetailBodyState extends State<TourBookingDetailBody> {
  final TourBooking booking = Get.arguments[0];

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
                addReviewCubit?.addTourReview(
                  rating: rating,
                  review: reviewController.text,
                  packageId: booking.package?.packagedetail?.id as int,
                );
                reviewController.clear();
                rating = 0.0;
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: MyTheme.primaryColor,
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

      DateTime? tourStartDate = booking.bookedDate;

      int h;
      try {
        h = int.parse(booking.cancellationHour.toString());
      } catch (e) {
        h = 0;
      }

      if (currentDateTime
          .isAfter(tourStartDate!.subtract(Duration(hours: h)))) {
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
                foregroundColor: MyTheme.secondaryColor,
              ),
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                addReviewCubit?.cancelTourBooking(bookingId: booking.id as int);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: MyTheme.primaryColor,
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
          "Tour Booking Detail",
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
                  value: booking.name ?? "N/A",
                ),
                divider,
                getTile(
                  icon: CupertinoIcons.phone_fill,
                  label: "Guest Contact Number",
                  value: booking.phone ?? "N/A",
                ),
                divider,
                getTile(
                  icon: CupertinoIcons.mail_solid,
                  label: "Guest Email",
                  value: booking.email ?? "N/A",
                ),
                divider,
                getTile(
                  icon: Icons.event,
                  label: "Tour Package Name",
                  value: booking.package?.packagedetail?.packageName,
                ),
                divider,
                getTile(
                  icon: CupertinoIcons.person_2_fill,
                  label: "Number of guests",
                  value: "${booking.package?.packagedetail?.groupSize} guests",
                ),
                divider,
                getTile(
                    icon: CupertinoIcons.calendar,
                    label: "Date",
                    value:
                        "${DateTimeFormatter.formatDate(booking.bookedDate!)} - ${DateTimeFormatter.formatDate(booking.bookedDate!.add(Duration(days: booking.package!.packagedetail!.dayCount! - 1)))}"),
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
                            : booking.payment?.paymentMethod?.titleCase,
                      ),
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
                            : booking.payment?.paymentType?.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Pricing type",
                        value: booking.package?.packagedetail
                                    ?.packageCostingType ==
                                "per_person"
                            ? "Per person"
                            : "Per group",
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
                            : booking.payment?.paymentDate?.split(" ")[0],
                      ),
                      divider,
                    ],
                  ),
                ),
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
