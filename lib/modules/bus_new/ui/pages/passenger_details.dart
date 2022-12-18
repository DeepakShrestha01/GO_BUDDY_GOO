import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/services/cubit/new_bus_search_result/bus_search_list_cubit.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/ui/widgets/passenge_details_input_widget.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../model/new_busbooking_list_parameter.dart';

class PassengerDetails extends StatefulWidget {
  const PassengerDetails({super.key});

  @override
  State<PassengerDetails> createState() => _PassengerDetailsState();
}

class _PassengerDetailsState extends State<PassengerDetails> {
  Buses buses = Get.arguments;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  GlobalKey<AnimatorWidgetState>? _keyEmail;
  GlobalKey<AnimatorWidgetState>? _keyName;
  GlobalKey<AnimatorWidgetState>? _keyMobileNumber;

  @override
  void initState() {
    super.initState();
    _keyEmail = GlobalKey<AnimatorWidgetState>();
    _keyName = GlobalKey<AnimatorWidgetState>();
    _keyMobileNumber = GlobalKey<AnimatorWidgetState>();
  }

  NewBusSearchListParameters parameters = NewBusSearchListParameters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Passenger Details',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shake(
                    key: _keyName,
                    preferences: const AnimationPreferences(
                        autoPlay: AnimationPlayStates.None),
                    child: PassengerDetailInputWidget(
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          _keyName?.currentState?.forward();
                          return " Enter your name";
                        }
                        return null;
                      },
                      labelText: 'Name',
                      hintText: 'Enter your name',
                    ),
                  ),
                  Shake(
                    key: _keyMobileNumber,
                    preferences: const AnimationPreferences(
                        autoPlay: AnimationPlayStates.None),
                    child: PassengerDetailInputWidget(
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          _keyMobileNumber?.currentState?.forward();

                          return " Enter your mobile number";
                        }
                        return null;
                      },
                      labelText: 'Mobile Number',
                      hintText: 'Enter your mobile number',
                    ),
                  ),
                  Shake(
                    key: _keyEmail,
                    preferences: const AnimationPreferences(
                        autoPlay: AnimationPlayStates.None),
                    child: PassengerDetailInputWidget(
                      controller: _emailController,
                      validator: (x) {
                        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(x.toString())) {
                          _keyEmail?.currentState?.forward();

                          return "Invalid email";
                        }
                        return null;
                      },
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: MyTheme.primaryColor),
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              BlocProvider.of<BusSearchListCubit>(context).passengerDetails(
                  _mobileController.text,
                  _emailController.text,
                  _nameController.text,
                  buses.date);
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
                                    amount: parameters.totalprice! * 100,
                                    productIdentity:
                                        'bus_${randomAlphaNumeric(10)}',
                                    productName:
                                        'Go  Buddy Goo Payment for bus',
                                  ),
                                  preferences: [
                                    PaymentPreference.khalti,
                                  ],
                                  onSuccess: (value) {},
                                  onFailure: (value) {},
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
                            )
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
            "Payment",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
