import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/new_ui/custom_textformfield.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  GlobalKey<AnimatorWidgetState>? _keyPhoneNumber;

  final phoneController = TextEditingController();
  bool isPassword = false;

  bool isOTPVerified = false;

  @override
  void initState() {
    super.initState();
    _keyPhoneNumber = GlobalKey<AnimatorWidgetState>();
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
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
                child: Column(
                  children: [
                    Shake(
                      key: _keyPhoneNumber,
                      preferences: const AnimationPreferences(
                          autoPlay: AnimationPlayStates.None),
                      child: CustomTextFormField(
                        text: 'Enter Your Phone Number',
                        controller: phoneController,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012),
                    isPassword == true
                        ? const CustomTextFormField(text: "Enter Your Password")
                        : Container(),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012),
                    isPassword == true
                        ? Container()
                        : isOTPVerified == true
                            ? Column(
                                children: [
                                  const CustomTextFormField(text: 'OTP'),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.012),
                                  Text(
                                    'OTP sent to ${phoneController.text}. Resend OTP in ',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF000000)),
                                  )
                                ],
                              )
                            : Container()
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.044),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 52),
                child: GestureDetector(
                  onTap: () {
                    if (phoneController.text.isEmpty) {
                      _keyPhoneNumber?.currentState?.forward();
                    } else {
                      isOTPVerified = true;
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.056,
                    width: MediaQuery.of(context).size.width * 325,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
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
            ],
          ),
        ),
      ),
    );
  }
}
