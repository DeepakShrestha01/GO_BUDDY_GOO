import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo/configs/theme.dart';
import 'package:go_buddy_goo/modules/bus_new/model/new_bus_search_list_response.dart';
import 'package:go_buddy_goo/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:go_buddy_goo/modules/bus_new/services/cubit/bus_booking/bus_booking_cubit.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/keys.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../services/cubit/new_bus_search_result/bus_search_list_cubit.dart';

class NewBusBoardingPoints extends StatefulWidget {
  const NewBusBoardingPoints({super.key});

  @override
  State<NewBusBoardingPoints> createState() => _NewBusBoardingPointsState();
}

class _NewBusBoardingPointsState extends State<NewBusBoardingPoints> {
  List<String>? listboarding;
  List<String>? selectedSeats = Get.arguments[1];

  // List<dynamic> listofSelectedSeats = [];

  String? selectedLocation;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<AnimatorWidgetState>? _keyEmail;
  GlobalKey<AnimatorWidgetState>? _keyFullName;
  GlobalKey<AnimatorWidgetState>? _keyAge;
  final locationController = TextEditingController();
  final contactNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  User? user;
  UserDetail? userDetail;

  // List<PassengerDetails> passengerDetails = [];
  List<TextEditingController> passengerFullNameController = [];
  List<TextEditingController> passengerAgeController = [];

  Buses bus = Get.arguments[0];
  NewBusSearchListParameters parameters = NewBusSearchListParameters();

  NewBusBookingCubit cubit = NewBusBookingCubit();
  String nextPaymentMethod = "online";
  @override
  void initState() {
    NewBusBookingCubit cubit = BlocProvider.of<NewBusBookingCubit>(context);
    _keyAge = GlobalKey<AnimatorWidgetState>();
    _keyEmail = GlobalKey<AnimatorWidgetState>();
    _keyFullName = GlobalKey<AnimatorWidgetState>();

    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();
    listboarding ??= listboarding;
    for (var i = -1; i < selectedSeats!.length; i++) {
      passengerFullNameController.add(TextEditingController());
      passengerAgeController.add(TextEditingController());
    }

    super.initState();
  }

