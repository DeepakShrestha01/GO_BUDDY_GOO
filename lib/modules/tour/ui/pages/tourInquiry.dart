import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/theme.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../servies/cubit/tour_inquiry/tour_inquiry_cubit.dart';

class TourInquiryPage extends StatelessWidget {
  const TourInquiryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TourInquiryCubit(),
      child: const TourInquiryBody(),
    );
  }
}

class TourInquiryBody extends StatefulWidget {
  const TourInquiryBody({super.key});

  @override
  _TourInquiryBodyState createState() => _TourInquiryBodyState();
}

class _TourInquiryBodyState extends State<TourInquiryBody> {
  GlobalKey<AnimatorWidgetState>? _keyDestination;
  GlobalKey<AnimatorWidgetState>? _keyMealType;
  GlobalKey<AnimatorWidgetState>? _keyHotelType;
  GlobalKey<AnimatorWidgetState>? _keyGuestPhoneNumber;
  GlobalKey<AnimatorWidgetState>? _keyGuestName;

  final destinationController = TextEditingController();

  final guestNameController = TextEditingController();
  final guestPhoneNumberController = TextEditingController();

  String? selectedHotelType;
  String? selectedMealType;

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  User? user;
  UserDetail? userDetail;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<TourInquiryCubit>(context).getHotelTypes();
    BlocProvider.of<TourInquiryCubit>(context).getMealTypes();

    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();
    guestNameController.text = userDetail?.name ?? "";
    guestPhoneNumberController.text = userDetail?.contact ?? "";

    _keyDestination = GlobalKey<AnimatorWidgetState>();
    _keyMealType = GlobalKey<AnimatorWidgetState>();
    _keyHotelType = GlobalKey<AnimatorWidgetState>();
    _keyGuestName = GlobalKey<AnimatorWidgetState>();
    _keyGuestPhoneNumber = GlobalKey<AnimatorWidgetState>();

    selectedHotelType = "Select";
    selectedMealType = "Select";
  }

  Widget divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 15,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TourInquiryCubit cubit = BlocProvider.of<TourInquiryCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inquiry about tour",
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
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Shake(
                    key: _keyDestination,
                    preferences: const AnimationPreferences(
                        autoPlay: AnimationPlayStates.None),
                    child: ListTile(
                      leading: const Icon(
                        Icons.room,
                        color: MyTheme.primaryColor,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Destination (Trek Route)",
                            style: headerTextStyle,
                          ),
                          TextField(
                            controller: destinationController,
                            style: valueTextStyle,
                            cursorColor: MyTheme.primaryColor,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter your destination trek detail",
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
                    key: _keyHotelType,
                    preferences: const AnimationPreferences(
                        autoPlay: AnimationPlayStates.None),
                    child: ListTile(
                      leading: const Icon(
                        Icons.hotel,
                        color: MyTheme.primaryColor,
                      ),
                      title: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preferred Hotel Type",
                              style: headerTextStyle,
                            ),
                            DropdownButton(
                              isDense: true,
                              underline: const SizedBox(),
                              icon: const SizedBox(),
                              items: List<DropdownMenuItem>.generate(
                                  cubit.hotelTypes!.length, (i) {
                                return DropdownMenuItem(
                                  value: i,
                                  onTap: () {
                                    cubit.selectedHotelTypesIndex = i;
                                    selectedHotelType = cubit.hotelTypes?[i];
                                    setState(() {});
                                  },
                                  child: Text(cubit.hotelTypes![i]),
                                );
                              }),
                              onChanged: (value) {},
                              hint: Text(
                                selectedHotelType.toString(),
                                style: valueTextStyle.copyWith(
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  divider(),
                  Shake(
                    key: _keyMealType,
                    preferences: const AnimationPreferences(
                        autoPlay: AnimationPlayStates.None),
                    child: ListTile(
                      leading: const Icon(
                        Icons.food_bank,
                        color: MyTheme.primaryColor,
                      ),
                      title: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preferred Meal Type",
                              style: headerTextStyle,
                            ),
                            DropdownButton(
                              isDense: true,
                              underline: const SizedBox(),
                              icon: const SizedBox(),
                              items: List<DropdownMenuItem>.generate(
                                  cubit.mealTypes!.length, (i) {
                                return DropdownMenuItem(
                                  value: i,
                                  onTap: () {
                                    cubit.selectedMealTypesIndex = i;
                                    selectedMealType = cubit.mealTypes?[i];
                                    setState(() {});
                                  },
                                  child: Text(cubit.mealTypes![i]),
                                );
                              }),
                              onChanged: (value) {},
                              hint: Text(
                                selectedMealType.toString(),
                                style: valueTextStyle.copyWith(
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  divider(),
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.person_2_fill,
                      color: MyTheme.primaryColor,
                    ),
                    title: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        cubit.showGuestCounterDialog(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No of Guests",
                            style: headerTextStyle,
                          ),
                          ValueListenableBuilder(
                            builder: (context, value, child) {
                              return Text(
                                "${cubit.noOfGuests?.value} Guests",
                                style: valueTextStyle.copyWith(
                                    color: Colors.black),
                              );
                            },
                            valueListenable: cubit.noOfGuests!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.cloud_queue_outlined,
                      color: MyTheme.primaryColor,
                    ),
                    title: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        cubit.showDaysCounterDialog(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No of Days",
                            style: headerTextStyle,
                          ),
                          ValueListenableBuilder(
                            builder: (context, value, child) {
                              return Text(
                                "${cubit.noOfDays?.value} Days",
                                style: valueTextStyle.copyWith(
                                    color: Colors.black),
                              );
                            },
                            valueListenable: cubit.noOfDays!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  divider(),
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
                            "Guest Name",
                            style: headerTextStyle,
                          ),
                          TextField(
                            controller: guestNameController,
                            style: valueTextStyle,
                            cursorColor: MyTheme.primaryColor,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter guest name",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Guest Contact Number",
                            style: headerTextStyle,
                          ),
                          TextField(
                            controller: guestPhoneNumberController,
                            style: valueTextStyle,
                            cursorColor: MyTheme.primaryColor,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter guest contact number",
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
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
            Positioned(
              bottom: 0,
              child: Container(
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
                    if (destinationController.text.isEmpty) {
                      _keyDestination?.currentState?.forward();
                    } else if (cubit.selectedHotelTypesIndex == null) {
                      _keyHotelType?.currentState?.forward();
                    } else if (cubit.selectedMealTypesIndex == null) {
                      _keyMealType?.currentState?.forward();
                    } else if (guestNameController.text.isEmpty) {
                      _keyGuestName?.currentState?.forward();
                    } else if (guestPhoneNumberController.text.isEmpty) {
                      _keyGuestPhoneNumber?.currentState?.forward();
                    } else {
                      showToast(text: destinationController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: MyTheme.primaryColor,
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
      ),
    );
  }
}
