import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/route_manager.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../model/hotel_booking_detail.dart';
import '../../services/cubit/hotel_booking_payment/hotel_booking_payment_cubit.dart';
import '../widgets/filterCard.dart';
import '../widgets/promotion_widget.dart';

class HotelBookingPaymentPage extends StatelessWidget {
  const HotelBookingPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GuestDetailAndPaymentCubit(),
      child: const HotelBookingPaymentBody(),
    );
  }
}

class HotelBookingPaymentBody extends StatefulWidget {
  const HotelBookingPaymentBody({super.key});

  @override
  _HotelBookingPaymentBodyState createState() =>
      _HotelBookingPaymentBodyState();
}

class _HotelBookingPaymentBodyState extends State<HotelBookingPaymentBody> {
  CountdownTimerController? countdownController;

  @override
  void dispose() {
    countdownController?.dispose();
    super.dispose();
  }

  User? user;
  UserDetail? userDetail;

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  GlobalKey<AnimatorWidgetState>? _keyGuestName;
  GlobalKey<AnimatorWidgetState>? _keyGuestPhoneNumber;
  GlobalKey<AnimatorWidgetState>? _keyGuestEmail;

  GuestDetailAndPaymentCubit? cubit;

  bool bookingForSelf = true;

  final giftCodeController = TextEditingController();
  final giftCodeAmountController = TextEditingController();

  final rewardPointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();

    BlocProvider.of<GuestDetailAndPaymentCubit>(context)
        .getBookingModuleIds(Get.arguments[0], Get.arguments[1]);

    BlocProvider.of<GuestDetailAndPaymentCubit>(context).loadBoookingsDetail();

    BlocProvider.of<GuestDetailAndPaymentCubit>(context).getUserPoints();

    BlocProvider.of<GuestDetailAndPaymentCubit>(context).getUserPromotions();

    countdownController = CountdownTimerController(
      endTime: DateTime.now()
          .add(const Duration(minutes: 9, seconds: 59))
          .millisecondsSinceEpoch,
      onEnd: () {
        countdownController?.disposeTimer();
      },
    );
    _keyGuestName = GlobalKey<AnimatorWidgetState>();
    _keyGuestPhoneNumber = GlobalKey<AnimatorWidgetState>();
    _keyGuestEmail = GlobalKey<AnimatorWidgetState>();

