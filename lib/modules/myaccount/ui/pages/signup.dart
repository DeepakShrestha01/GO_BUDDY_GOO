import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/services/hide_keyboard.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/sign_up/sign_up_cubit.dart';
import '../widgets/topPartLoggedOut.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit(),
      child: const SignUpBody(),
    );
  }
}

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralCodeController = TextEditingController();

  GlobalKey<AnimatorWidgetState>? _keyEmail;
  GlobalKey<AnimatorWidgetState>? _keyPhone;
  GlobalKey<AnimatorWidgetState>? _keyPassword;
  GlobalKey<AnimatorWidgetState>? _keyConfirmPassword;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _keyEmail = GlobalKey<AnimatorWidgetState>();
    _keyPhone = GlobalKey<AnimatorWidgetState>();
    _keyPassword = GlobalKey<AnimatorWidgetState>();
    _keyConfirmPassword = GlobalKey<AnimatorWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    final SignUpCubit signUpCubit = BlocProvider.of<SignUpCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          if (state is SignUpOtpVerification) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  TopPartLoggedOut(),
                  const Text(
                    "Verify your phone number",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Text(
                      "Enter the OTP code you recieve on your phone to verify your phone number ${signUpCubit.phoneNumber},",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: PinCodeTextField(
                      length: 4,
                      onChanged: (x) {},
                      appContext: context,
                      backgroundColor: Colors.transparent,
                      cursorColor: MyTheme.primaryColor,
                      pinTheme: PinTheme(
                        activeColor: MyTheme.primaryColor,
                        inactiveColor: MyTheme.secondaryColor,
                        selectedColor: MyTheme.primaryColor,
                      ),
                      onCompleted: (x) {
                        signUpCubit.checkOtp(x);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      signUpCubit.resendOtp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: const Text(
                        "Didn't recieve code? Resend !",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return AbsorbPointer(
            absorbing: state is SignUpLoading,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TopPartLoggedOut(),
                    Shake(
                      key: _keyEmail,
                      preferences: const AnimationPreferences(
                          autoPlay: AnimationPlayStates.None),
                      child: ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: MyTheme.primaryColor,
                        ),
                        dense: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: headerTextStyle,
                            ),
                            TextFormField(
                              controller: emailController,
                              style: valueTextStyle,
                              cursorColor: MyTheme.primaryColor,
                              keyboardType: TextInputType.emailAddress,
                              validator: (String? x) {
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(x.toString())) {
                                  _keyEmail?.currentState?.forward();
                                  return "Invalid email";
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your email",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                errorStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider(),
                    Shake(
                      key: _keyPhone,
                      preferences: const AnimationPreferences(
                          autoPlay: AnimationPlayStates.None),
                      child: ListTile(
                        leading: const Icon(
                          Icons.phone,
                          color: MyTheme.primaryColor,
                        ),
                        dense: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Phone Number",
                              style: headerTextStyle,
                            ),
                            TextFormField(
                              controller: phoneController,
                              style: valueTextStyle,
                              cursorColor: MyTheme.primaryColor,
                              keyboardType: TextInputType.emailAddress,
                              validator: (String? x) {
                                if (!RegExp(r"^9[6,7,8]\d{8}$")
                                    .hasMatch(x.toString())) {
                                  _keyPhone?.currentState?.forward();
                                  return "Invalid phone number";
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter phone number",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                errorStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider(),
                    Shake(
                      key: _keyPassword,
                      preferences: const AnimationPreferences(
                          autoPlay: AnimationPlayStates.None),
                      child: ListTile(
                        leading: const PNGIconWidget(
                          asset: "assets/images/password.png",
                          color: MyTheme.primaryColor,
                        ),

                        // Icon(
                        //   Icons.lock,
                        //   color: MyTheme.primaryColor,
                        // ),
                        dense: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: headerTextStyle,
                            ),
                            TextFormField(
                              controller: passwordController,
                              style: valueTextStyle,
                              cursorColor: MyTheme.primaryColor,
                              obscureText: true,
                              obscuringCharacter: "*",
                              validator: (String? x) {
                                if (x!.length < 8) {
                                  _keyPassword?.currentState?.forward();
                                  return "Password should be of length 8.";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your password",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                errorStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider(),
                    Shake(
                      key: _keyConfirmPassword,
                      preferences: const AnimationPreferences(
                          autoPlay: AnimationPlayStates.None),
                      child: ListTile(
                        leading: const PNGIconWidget(
                          asset: "assets/images/password.png",
                          color: MyTheme.primaryColor,
                        ),
                        dense: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Confirm Password",
                              style: headerTextStyle,
                            ),
                            TextFormField(
                              controller: confirmPasswordController,
                              style: valueTextStyle,
                              cursorColor: MyTheme.primaryColor,
                              obscureText: true,
                              obscuringCharacter: "*",
                              validator: (String? x) {
                                if (x!.length < 8) {
                                  _keyConfirmPassword?.currentState?.forward();
                                  return "Passwords don't match.";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your password again",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                errorStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.qr_code,
                        color: MyTheme.primaryColor,
                      ),
                      dense: true,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Referral Code (optional)",
                            style: headerTextStyle,
                          ),
                          TextFormField(
                            controller: referralCodeController,
                            style: valueTextStyle,
                            cursorColor: MyTheme.primaryColor,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter referral code if you have any",
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              errorStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    divider(),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        hideKeyboad(context);
                        if (_formKey.currentState!.validate()) {
                          signUpCubit.register(
                            emailController.text,
                            passwordController.text,
                            phoneController.text,
                            referralCodeController.text,
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.5),
                          color: MyTheme.primaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.5),
                        child: Center(
                          child: Builder(
                            builder: (context) {
                              if (state is SignUpLoading) {
                                return const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                );
                              }

                              return Text(
                                "Register",
                                style: MyTheme.mainTextTheme.headlineMedium
                                    ?.copyWith(color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
