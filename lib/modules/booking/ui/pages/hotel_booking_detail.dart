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
import '../../../../common/functions/guest_string.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel_booking.dart';
import '../../services/cubit/add_review/add_review_cubit.dart';

class HotelBookedDetailPage extends StatelessWidget {
  const HotelBookedDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddReviewCubit(),
      child: const HotelBookedDetailBody(),
    );
  }
}

class HotelBookedDetailBody extends StatefulWidget {
  const HotelBookedDetailBody({super.key});

  @override
  _HotelBookedDetailBodyState createState() => _HotelBookedDetailBodyState();
}

class _HotelBookedDetailBodyState extends State<HotelBookedDetailBody> {
  final HotelBooking booking = Get.arguments[0];

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

  showReviewDialog(BuildContext context, int invId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
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
                addReviewCubit?.addHotelReview(
                  hotelId: booking.hotelDetail?.id as int,
                  invId: invId,
                  rating: rating,
                  review: reviewController.text,
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

    for (int i = 0; i < booking.modules!.length; i++) {
      if (booking.modules?[i].cancellationType != null) {
        bool canBeRefunded = true;

        DateTime currentDateTime = DateTime.now();

        int h;
        try {
          h = int.parse(booking.modules![i].cancellationHour.toString());
        } catch (e) {
          h = 0;
        }

        if (currentDateTime.isAfter(booking.modules![i].checkIn!
            .add(const Duration(hours: 12))
            .subtract(Duration(hours: h)))) {
          canBeRefunded = false;
        }

        if (booking.modules?[i].cancellationType == "Non-refundable") {
          canBeRefunded = false;
        }

        refundPolicyString += ", ";
        if (canBeRefunded) {
          refundPolicyString += "Fully-refundable";
        } else {
          refundPolicyString += "Non-refundable";
        }

        refundPolicyString += " for Booking ${i + 1}";
      }

      refundPolicyString =
          refundPolicyString.substring(2, refundPolicyString.length);
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
                addReviewCubit?.cancelHotelBooking(
                    bookingId: booking.bookingId as int);
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

  Widget getBookingDetail(Module bookingModule, int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Booking ${i + 1}",
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
              if (flag == 0)
                GestureDetector(
                  onTap: () {
                    showReviewDialog(context, bookingModule.inventoryId as int);
                  },
                  child: Row(
                    children: [
                      Text(
                        "Add Review",
                        style: MyTheme.mainTextTheme.headline4?.copyWith(
                            color: MyTheme.primaryColor, fontSize: 15),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        CupertinoIcons.add_circled_solid,
                        color: MyTheme.primaryColor,
                        size: 15,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
        paymentDetailRow(
          title: "Room",
          value: bookingModule.inventoryName == null
              ? "N/A"
              : bookingModule.inventoryName?.titleCase,
        ),
        paymentDetailRow(
          title: "No of Guests",
          value: getGuestString(
              bookingModule.noOfAdult as int, bookingModule.noOfChild as int),
        ),
        paymentDetailRow(
          title: "Check In Date",
          value:
              DateTimeFormatter.formatDate(bookingModule.checkIn as DateTime),
        ),
        paymentDetailRow(
          title: "Check Out Date",
          value:
              DateTimeFormatter.formatDate(bookingModule.checkOut as DateTime),
        ),
        paymentDetailRow(
          title: "No of Rooms",
          value: bookingModule.roomCount.toString(),
        ),
        paymentDetailRow(
          title: "Sub total price",
          value: bookingModule.percentage != null
              ? bookingModule.percentage!
                  ? "Rs. ${(double.parse(bookingModule.subTotal.toString()) * (1 - double.parse(bookingModule.discount.toString()) / 100)).toStringAsFixed(2)}"
                  : "Rs. ${(double.parse(bookingModule.subTotal.toString()) - double.parse(bookingModule.discount.toString())).toStringAsFixed(2)}"
              : "Rs. ${bookingModule.subTotal}",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Hotel Booking Detail",
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white)),
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
                  value: booking.guest?.name ?? "N/A",
                ),
                divider,
                getTile(
                  icon: const Icon(
                    CupertinoIcons.phone_fill,
                    color: MyTheme.primaryColor,
                  ),
                  label: "Guest Contact Number",
                  value: booking.guest?.contact ?? "N/A",
                ),
                divider,
                getTile(
                  icon: const Icon(
                    CupertinoIcons.mail_solid,
                    color: MyTheme.primaryColor,
                  ),
                  label: "Guest Email",
                  value: booking.guest?.email ?? "N/A",
                ),
                divider,
                getTile(
                  icon: const PNGIconWidget(
                    asset: "assets/images/hotel.png",
                    color: MyTheme.primaryColor,
                  ),
                  label: "Hotel",
                  value: booking.hotelDetail?.name,
                ),
                divider,
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Bookings Details"),
                      ),
                      divider,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int i) {
                            return getBookingDetail(booking.modules![i], i);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              divider,
                          itemCount: booking.modules!.length,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
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
                        value: booking.paymentMethod == null
                            ? "N/A"
                            : booking.paymentMethod?.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Status",
                        value: booking.paymentStatus == null
                            ? "N/A"
                            : booking.paymentStatus?.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Via",
                        value: booking.paymentType == null
                            ? "N/A"
                            : booking.paymentType?.titleCase,
                      ),
                      paymentDetailRow(
                        title: "Initial Total Price",
                        value: booking.totalPrice == null
                            ? "N/A"
                            : "Rs. ${booking.totalPrice}",
                      ),
                      paymentDetailRow(
                        title: "Promotion Discount",
                        value: booking.promotionDiscount == null
                            ? "N/A"
                            : "Rs. ${booking.promotionDiscount}",
                      ),
                      paymentDetailRow(
                        title: "Gift Card Discount",
                        value: booking.giftCard == null
                            ? "N/A"
                            : "Rs. ${booking.giftCard}",
                      ),
                      paymentDetailRow(
                        title: "Reward Point Discount",
                        value: booking.rewardPoints == null
                            ? "N/A"
                            : "Rs. ${booking.rewardPoints}",
                      ),
                      paymentDetailRow(
                        title: "Total Paying Price",
                        value: booking.usePayable == null
                            ? "N/A"
                            : "Rs. ${booking.usePayable}",
                      ),
                      paymentDetailRow(
                        title: "Transcation Date",
                        value: booking.bookedDate == null
                            ? "N/A"
                            : DateTimeFormatter.formatDate(
                                booking.bookedDate as DateTime),
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
          if (flag == 1)
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
                      "Cancel booking",
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