    cubit = BlocProvider.of<GuestDetailAndPaymentCubit>(context);
  }

  showSureDialog(BuildContext context) {
    showDialog(
      builder: (context) => AlertDialog(
        content: Text(
          "You are about to cancel your current booking and go back. Are you sure to continue?",
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
            onPressed: () async {
              Get.back();
              await cubit?.cancelBooking();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: MyTheme.primaryColor,
            ),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      context: context,
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showSureDialog(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Booking Confirmation",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Colors.white)),
          leading: GestureDetector(
            onTap: () async {
              showSureDialog(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: CountdownTimer(
                controller: countdownController,
                textStyle: const TextStyle(color: Colors.white),
                widgetBuilder: (_, CurrentRemainingTime? time) {
                  if (time == null) {
                    return const Text('00:00',
                        style: TextStyle(color: Colors.white));
                  }
                  String minString = "0${time.min ?? 0}";

                  String secString = time.sec.toString().length == 1
                      ? "0${time.sec ?? 0}"
                      : time.sec.toString();

                  return Text('$minString:$secString',
                      style: const TextStyle(color: Colors.white));
                },
              ),
            ),
            const SizedBox(width: 5),
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
        body:
            BlocBuilder<GuestDetailAndPaymentCubit, GuestDetailAndPaymentState>(
          builder: (context, state) {
            if (state is HotelBookingPaymentInitial ||
                state is GuestDetailLoading) {
              return AbsorbPointer(
                absorbing: state is GuestDetailLoading,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17.5, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Are you booking for yourself?"),
                          Checkbox(
                            value: bookingForSelf,
                            activeColor: MyTheme.primaryColor,
                            onChanged: (x) {
                              bookingForSelf = x!;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: bookingForSelf,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                            sigmaX: bookingForSelf ? 2 : 0,
                            sigmaY: bookingForSelf ? 2 : 0),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17.5),
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
                                const SizedBox(height: 10),
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: fullNameController,
                                          cursorColor: MyTheme.primaryColor,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17,
                                          ),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            hintText: "Enter guest name",
                                            border: InputBorder.none,
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
                                          "Contact Number",
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: phoneNumberController,
                                          cursorColor: MyTheme.primaryColor,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17,
                                          ),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            hintText:
                                                "Enter guest contact number",
                                            border: InputBorder.none,
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
                                          "Email Address",
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: emailController,
                                          cursorColor: MyTheme.primaryColor,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17,
                                          ),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            hintText: "Enter guest email",
                                            border: InputBorder.none,
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            if (bookingForSelf) {
                              if (countdownController?.currentRemainingTime !=
                                  null) {
                                cubit?.registerGuest(
                                  userDetail!.name.toString(),
                                  userDetail!.contact.toString(),
                                  user!.email.toString(),
                                );
                              } else {
                                showToast(
                                  text:
                                      "Payment time expired. Go back and check availability again.",
                                  time: 5,
                                );
                              }
                            } else {
                              if (fullNameController.text.isEmpty) {
                                _keyGuestName?.currentState?.forward();
                              } else if (phoneNumberController.text.length !=
                                  10) {
                                _keyGuestPhoneNumber?.currentState?.forward();
                              } else if (emailController.text.isEmpty) {
                                _keyGuestEmail?.currentState?.forward();
                              } else {
                                if (countdownController?.currentRemainingTime !=
                                    null) {
                                  cubit?.registerGuest(
                                    fullNameController.text,
                                    phoneNumberController.text,
                                    emailController.text,
                                  );
                                } else {
                                  showToast(
                                    text:
                                        "Payment time expired. Go back and check availability again.",
                                    time: 5,
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: MyTheme.primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: state is GuestDetailLoading
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        "Proceed",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is GuestDetailSuccess ||
                state is PaymentProcessing) {
              double totalBookingPrice = 0.0;
              for (HotelBookingDetail booking in cubit!.bookings!) {
                totalBookingPrice += booking.totalPrice!;
              }
              return AbsorbPointer(
                absorbing: state is PaymentProcessing,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 8.0, left: 8.0),
                                    child: Text(
                                      "Pricing Detail",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: cubit!.bookings!.length,
                                    separatorBuilder: (context, i) {
                                      return divider();
                                    },
                                    itemBuilder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Booking ${i + 1}"),
                                            Text(
                                              "Rs. ${cubit?.bookings?[i].totalPrice?.toStringAsFixed(2)}",
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Total Price",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Rs. ${totalBookingPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (cubit!.availablePromotions!.isNotEmpty)
                            promotionWidget(),
                          const SizedBox(height: 10),
                          giftCodeWidget(),
                          const SizedBox(height: 10),
                          rewardPointWidget(),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: priceAndPaymentWidget(),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text("Error"),
            );
          },
        ),
      ),
    );
  }

  Widget giftCodeWidget() {
    return ExpandedTileWidget(
      titleWidget: const Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          "Use Gift Card",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      expandedWidgets: [
        Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          child: cubit?.giftCard == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Enter gift code below"),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextField(
                              controller: giftCodeController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Gift Code",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            cubit?.getGiftCardDetail(giftCodeController.text);
                            giftCodeController.clear();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "Reedem",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cubit!.giftCardCode.toString()),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            cubit?.removeGiftCard();
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "Remove",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Gift Card amount"),
                        Text("Rs. ${cubit?.giftCard?.amount}"),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextField(
                              controller: giftCodeAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Amount you want to use",
                                prefixText: "Rs. ",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            cubit?.useGiftCard(giftCodeAmountController.text);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "Apply",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
      subtitleWidget: null,
      leadingWidget: null,
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: false,
      titlePadding: EdgeInsets.zero,
    );
  }

  Widget priceAndPaymentWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: WideButton(
        onTap: showPaymentOptions,
        text: "Pay Rs. ${cubit?.finalTotalPrice.toStringAsFixed(2)}",
        color: MyTheme.primaryColor,
        context: context,
        icon: null,
        textColor: Colors.white,
      ),
    );
  }

  showPaymentOptions() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black12.withOpacity(0.75),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.65,
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
                  "Payment Options",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20.0),
                Wrap(
                  spacing: 40.0,
                  runSpacing: 40.0,
                  alignment: WrapAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (countdownController?.currentRemainingTime != null) {
                          cubit?.payAtCounter();
                        } else {
                          showToast(
                            text:
                                "Payment time expired. Go back, check availability again and proceed further.",
                            time: 5,
                          );
                        }
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset(
                              "assets/images/counter.png",
                              color: MyTheme.primaryColor,
                            ),
                          ),
                          const Text("Pay at Counter"),
                        ],
                      ),
                    ),
                    // khalti
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (countdownController?.currentRemainingTime != null) {
                          String minString = countdownController
                                      ?.currentRemainingTime?.min ==
                                  null
                              ? "0"
                              : countdownController!.currentRemainingTime!.min
                                  .toString();

                          String secString = countdownController
                                      ?.currentRemainingTime?.sec ==
                                  null
                              ? "0"
                              : countdownController!.currentRemainingTime!.sec
                                  .toString();

                          String timeRemText =
                              "$minString minutes and $secString seconds ";

                          showToast(
                            text: "You have $timeRemText to make the payment.",
                            time: 5,
                          );

                          KhaltiScope.of(context).pay(
                            config: PaymentConfig(
                              amount: (cubit!.finalTotalPrice * 100).toInt(),
                              productIdentity:
                                  "hotel_${randomAlphaNumeric(10)}",
                              productUrl: callBackUrl,
                              productName:
                                  "Go Buddy Goo Payment for ${cubit?.bookings?[0].hotelName}",
                            ),
                            preferences: [
                              PaymentPreference.khalti,
                            ],
                            onSuccess: (result) {
                              if (countdownController?.currentRemainingTime !=
                                  null) {
                                // print(result);
                                cubit?.pay("khalti", result.token);
                              } else {
                                showToast(
                                  text:
                                      "Payment time expired. Go back, check availability again and proceed further.",
                                  time: 5,
                                );
                              }
                            },
                            onFailure: (result) {
                              showToast(
                                text: "Khalti Payment Error: ${result.message}",
                              );
                            },
                          );
                        } else {
                          showToast(
                            text:
                                "Payment time expired. Go back, check availability again and proceed further.",
                            time: 5,
                          );
                        }
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/khalti.png",
                            height: 50,
                          ),
                          const Text("Pay with Khalti"),
                        ],
                      ),
                    ),

                    // connectIPS

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (countdownController?.currentRemainingTime != null) {
                          String minString = countdownController
                                      ?.currentRemainingTime?.min ==
                                  null
                              ? "0"
                              : countdownController!.currentRemainingTime!.min
                                  .toString();

                          String secString = countdownController
                                      ?.currentRemainingTime?.sec ==
                                  null
                              ? "0"
                              : countdownController!.currentRemainingTime!.sec
                                  .toString();

                          String timeRemText =
                              "$minString minutes and $secString seconds ";

                          showToast(
                            text: "You have $timeRemText to make the payment.",
                            time: 5,
                          );

                          KhaltiScope.of(context).pay(
                            config: PaymentConfig(
                              amount: (cubit!.finalTotalPrice * 100).toInt(),
                              productIdentity:
                                  "hotel_${randomAlphaNumeric(10)}",
                              productUrl: callBackUrl,
                              productName:
                                  "Go Buddy Goo Payment for ${cubit?.bookings?[0].hotelName}",
                            ),
                            preferences: [
                              PaymentPreference.connectIPS,
                            ],
                            onSuccess: (result) {
                              if (countdownController?.currentRemainingTime !=
                                  null) {
                                // print(result);
                                cubit?.pay("connectIPS", result.token);
                              } else {
                                showToast(
                                  text:
                                      "Payment time expired. Go back, check availability again and proceed further.",
                                  time: 5,
                                );
                              }
                            },
                            onFailure: (result) {
                              showToast(
                                text:
                                    "ConnectIPS Payment Error: ${result.message}",
                              );
                            },
                          );
                        } else {
                          showToast(
                            text:
                                "Payment time expired. Go back, check availability again and proceed further.",
                            time: 5,
                          );
                        }
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/connectips.png",
                            height: 50,
                          ),
                          const Text("Pay with ConnectIPS"),
                        ],
                      ),
                    ),

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (countdownController?.currentRemainingTime != null) {
                          // ESewaConfiguration configuration = ESewaConfiguration(
                          //   clientID: eSewaClientId,
                          //   secretKey: eSewaClientSecret,

                          //   // clientID:
                          //   //     "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
                          //   // secretKey:
                          //   //     "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
                          //   environment:
                          //       // ESewaConfiguration.ENVIRONMENT_TEST
                          //       ESewaConfiguration.ENVIRONMENT_LIVE,
                          // );

                          // ESewaPnp eSewaPnp =
                          //     ESewaPnp(configuration: configuration);

                          // ESewaPayment payment = ESewaPayment(
                          //   amount: cubit.finalTotalPrice,
                          //   productName:
                          //       "Go Buddy Goo Payment for ${cubit.bookings[0].hotelName}",
                          //   productID: "hotel_${randomAlphaNumeric(10)}",
                          //   callBackURL: callBackUrl,
                          // );

                          // try {
                          //   final res =
                          //       await eSewaPnp.initPayment(payment: payment);

                          //   if (res.status == "COMPLETE") {
                          //     if (countdownController.currentRemainingTime !=
                          //         null) {
                          //       print(res);
                          //       // cubit.pay("esewa", _res.referenceId);
                          //     } else {
                          //       showToast(
                          //         text:
                          //             "Payment time expired. Go back, check availability again and proceed further.",
                          //         time: 5,
                          //       );
                          //     }
                          //   } else {
                          //     showToast(
                          //         text: "Some error occured! Try Again!!");
                          //   }
                          // } on ESewaPaymentException catch (e) {
                          //   showToast(text: e.message);
                          // }
                        } else {
                          showToast(
                            text:
                                "Payment time expired. Go back, check availability again and proceed further.",
                            time: 5,
                          );
                        }
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/esewa.png",
                            height: 50,
                          ),
                          const Text("Pay with eSewa"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget promotionWidget() {
    return ExpandedTileWidget(
      titleWidget: const Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          "Apply Promotions",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      expandedWidgets: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: List<Widget>.generate(
                  cubit!.availablePromotions!.length, (i) {
            return HotelPromotionWidget(
              promotion: cubit?.availablePromotions?[i],
              isSelected: cubit?.selectedPromotion?.promotionId ==
                  cubit?.availablePromotions?[i].promotionId,
              onTap: () {
                if (cubit?.selectedPromotion?.promotionId ==
                    cubit?.availablePromotions?[i].promotionId) {
                  cubit?.removePromotion();
                } else {
                  cubit?.applyPromotion(cubit!.availablePromotions![i]);
                }
                setState(() {});
              },
            );
          })),
        ),
      ],
      subtitleWidget: null,
      leadingWidget: null,
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: false,
      titlePadding: EdgeInsets.zero,
    );
  }

  Widget rewardPointWidget() {
    return ExpandedTileWidget(
      titleWidget: const Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          "Use Reward Points",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: false,
      titlePadding: EdgeInsets.zero,
      expandedWidgets: [
        double.parse(cubit!.userPoints!.data!.usablePoints.toString()) != 0.0
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Reward Points"),
                        Text(
                          cubit!.userPoints!.data!.usablePoints.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextField(
                              controller: rewardPointController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Points you want to use",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            cubit?.useRewardPoints(rewardPointController.text);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "Apply",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "You don't have enough reward points to reedem for cash as of now."),
              ),
      ],
      leadingWidget: null,
      subtitleWidget: null,
    );
  }
}
