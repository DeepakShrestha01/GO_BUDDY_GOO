import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/common/services/hide_keyboard.dart';
import 'package:go_buddy_goo_mobile/modules/myaccount/ui/widgets/new_ui/auth_privacy_tc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/new_ui/custom_textformfield.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  CountdownTimerController? countdownController;

  GlobalKey<AnimatorWidgetState>? _keyPhoneNumber;
  GlobalKey<AnimatorWidgetState>? _keyPassword;
  GlobalKey<AnimatorWidgetState>? _keyOTP;
  final _formkey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  bool isPassword = false;
  bool isOTPVerified = false;

  @override
  void initState() {
    super.initState();
    _keyPhoneNumber = GlobalKey<AnimatorWidgetState>();
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
    countdownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf3eee5),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isOTPVerified == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text("Back",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF9B97A0))),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text("Skip",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF9B97A0))),
                        ),
                      ),
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.080),
              Image.asset('assets/images/newlogo.png'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.056),
              Text(
                'Hello!',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 32,
                    color: const Color(0xFF111827)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.011),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  'Welcome, Sign in or Register to explore hourly hotels',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.023),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Shake(
                        key: _keyPhoneNumber,
                        preferences: const AnimationPreferences(
                            autoPlay: AnimationPlayStates.None),
                        child: CustomTextFormField(
                          readOnly: isOTPVerified ? true : false,
                          keyboardType: TextInputType.number,
                          validator: (x) {
                            if (x!.isEmpty) {
                              _keyPhoneNumber!.currentState!.forward();
                              return "Phone Number is required";
                            }
                            return null;
                          },
                          text: 'Enter Your Phone Number',
                          controller: phoneController,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      isPassword == true
                          ? Shake(
                              key: _keyPassword,
                              preferences: const AnimationPreferences(
                                  autoPlay: AnimationPlayStates.None),
                              child: CustomTextFormField(
                                  controller: passwordController,
                                  validator: (x) {
                                    if (x!.isEmpty) {
                                      _keyPassword!.currentState!.forward();
                                      return "Password is required";
                                    }
                                    return null;
                                  },
                                  text: "Enter Your Password"),
                            )
                          : Container(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      isPassword == true
                          ? Container()
                          : isOTPVerified == true
                              ? Column(
                                  children: [
                                    Shake(
                                      key: _keyOTP,
                                      preferences: const AnimationPreferences(
                                          autoPlay: AnimationPlayStates.None),
                                      child: CustomTextFormField(
                                        controller: otpController,
                                        validator: (x) {
                                          if (x!.isEmpty) {
                                            _keyOTP?.currentState?.forward();
                                            return "Enter OPT code";
                                          }
                                          return null;
                                        },
                                        text: 'OTP',
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.012),
                                    RichText(
                                      text: TextSpan(
                                          text:
                                              'OTP sent to ${phoneController.text}. Resend OTP in ',
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
                                                  color:
                                                      const Color(0xFF000000),
                                                ),
                                                widgetBuilder: (_,
                                                    CurrentRemainingTime?
                                                        time) {
                                                  if (time == null) {
                                                    return Text(
                                                      '0:00',
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: const Color(
                                                              0xFF000000)),
                                                    );
                                                  }
                                                  String secString = time.sec
                                                              .toString()
                                                              .length ==
                                                          1
                                                      ? "0${time.sec ?? 0}"
                                                      : time.sec.toString();

                                                  return Text('0:$secString',
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: const Color(
                                                              0xFF000000)));
                                                },
                                              ))
                                            ])
                                          ]),
                                    ),
                                  ],
                                )
                              : Container()
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.020),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 52),
                child: GestureDetector(
                  onTap: () {
                    hideKeyboad(context);
                    if (_formkey.currentState!.validate()) {
                      isOTPVerified = true;
                      setState(() {});
                      if (otpController.text.isNotEmpty) {
                        Get.toNamed('/main');
                      }
                      if (phoneController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        Get.toNamed('/main');
                      }
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.056,
                    width: MediaQuery.of(context).size.width * 325,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                            colors: [Color(0xffF6BB01), Color(0xffF59200)])),
                    child: Center(
                        child: Text(
                      'Proceed',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFFFFF)),
                    )),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.026),
              isPassword == true
                  ? GestureDetector(
                      onTap: () {
                        isPassword = !isPassword;
                        isOTPVerified = false;
                        setState(() {});
                      },
                      child: Text(
                        'Use Otp instead?',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9B97A0)),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        isPassword = !isPassword;
                        setState(() {});
                      },
                      child: Text(
                        'Use Password instead?',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9B97A0)),
                      ),
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.190),
              const AuthPrivacyTC(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.018),
            ],
          ),
        ),
      ),
    );
  }
}
