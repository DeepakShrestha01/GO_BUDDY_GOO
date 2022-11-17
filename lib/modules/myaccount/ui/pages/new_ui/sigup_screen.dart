import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/common/services/hide_keyboard.dart';
import 'package:go_buddy_goo_mobile/modules/myaccount/ui/widgets/new_ui/custom_textformfield.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/new_ui/auth_privacy_tc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var otp = Get.arguments;

  CountdownTimerController? countdownController;

  GlobalKey<AnimatorWidgetState>? _keyContact;
  GlobalKey<AnimatorWidgetState>? _keyEmail;
  GlobalKey<AnimatorWidgetState>? _keyPassword;
  GlobalKey<AnimatorWidgetState>? _keyOTP;
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _otpController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _keyContact = GlobalKey<AnimatorWidgetState>();
    _keyEmail = GlobalKey<AnimatorWidgetState>();
    _keyPassword = GlobalKey<AnimatorWidgetState>();
    _keyOTP = GlobalKey<AnimatorWidgetState>();

    countdownController = CountdownTimerController(
        endTime: DateTime.now()
            .add(const Duration(seconds: 1))
            .millisecondsSinceEpoch,
        onEnd: () {
          countdownController?.disposeTimer();
        });
  }

  @override
  void dispose() {
    super.dispose();
    _contactController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf3eee5),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Back",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9B97A0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.011),
                Padding(
                  padding: const EdgeInsets.only(left: 56),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/newlogo.png',
                      scale: 2,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.020),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 37),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Get.offNamedUntil('/accountPage', (route) => false),
                        child: Text(
                          'New Here?',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 30,
                              color: const Color(0xFF111827)),
                        ),
                      ),
                      Text(
                        'Let’s create an account for you',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: const Color(0xFF111827)),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.020),
                      Shake(
                          key: _keyContact,
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None),
                          child: CustomTextFormField(
                              keyboardType: TextInputType.number,
                              controller: _contactController,
                              validator: (x) {
                                if (x!.isEmpty) {
                                  _keyContact?.currentState?.forward();
                                  return 'Contact Number is Required';
                                }
                                return null;
                              },
                              text: 'Enter Contact Number')),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      Shake(
                          key: _keyEmail,
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None),
                          child: CustomTextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              validator: (x) {
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(x.toString())) {
                                  _keyEmail?.currentState?.forward();
                                  return "Email is Required";
                                }
                                return null;
                              },
                              text: 'Enter Your Email')),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      Shake(
                          key: _keyPassword,
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None),
                          child: CustomTextFormField(
                              controller: _passwordController,
                              validator: (x) {
                                if (x!.length < 8) {
                                  _keyPassword?.currentState?.forward();
                                  return "Password should be of length 8.";
                                }
                                return null;
                              },
                              text: 'Enter Password ')),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CustomTextFormField(
                          controller: _referralCodeController,
                          text: 'Enter Referral Code'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      Shake(
                          key: _keyOTP,
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None),
                          child: CustomTextFormField(
                            keyboardType: TextInputType.number,
                            controller: _otpController..text = '$otp',
                            text: "Enter Otp",
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      RichText(
                        text: TextSpan(
                            text: 'OTP sent to *****. Resend OTP in ',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF000000)),
                            children: [
                              TextSpan(children: [
                                WidgetSpan(
                                    child: CountdownTimer(
                                  controller: countdownController,
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF000000),
                                  ),
                                  widgetBuilder:
                                      (_, CurrentRemainingTime? time) {
                                    if (time == null) {
                                      return Text(
                                        '0:00',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF000000)),
                                      );
                                    }
                                    String secString =
                                        time.sec.toString().length == 1
                                            ? "0${time.sec ?? 0}"
                                            : time.sec.toString();

                                    return Text('0:$secString',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF000000)));
                                  },
                                ))
                              ])
                            ]),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.024),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: GestureDetector(
                          onTap: () {
                            hideKeyboad(context);
                            if (_formkey.currentState!.validate()) {
                              Map<String, dynamic> credentials = {
                                'contact': _contactController.text,
                                'password': _passwordController.text,
                                'email': _emailController.text,
                                'referral_code': _referralCodeController.text,
                              };
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.056,
                            width: MediaQuery.of(context).size.width * 325,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: const LinearGradient(colors: [
                                  Color(0xffF6BB01),
                                  Color(0xffF59200)
                                ])),
                            child: Center(
                                child: Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFFFFFF)),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.024),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed('/accountPage');
                          },
                          child: Text(
                            'Already have an account ?  Login',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: const Color(0xFF111827)),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.095),
                      const AuthPrivacyTC()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
