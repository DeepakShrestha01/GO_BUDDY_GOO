import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../model/rental_booking.dart';
import '../../services/cubit/add_review/add_review_cubit.dart';

class RentalBookingDetailPage extends StatelessWidget {
  const RentalBookingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddReviewCubit(),
      child: const RentalBookingDetailBody(),
    );
  }
}

class RentalBookingDetailBody extends StatefulWidget {
  const RentalBookingDetailBody({super.key});

  @override
  _RentalBookingDetailBodyState createState() =>
      _RentalBookingDetailBodyState();
}

class _RentalBookingDetailBodyState extends State<RentalBookingDetailBody> {
  final RentalBooking booking = Get.arguments[0];

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
                  vechicleInvId: booking.vehicleInventory?.id as int,
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

  showPayDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black12.withOpacity(0.75),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                const Text(
                  "Choose an option",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20.0),
                Column(
                  children: [
                    if (booking.firstInstallmentPaymentStatus!.isEmpty)
                      GestureDetector(
                        onTap: () {
                          Get.back();

                          Get.toNamed("/rentalPayment", arguments: [
                            booking.id,
                            booking.vehicleInventory?.id,
                            "first",
                            booking.installmentPrices?.firstInstallment,
                          ]);
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
                              "Pay 1st Installment",
                              style: MyTheme.mainTextTheme.headline4
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 15.0),
                    if (booking.firstInstallmentPaymentStatus!.isNotEmpty &&
                        (booking.secondInstallment == null &&
                            booking.secondInstallmentPaymentMethod == "online"))
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.toNamed("/rentalPayment", arguments: [
                            booking.id,
                            booking.vehicleInventory?.id,
                            "second",
                            booking.installmentPrices?.secondInstallment
                          ]);
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
                              "Pay 2nd Installment",
                              style: MyTheme.mainTextTheme.headline4
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 15.0),
                    if (booking.firstInstallmentPaymentStatus!.isEmpty &&
                        booking.secondInstallmentPaymentStatus!.isEmpty)
                      GestureDetector(
                        onTap: () {
                          Get.back();

                          Get.toNamed("/rentalPayment", arguments: [
                            booking.id,
                            booking.vehicleInventory?.id,
                            "full",
                            booking.installmentPrices?.totalPrice,
                          ]);
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
                              "Make full payment",
                              style: MyTheme.mainTextTheme.headline4
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          );
        });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rental Booking Detail",
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
                    asset: "assets/images/calendar.png",
                    color: MyTheme.primaryColor,
                  ),
                  label: "Date",
                  value:
                      "${DateTimeFormatter.formatDate(booking.startDate!)} - ${DateTimeFormatter.formatDate(booking.endDate!)}",
                ),
                divider,
                getTile(
                  icon: const PNGIconWidget(
                    asset: "assets/images/bus.png",
                    color: MyTheme.primaryColor,
                  ),
                  label: "Vehicle",
                  value:
                      "${booking.vehicleInventory?.vehicleModel?.vehicleBrand?.name} ${booking.vehicleInventory?.vehicleModel?.model}",
                ),
                divider,
                getTile(
                  icon: const PNGIconWidget(
                    asset: "assets/images/address.png",
                    color: MyTheme.primaryColor,
                  ),
                  label: "Destination",
                  value: booking.destination?.name,
                ),
                divider,
                const SizedBox(height: 20.0),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Payment Details"),
                      ),
                      divider,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("First Installment"),
                          ),
                          paymentDetailRow(
                            title: "Amount",
                            value: booking
                                    .firstInstallmentPaymentStatus!.isEmpty
                                ? "Rs. ${booking.installmentPrices?.firstInstallment}"
                                : "Rs. " + booking.firstInstallment,
                          ),
                          paymentDetailRow(
                            title: "Status",
                            value:
                                booking.firstInstallmentPaymentStatus!.isEmpty
                                    ? "Not paid"
                                    : "Paid",
                          ),
                          if (booking.firstInstallmentPaymentStatus!.isNotEmpty)
                            paymentDetailRow(
                              title: "Medium",
                              value: booking.firstInstallmentPaymentMethod ??
                                  "N/A",
                            ),
                          if (booking.firstInstallmentPaymentStatus!.isNotEmpty)
                            paymentDetailRow(
                              title: "Via",
                              value: booking
                                      .firstElectronicTransactionProviderName ??
                                  "N/A",
                            ),
                        ],
                      ),
                      divider,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Second Installment"),
                          ),
                          paymentDetailRow(
                            title: "Amount",
                            value: booking.secondInstallment == null
                                ? "Rs. ${booking.installmentPrices?.secondInstallment}"
                                : "Rs. " + booking.secondInstallment,
                          ),
                          paymentDetailRow(
                            title: "Status",
                            value: booking.secondInstallment == null
                                ? "Not paid"
                                : "Paid",
                          ),
                          if (booking.secondInstallment != null)
                            paymentDetailRow(
                              title: "Medium",
                              value: booking.secondInstallmentPaymentMethod ??
                                  "N/A",
                            ),
                          if (booking.secondInstallment != null)
                            paymentDetailRow(
                              title: "Via",
                              value: booking
                                      .secondElectronicTransactionProviderName ??
                                  "N/A",
                            ),
                        ],
                      ),
                      divider,
                    ],
                  ),
                ),
                if (booking.invoicePdf!.isNotEmpty)
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
                const SizedBox(height: 100.0),
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
          else if (flag == 1 &&
              (booking.firstInstallmentPaymentStatus!.isEmpty ||
                  (booking.secondInstallment == null &&
                      booking.secondInstallmentPaymentMethod == "online")))
            Positioned(
              bottom: 5,
              child: GestureDetector(
                onTap: () {
                  showPayDialog(context);
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
                      "Pay",
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
