import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../servies/cubit/tour_booking_detail/tour_booking_detail_cubit.dart';

class TourBookingDetailWidget extends StatefulWidget {
  final TourBookingDetailCubit? cubit;

  const TourBookingDetailWidget({Key? key, this.cubit}) : super(key: key);

  @override
  _TourBookingDetailWidgetState createState() =>
      _TourBookingDetailWidgetState();
}

class _TourBookingDetailWidgetState extends State<TourBookingDetailWidget> {
  TourBookingDetailCubit? cubit;
  GlobalKey<AnimatorWidgetState>? _keyGuestName;
  GlobalKey<AnimatorWidgetState>? _keyGuestPhoneNumber;
  GlobalKey<AnimatorWidgetState>? _keyGuestEmail;

  final guestNameController = TextEditingController();
  final guestPhoneNumberController = TextEditingController();
  final guestEmailController = TextEditingController();

  User? user;
  UserDetail? userDetail;

  bool? bookingForSelf;

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 15,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }

  @override
  void initState() {
    super.initState();
    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();
    cubit = widget.cubit;
    bookingForSelf = true;

    _keyGuestName = GlobalKey<AnimatorWidgetState>();
    _keyGuestPhoneNumber = GlobalKey<AnimatorWidgetState>();
    _keyGuestEmail = GlobalKey<AnimatorWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: Colors.grey.shade700,
    );

    const valueTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 17,
    );

    TextStyle priceTextStyle = const TextStyle(
      fontSize: 14,
      color: Colors.grey,
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.event,
                    color: MyTheme.primaryColor,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tour Package Name",
                        style: headerTextStyle,
                      ),
                      Text(
                        cubit!.tour!.packageName.toString(),
                        style: valueTextStyle,
                      ),
                    ],
                  ),
                ),
                _divider(),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.person_2,
                    color: MyTheme.primaryColor,
                  ),
                  title: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (cubit?.tour?.packageCostingType == "per_person") {
                        cubit?.showGuestCounterDialog(context);
                      } else {
                        showToast(
                          text: "Group size is fixed and cannot be changed.",
                          time: 5,
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Number of guests ",
                          style: headerTextStyle,
                        ),
                        Text(
                          cubit?.noOfGuest?.value == null
                              ? "${cubit?.tour?.groupSize} Guests"
                              : "${cubit?.noOfGuest?.value} Guests",
                          style: valueTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                _divider(),
                ListTile(
                  leading: const PNGIconWidget(
                    asset: "assets/images/calendar.png",
                    color: MyTheme.primaryColor,
                  ),

                  // Icon(
                  //   CupertinoIcons.calendar,
                  //   color: MyTheme.primaryColor,
                  // ),
                  title: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      cubit?.selectDates(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "From",
                              style: headerTextStyle,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              DateTimeFormatter.formatDate(cubit!.checkInDate!),
                              style: valueTextStyle,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "To",
                              style: headerTextStyle,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              DateTimeFormatter.formatDate(
                                  cubit!.checkOutDate!),
                              style: valueTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: 17.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Price Breakdown"),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              cubit?.tour?.packageCostingType == "per_group"
                                  ? "Price per group"
                                  : "Price per person",
                              style: priceTextStyle),
                          Text(
                            cubit?.tour?.packageCostingType == "per_person"
                                ? cubit!.tour!.costPerPerson.toString()
                                : cubit!.tour!.tourCost.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Number of guests", style: priceTextStyle),
                          Text("x${cubit?.noOfGuest?.value}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discount", style: priceTextStyle),
                          cubit?.tour?.offer?.id != null
                              ? Text(cubit?.tour?.offer?.discountPricingType ==
                                      "amount"
                                  ? "Rs. ${cubit?.tour?.packageCostingType}" ==
                                          "per_person"
                                      ? (double.parse(cubit!.tour!.offer!.amount
                                                  .toString()) *
                                              cubit!.noOfGuest!.value)
                                          .toStringAsFixed(2)
                                      : double.parse(cubit!.tour!.offer!.amount
                                              .toString())
                                          .toStringAsFixed(2)
                                  : "${cubit?.tour?.offer?.rate} % off")
                              : const Text("0 %"),
                        ],
                      ),
                      _divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Amount"),
                          Text(cubit!.initialTotalPrice!.toStringAsFixed(2)),
                        ],
                      ),
                    ],
                  ),
                ),
                _divider(),
                Card(
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Contact Person Details"),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Are you booking for yourself?"),
                              Checkbox(
                                value: bookingForSelf,
                                activeColor: MyTheme.primaryColor,
                                onChanged: (x) {
                                  bookingForSelf = x;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: bookingForSelf!,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                                sigmaX: bookingForSelf! ? 2 : 0,
                                sigmaY: bookingForSelf! ? 2 : 0),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text("Enter guest detail below,"),
                                      Text(
                                        "You can tap on field to edit the guest details if you are booking for someone else.",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Shake(
                                  key: _keyGuestName,
                                  preferences: const AnimationPreferences(
                                      autoPlay: AnimationPlayStates.None),
                                  child: ListTile(
                                    leading: const Icon(
                                      CupertinoIcons.person_fill,
                                      color: MyTheme.primaryColor,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Full Name",
                                          style: headerTextStyle,
                                        ),
                                        TextField(
                                          scrollPadding:
                                              const EdgeInsets.all(100),
                                          controller: guestNameController,
                                          style: valueTextStyle,
                                          cursorColor: MyTheme.primaryColor,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter guest full name",
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _divider(),
                                Shake(
                                  key: _keyGuestPhoneNumber,
                                  preferences: const AnimationPreferences(
                                      autoPlay: AnimationPlayStates.None),
                                  child: ListTile(
                                    leading: const Icon(
                                      CupertinoIcons.phone_fill,
                                      color: MyTheme.primaryColor,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Phone Number",
                                          style: headerTextStyle,
                                        ),
                                        TextField(
                                          scrollPadding:
                                              const EdgeInsets.all(100),
                                          controller:
                                              guestPhoneNumberController,
                                          style: valueTextStyle,
                                          keyboardType: TextInputType.number,
                                          cursorColor: MyTheme.primaryColor,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                "Enter guest phone number",
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _divider(),
                                Shake(
                                  key: _keyGuestEmail,
                                  preferences: const AnimationPreferences(
                                      autoPlay: AnimationPlayStates.None),
                                  child: ListTile(
                                    leading: const Icon(
                                      CupertinoIcons.mail_solid,
                                      color: MyTheme.primaryColor,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email",
                                          style: headerTextStyle,
                                        ),
                                        TextField(
                                          scrollPadding:
                                              const EdgeInsets.all(100),
                                          controller: guestEmailController,
                                          style: valueTextStyle,
                                          cursorColor: MyTheme.primaryColor,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter guest email",
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _divider(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 75),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              // height: 75,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
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
              child: ElevatedButton(
                onPressed: () {
                  if (guestNameController.text.isEmpty && !bookingForSelf!) {
                    _keyGuestName?.currentState?.forward();
                  } else if (guestPhoneNumberController.text.length != 10 &&
                      !bookingForSelf!) {
                    _keyGuestPhoneNumber?.currentState?.forward();
                  } else if (guestEmailController.text.isEmpty &&
                      !bookingForSelf! &&
                      !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(guestEmailController.text)) {
                    _keyGuestEmail?.currentState?.forward();
                  } else {
                    cubit?.createBooking(
                      email: bookingForSelf!
                          ? user!.email.toString()
                          : guestEmailController.text,
                      name: bookingForSelf!
                          ? userDetail!.name.toString()
                          : guestNameController.text,
                      number: bookingForSelf!
                          ? userDetail!.contact.toString()
                          : guestPhoneNumberController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Proceed".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
