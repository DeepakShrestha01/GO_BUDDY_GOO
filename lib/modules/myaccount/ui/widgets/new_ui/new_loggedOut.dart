import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../common/services/hide_keyboard.dart';
import '../../../services/cubit/account/account_cubit.dart';
import 'auth_privacy_tc.dart';
import 'custom_textformfield.dart';

class LoggedOutWidget extends StatefulWidget {
  const LoggedOutWidget({super.key});

  @override
  _LoggedOutWidgetState createState() => _LoggedOutWidgetState();
}

class _LoggedOutWidgetState extends State<LoggedOutWidget> {
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
  bool isOtpButton = false;

  String? otpCode;

  @override
  void initState() {
    super.initState();
    // _listen();
    otpController.text = otpCode.toString();
    _keyPhoneNumber = GlobalKey<AnimatorWidgetState>();
    _keyPassword = GlobalKey<AnimatorWidgetState>();
    _keyOTP = GlobalKey<AnimatorWidgetState>();
    // countdownController = CountdownTimerController(
    //     endTime: DateTime.now()
    //         .add(const Duration(seconds: 1))
    //         .millisecondsSinceEpoch,
    //     onEnd: () {
    //       countdownController?.disposeTimer();
    //     });
  }

  // void _listen() async {
  //   await SmsAutoFill().listenForCode();
  // }

  @override
  void dispose() {
    // SmsAutoFill().unregisterListener();
    countdownController?.dispose();
    otpController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // void submit(context) async {
  //   if (phoneController.text == "") return;

  //   var appSignatureID = await SmsAutoFill().getAppSignature;
  //   Map sendOtpData = {
  //     "mobile_number": phoneController.text,
  //     "app_signature_id": appSignatureID
  //   };
  //   print(sendOtpData);
  // }

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 15,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
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

  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();

  // GlobalKey<AnimatorWidgetState>? _keyEmail;
  // GlobalKey<AnimatorWidgetState>? _keyPassword;

  // @override
  // void initState() {
  //   super.initState();
  //   _keyEmail = GlobalKey<AnimatorWidgetState>();
  //   _keyPassword = GlobalKey<AnimatorWidgetState>();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state is AccountLoggingIn,
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
                              Get.toNamed('/accountPage');
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
                              Get.toNamed('/');
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
                            // readOnly: isOTPVerified ? true : false,
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
                                          preferences:
                                              const AnimationPreferences(
                                                  autoPlay:
                                                      AnimationPlayStates.None),
                                          child: BlocBuilder<AccountCubit,
                                              AccountState>(
                                            builder: (context, state) {
                                              if (state
                                                  is AccountLogginWithOTP) {
                                                otpCode =
                                                    state.otp.otp.toString();
                                                print('myotpcde : $otpCode');
                                                return CustomTextFormField(
                                                  text: 'Enter Otp code',
                                                  controller: otpController
                                                    ..text = otpCode.toString(),
                                                  validator: (x) {
                                                    if (x!.isEmpty) {
                                                      _keyOTP?.currentState
                                                          ?.forward();
                                                      return "Otp is required";
                                                    }
                                                    return null;
                                                  },
                                                );
                                              }
                                              return Container();
                                            },
                                          )),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.012),
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
                    child: isOtpButton == true
                        ? GestureDetector(
                            onTap: () async {
                              hideKeyboad(context);
                              var credentials = {
                                'phone': phoneController.text,
                                'otp': otpCode,
                                'is_verified': true
                              };

                              BlocProvider.of<AccountCubit>(context)
                                  .loginWithOTP(credentials: credentials);
                              // if (_formkey.currentState!.validate()) {
                              // }
                            },
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.056,
                              width: MediaQuery.of(context).size.width * 325,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: const LinearGradient(colors: [
                                    Color(0xffF6BB01),
                                    Color(0xffF59200)
                                  ])),
                              child: Center(
                                  child: Text(
                                'Proceed',
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFFFFFF)),
                              )),
                            ),
                          )
                        : isPassword == true
                            ? GestureDetector(
                                onTap: () async {
                                  hideKeyboad(context);

                                  if (_formkey.currentState!.validate()) {
                                    if (isPassword) {
                                      BlocProvider.of<AccountCubit>(context)
                                          .loginWithPassword(
                                              password: passwordController.text,
                                              phone: phoneController.text);
                                    }
                                  }
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.056,
                                  width:
                                      MediaQuery.of(context).size.width * 325,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xffF6BB01),
                                        Color(0xffF59200)
                                      ])),
                                  child: Center(
                                      child: Text(
                                    'Proceed',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFFFFFFF)),
                                  )),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  hideKeyboad(context);

                                  if (_formkey.currentState!.validate()) {
                                    BlocProvider.of<AccountCubit>(context)
                                        .checkPhoneNumber(phoneController.text);
                                    isOTPVerified = true;
                                    isOtpButton = true;
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.056,
                                  width:
                                      MediaQuery.of(context).size.width * 325,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xffF6BB01),
                                        Color(0xffF59200)
                                      ])),
                                  child: Center(
                                      child: Text(
                                    'Proceed',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFFFFFFF)),
                                  )),
                                ),
                              )),
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
          );
        },
      ),
    );
  }
}
