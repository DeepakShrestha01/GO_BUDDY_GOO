import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/model/city_list.dart';
import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../services/cubit/rental_booking_detail/booking_detail_cubit.dart';

class RentalBookingDetail extends StatefulWidget {
  final RentalBookingDetailCubit? cubit;

  const RentalBookingDetail({Key? key, this.cubit}) : super(key: key);

  @override
  _RentalBookingDetailState createState() => _RentalBookingDetailState();
}

class _RentalBookingDetailState extends State<RentalBookingDetail> {
  RentalBookingDetailCubit? cubit;
  final destinationController = TextEditingController();
  final guestNameController = TextEditingController();
  final guestPhoneNumberController = TextEditingController();
  final guestEmailController = TextEditingController();
  final pickUpController = TextEditingController();

  GlobalKey<AnimatorWidgetState>? _keyDestination;
  GlobalKey<AnimatorWidgetState>? _keyGuestName;
  GlobalKey<AnimatorWidgetState>? _keyGuestPhoneNumber;
  GlobalKey<AnimatorWidgetState>? _keyGuestEmail;
  GlobalKey<AnimatorWidgetState>? _keyPickUp;

  User? user;
  UserDetail? userDetail;

  CityList? cityList;
  bool? bookingForSelf;

  @override
  void initState() {
    super.initState();
    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();
    bookingForSelf = true;

    cityList = locator<CityList>();
    cubit = widget.cubit;
    cubit?.pickUpId = cubit?.vehicle?.vehicleLocation;
    pickUpController.text =
        cityList?.getCityName(cubit!.vehicle!.vehicleLocation!);

    _keyDestination = GlobalKey<AnimatorWidgetState>();
    _keyGuestName = GlobalKey<AnimatorWidgetState>();
    _keyGuestPhoneNumber = GlobalKey<AnimatorWidgetState>();
    _keyGuestEmail = GlobalKey<AnimatorWidgetState>();
    _keyPickUp = GlobalKey<AnimatorWidgetState>();
  }

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
                  leading: const PNGIconWidget(
                    asset: "assets/images/bus.png",
                    color: MyTheme.primaryColor,
                  ),

                  // Icon(
                  //   CupertinoIcons.bus,
                  //   color: MyTheme.primaryColor,
                  // ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   cubit.companyName ?? "",
                      //   style: headerTextStyle,
                      // ),
                      Text(
                        cubit!.vehicleName!.titleCase,
                        style: valueTextStyle,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  height: 15,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
                Shake(
                  key: _keyDestination,
                  preferences: const AnimationPreferences(
                      autoPlay: AnimationPlayStates.None),
                  child: ListTile(
                    leading: const PNGIconWidget(
                      asset: "assets/images/address.png",
                      color: MyTheme.primaryColor,
                    ),

                    // Icon(
                    //   Icons.room,
                    //   color: MyTheme.primaryColor,
                    // ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Destination",
                          style: headerTextStyle,
                        ),
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            autofocus: false,
                            controller: destinationController,
                            style: valueTextStyle,
                            cursorColor: MyTheme.primaryColor,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter your destination",
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return cityList?.getPatternCities(pattern);
                          },
                          itemBuilder: (context, dynamic suggestion) {
                            return ListTile(
                              title: Text(suggestion.name),
                            );
                          },
                          onSuggestionSelected: (dynamic suggestion) {
                            destinationController.text = suggestion.name;
                            cubit?.destination = suggestion.name;
                            cubit?.destinationId = suggestion.id;

                            setState(() {});
                          },
                          noItemsFoundBuilder: (context) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "No cities found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  height: 15,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
                Shake(
                  key: _keyPickUp,
                  preferences: const AnimationPreferences(
                      autoPlay: AnimationPlayStates.None),
                  child: ListTile(
                    leading: const Icon(
                      Icons.room,
                      color: MyTheme.primaryColor,
                    ),

                    // Icon(
                    //   CupertinoIcons.bus,
                    //   color: MyTheme.primaryColor,
                    // ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pickup Location",
                          style: headerTextStyle,
                        ),
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            autofocus: false,
                            enabled: false,
                            controller: pickUpController,
                            style: valueTextStyle,
                            cursorColor: MyTheme.primaryColor,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter pickup location",
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return cityList?.getPatternCities(pattern);
                          },
                          itemBuilder: (context, dynamic suggestion) {
                            return ListTile(
                              title: Text(suggestion.name),
                            );
                          },
                          onSuggestionSelected: (dynamic suggestion) {
                            pickUpController.text = suggestion.name;
                            cubit?.pickUp = suggestion.name;
                            cubit?.pickUpId = suggestion.id;

                            setState(() {});
                          },
                          noItemsFoundBuilder: (context) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "No cities found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  height: 15,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
                ListTile(
                  leading: const PNGIconWidget(
                    asset: "assets/images/calendar.png",
                    color: MyTheme.primaryColor,
                  ),

                  // Icon(
                  //   CupertinoIcons.calendar,
                  //   color: MyTheme.primaryColor,
                  // ),
                  title: Theme(
                    data: Theme.of(context).copyWith(
                      brightness: Brightness.light,
                      colorScheme: ColorScheme.fromSwatch()
                          .copyWith(secondary: MyTheme.primaryColor),
                    ),
                    child: Builder(
                      builder: (context) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // cubit?.selectDates(context);
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
                                    DateTimeFormatter.formatDate(
                                        cubit!.checkInDate!),
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
                        );
                      },
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  height: 15,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
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
                                divider(),
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
                                divider(),
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
                        divider(),
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
            child:
                BlocBuilder<RentalBookingDetailCubit, RentalBookingDetailState>(
              builder: (context, state) {
                return Container(
                  // height: 75,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
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
                      if (destinationController.text.isEmpty ||
                          cubit?.destinationId == null ||
                          destinationController.text.toLowerCase() !=
                              cityList
                                  ?.getCityName(cubit?.destinationId ?? -1)
                                  .toLowerCase()) {
                        _keyDestination?.currentState?.forward();
                      } else if (guestNameController.text.isEmpty &&
                          !bookingForSelf!) {
                        _keyGuestName?.currentState?.forward();
                      } else if (guestPhoneNumberController.text.length != 10 &&
                          !bookingForSelf!) {
                        _keyGuestPhoneNumber?.currentState?.forward();
                      } else if (guestEmailController.text.isEmpty &&
                          !bookingForSelf!) {
                        _keyGuestEmail?.currentState?.forward();
                      } else if (pickUpController.text.isEmpty ||
                          cubit?.pickUpId == null ||
                          pickUpController.text.toLowerCase() !=
                              cityList
                                  ?.getCityName(cubit?.pickUpId ?? -1)
                                  .toLowerCase()) {
                        _keyPickUp?.currentState?.forward();
                      } else {
                        cubit?.bookRentalVehicle(
                          bookingForSelf!
                              ? userDetail!.name.toString()
                              : guestNameController.text,
                          bookingForSelf!
                              ? userDetail!.contact.toString()
                              : guestPhoneNumberController.text,
                          bookingForSelf!
                              ? user!.email.toString()
                              : guestEmailController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: MyTheme.primaryColor,
                    ),
                    child: state is BookingDetailBooking
                        ? const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
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
          ),
        ],
      ),
    );
  }
}
