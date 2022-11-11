import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
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
  GlobalKey<AnimatorWidgetState>? _keyFirstName;
  GlobalKey<AnimatorWidgetState>? _keyLastName;
  GlobalKey<AnimatorWidgetState>? _keyEmail;
  GlobalKey<AnimatorWidgetState>? _keyPassword;
  GlobalKey<AnimatorWidgetState>? _keyOTP;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _EmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _otpController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _keyFirstName = GlobalKey<AnimatorWidgetState>();
    _keyLastName = GlobalKey<AnimatorWidgetState>();
    _keyEmail = GlobalKey<AnimatorWidgetState>();
    _keyPassword = GlobalKey<AnimatorWidgetState>();
    _keyOTP = GlobalKey<AnimatorWidgetState>();
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
                      onTap: () {
                        Get.back();
                      },
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
                      Text(
                        'New Here?',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 30,
                            color: const Color(0xFF111827)),
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
                          key: _keyFirstName,
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None),
                          child: CustomTextFormField(
                              controller: _firstNameController,
                              validator: (x) {
                                if (x!.isEmpty) {
                                  _keyFirstName?.currentState?.forward();
                                  return 'First Name is Required';
                                }
                                return null;
                              },
                              text: 'Enter First Name')),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      Shake(
                          key: _keyLastName,
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None),
                          child: CustomTextFormField(
                              controller: _lastNameController,
                              validator: (x) {
                                if (x!.isEmpty) {
                                  _keyLastName?.currentState?.forward();
                                  return 'Last Name is Required';
                                }
                                return null;
                              },
                              text: 'Enter Last Name')),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      Shake(
                          key: _keyEmail,
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None),
                          child: CustomTextFormField(
                              controller: _EmailController,
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
                            controller: _otpController,
                            text: 'Enter OTP ',
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      Center(
                        child: Text(
                          'OTP sent to 9860009939. Resend OTP in 0:59',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: const Color(0xFF111827)),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.024),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: GestureDetector(
                          onTap: () {
                            hideKeyboad(context);
                            if (_formkey.currentState!.validate()) {}
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