  showTitleMenu(BuildContext context, Offset offset) async {
    return showMenu(
      context: context,
      items: List<PopupMenuEntry>.generate(listboarding!.length, (i) {
        return PopupMenuItem(
          value: i,
          child: Text(listboarding![i]),
        );
      }),
      position: RelativeRect.fromLTRB(
        50,
        offset.dy,
        MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buses Boarding Points',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Enter Your Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w200),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Contact Name",
                      style: headerTextStyle,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: contactNameController
                        ..text = userDetail!.name.toString(),
                      style: const TextStyle(fontSize: 14),
                      cursorColor: MyTheme.primaryColor,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        errorStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                divider(),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone Number",
                      style: headerTextStyle,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: phoneNumberController
                        ..text = userDetail!.contact.toString(),
                      style: const TextStyle(fontSize: 14),
                      cursorColor: MyTheme.primaryColor,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        // hintText: "Enter your password",
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        errorStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                divider(),
                const SizedBox(height: 10),
                Shake(
                  key: _keyEmail,
                  preferences: const AnimationPreferences(
                      autoPlay: AnimationPlayStates.None),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email Address",
                        style: headerTextStyle,
                      ),
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(fontSize: 14),
                        cursorColor: MyTheme.primaryColor,
                        validator: (x) {
                          if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(x.toString())) {
                            _keyEmail?.currentState?.forward();

                            return "Enter your valid email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your Email Address",
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          errorStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                divider(),
                const SizedBox(height: 10),
                BlocBuilder<BusSearchListCubit, BusSearchListState>(
                  builder: (context, state) {
                    if (state is SelectBusSuccessState) {
                      listboarding = state.response.detail?.boardingPoint;
                      return GestureDetector(
                        onTapDown: (details) async {
                          int index = await showTitleMenu(
                              context, details.globalPosition);
                          selectedLocation = listboarding![index];
                          locationController.text = selectedLocation!;
                        },
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          enabled: false,
                          cursorColor: MyTheme.primaryColor,
                          controller: locationController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Select Boarding Point",
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      );
                    }

                    return TextField(
                      style: valueTextStyle,
                      enabled: false,
                      cursorColor: MyTheme.primaryColor,
                      controller: locationController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Boarding Point",
                        hintStyle: TextStyle(fontSize: 12),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    );
                  },
                ),
                divider(),
                const SizedBox(height: 20),
                const Text('---------- Enter Passenger Details ---------',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 40),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedSeats?.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Image.asset(
                          "assets/images/seat_selected_2.png",
                          color: Colors.purple,
                          scale: 2.5,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Full Name",
                                style: headerTextStyle,
                              ),
                              TextFormField(
                                controller: passengerFullNameController[index],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    _keyFullName?.currentState?.forward();

                                    return "Enter Full Name";
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 12),
                                cursorColor: MyTheme.primaryColor,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Full Name",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  errorStyle: TextStyle(fontSize: 12),
                                ),
                              ),
                              divider()
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Age",
                                style: headerTextStyle,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: passengerAgeController[index],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    _keyAge?.currentState?.forward();
                                    return ' Enter Age';
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 12),
                                cursorColor: MyTheme.primaryColor,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Age",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  errorStyle: TextStyle(fontSize: 12),
                                ),
                              ),
                              divider()
                            ],
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: MyTheme.primaryColor),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              var index = -1;
              var obj = selectedSeats?.map((e) {
                index = index + 1;
                return {
                  'seat': e,
                  'name_of_passenger': passengerFullNameController[index].text,
                  'age': passengerAgeController[index].text
                };
              }).toList();

              BlocProvider.of<BusSearchListCubit>(context).passengerDetails(
                mobileNumber: phoneNumberController.text,
                email: emailController.text,
                name: contactNameController.text,
                boardingDate: bus.dateEn,
                seats: obj!,
                boardingPoint: locationController.text,
              );

              showModalBottomSheet(
                context: context,
                isDismissible: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black12.withOpacity(0.75),
                builder: (context) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
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
                              onTap: () {
                                KhaltiScope.of(context).pay(
                                  config: PaymentConfig(
                                    amount:
                                        (parameters.totalprice! * 100).toInt(),
                                    productIdentity:
                                        'bus_${randomAlphaNumeric(100)}',
                                    productName:
                                        'Go  Buddy Goo Payment for bus',
                                  ),
                                  preferences: [
                                    PaymentPreference.khalti,
                                  ],
                                  onSuccess: (result) {
                                    cubit.pay(
                                        'khalti',
                                        parameters.sessionID.toString(),
                                        nextPaymentMethod);
                                  },
                                  onFailure: (value) {
                                    showToast(text: value.toString());
                                  },
                                );
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
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                try {
                                  EsewaFlutterSdk.initPayment(
                                    esewaConfig: EsewaConfig(
                                      environment: Environment.live,
                                      clientId: eSewaClientId,
                                      secretId: eSewaClientSecret,
                                    ),
                                    esewaPayment: EsewaPayment(
                                      productId:
                                          "rental_${randomAlphaNumeric(10)}",
                                      productName:
                                          "Go  Buddy Goo Payment for rental",
                                      productPrice:
                                          parameters.totalprice.toString(),
                                      callbackUrl: callBackUrl,
                                    ),
                                    onPaymentSuccess:
                                        (EsewaPaymentSuccessResult data) {
                                      cubit.pay("esewa", data.refId,
                                          nextPaymentMethod);
                                    },
                                    onPaymentFailure: (data) {
                                      showToast(text: "$data");
                                    },
                                    onPaymentCancellation: (data) {
                                      showToast(text: "$data");
                                    },
                                  );
                                } on Exception catch (e) {
                                  debugPrint("EXCEPTION : ${e.toString()}");
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
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
          child: Text(
            'Proceed'.toUpperCase(),
          ),
        ),
      ),
    );
  }
}
