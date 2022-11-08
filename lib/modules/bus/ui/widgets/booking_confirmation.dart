import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_animator/widgets/animator_widget.dart';
import 'package:flutter_animator/widgets/attention_seekers/shake.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../services/cubit/bus_booking/bus_booking_cubit.dart';

class BookingConfirmationW extends StatefulWidget {
  final CountdownTimerController? countDownController;
  final BusBookingCubit? cubit;

  const BookingConfirmationW({Key? key, this.countDownController, this.cubit})
      : super(key: key);
  @override
  _BookingConfirmationWState createState() => _BookingConfirmationWState();
}

class _BookingConfirmationWState extends State<BookingConfirmationW> {
  GlobalKey<AnimatorWidgetState>? _keyGuestName;
  GlobalKey<AnimatorWidgetState>? _keyGuestPhoneNumber;
  GlobalKey<AnimatorWidgetState>? _keyGuestEmail;
  GlobalKey<AnimatorWidgetState>? _keyGuestBoardingArea;

  final guestNameController = TextEditingController();
  final guestPhoneNumberController = TextEditingController();
  final guestEmailController = TextEditingController();

  String boardingArea = "Select";

  User? user;
  UserDetail? userDetail;

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 15,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }

  bool? bookingForSelf;

  @override
  void initState() {
    super.initState();
    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();

    bookingForSelf = true;

    _keyGuestName = GlobalKey<AnimatorWidgetState>();
    _keyGuestPhoneNumber = GlobalKey<AnimatorWidgetState>();
    _keyGuestEmail = GlobalKey<AnimatorWidgetState>();
    _keyGuestBoardingArea = GlobalKey<AnimatorWidgetState>();

    BlocProvider.of<BusBookingCubit>(context).initialBusBooking();
  }

  final headingStyle = const TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );
  @override
  Widget build(BuildContext context) {
    // final BusBookingCubit cubit = BlocProvider.of<BusBookingCubit>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bus Details"),
                    const SizedBox(height: 5),
                    ListTile(
                      leading: const PNGIconWidget(
                        asset: "assets/images/bus.png",
                        color: MyTheme.primaryColor,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cubit!.parameters!.selectedBus!.busTag
                                .toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.navigation,
                        color: MyTheme.primaryColor,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Route",
                            style: headerTextStyle,
                          ),
                          Text(
                            "${widget.cubit?.parameters?.from} - ${widget.cubit?.parameters?.to}",
                            style: valueTextStyle,
                          ),
                        ],
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
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: headerTextStyle,
                          ),
                          Text(
                            DateTimeFormatter.formatDate(
                                widget.cubit!.parameters!.departureDate!),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Full Name",
                                      style: headerTextStyle,
                                    ),
                                    TextField(
                                      controller: guestNameController,
                                      style: valueTextStyle,
                                      cursorColor: MyTheme.primaryColor,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter passenger full name",
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phone Number",
                                      style: headerTextStyle,
                                    ),
                                    TextField(
                                      controller: guestPhoneNumberController,
                                      style: valueTextStyle,
                                      keyboardType: TextInputType.number,
                                      cursorColor: MyTheme.primaryColor,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            "Enter passenger phone number",
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: headerTextStyle,
                                    ),
                                    TextField(
                                      controller: guestEmailController,
                                      style: valueTextStyle,
                                      cursorColor: MyTheme.primaryColor,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter passenger email",
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
                    if (widget.cubit!.parameters!.selectedBus!.boardingAreaList!
                        .isNotEmpty)
                      Shake(
                        key: _keyGuestBoardingArea,
                        preferences: const AnimationPreferences(
                            autoPlay: AnimationPlayStates.None),
                        child: ListTile(
                          leading: const Icon(
                            Icons.place,
                            color: MyTheme.primaryColor,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Boarding Area",
                                style: headerTextStyle,
                              ),
                              DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                underline: Container(),
                                hint: Text(
                                  boardingArea.titleCase,
                                  style: valueTextStyle.copyWith(
                                      color: Colors.black),
                                ),
                                items: List<DropdownMenuItem>.generate(
                                    widget.cubit!.parameters!.selectedBus!
                                        .boardingAreaList!.length, (i) {
                                  return DropdownMenuItem(
                                    value: i,
                                    onTap: () {
                                      boardingArea = widget.cubit!.parameters!
                                          .selectedBus!.boardingAreaList![i][0];
                                      setState(() {});
                                    },
                                    child: Text(
                                        "${"${widget.cubit!.parameters!.selectedBus!.boardingAreaList![i][0].titleCase} (${DateTimeFormatter.formatTime(widget.cubit!.parameters!.selectedBus!.boardingAreaList![i][1])}"})"),
                                  );
                                }),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Shake(
                        key: _keyGuestBoardingArea,
                        child: const SizedBox(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<BusBookingCubit, BusBookingState>(
              builder: (context, state) {
                return AbsorbPointer(
                  absorbing: state is BusBookingLoading,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget.cubit!.parameters!.selectedBus!
                          .boardingAreaList!.isEmpty) {
                        boardingArea = "none";
                      }
                      if (guestNameController.text.isEmpty &&
                          !bookingForSelf!) {
                        _keyGuestName?.currentState?.forward();
                      } else if (guestPhoneNumberController.text.length != 10 &&
                          !bookingForSelf!) {
                        _keyGuestPhoneNumber?.currentState?.forward();
                      } else if (guestEmailController.text.isEmpty &&
                          !bookingForSelf!) {
                        _keyGuestEmail?.currentState?.forward();
                      } else if (boardingArea.isEmpty ||
                          boardingArea.toLowerCase() == "select") {
                        _keyGuestBoardingArea?.currentState?.forward();
                      } else {
                        if (widget.countDownController?.currentRemainingTime !=
                            null) {
                          widget.cubit?.saveGuestDetail(
                            name: bookingForSelf!
                                ? userDetail?.name
                                : guestNameController.text,
                            email: bookingForSelf!
                                ? user?.email
                                : guestEmailController.text,
                            phoneNumber: bookingForSelf!
                                ? userDetail?.contact
                                : guestPhoneNumberController.text,
                            boarding: boardingArea,
                          );
                        } else {
                          showToast(
                            text:
                                "Payment time expired. Start the process again.",
                            time: 5,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryColor,
                    ),
                    child: state is BusBookingLoading
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Row(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
