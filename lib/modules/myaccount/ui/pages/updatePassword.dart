import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_animator/widgets/animator_widget.dart';
import 'package:flutter_animator/widgets/attention_seekers/shake.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/divider.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/update_password/update_password_cubit.dart';

class UpdatePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UpdatePasswordCubit(),
      child: UpdatePasswordBody(),
    );
  }
}

class UpdatePasswordBody extends StatefulWidget {
  @override
  _UpdatePasswordBodyState createState() => _UpdatePasswordBodyState();
}

class _UpdatePasswordBodyState extends State<UpdatePasswordBody> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _formKeyEmail = GlobalKey<FormState>();

  GlobalKey<AnimatorWidgetState>? _keyEmail,
      _keyOtp,
      _keyPassword,
      _keyCPassword;

  @override
  void initState() {
    super.initState();

    _keyEmail = GlobalKey<AnimatorWidgetState>();
    _keyOtp = GlobalKey<AnimatorWidgetState>();
    _keyPassword = GlobalKey<AnimatorWidgetState>();
    _keyCPassword = GlobalKey<AnimatorWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    final UpdatePasswordCubit updatePasswordCubit =
        BlocProvider.of<UpdatePasswordCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Change Password",
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
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: MyTheme.primaryColor,
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Enter you email below to recieve a 6 digit OTP code. You can use that code to update password.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKeyEmail,
            child: Shake(
              preferences: const AnimationPreferences(
                  autoPlay: AnimationPlayStates.None),
              key: _keyEmail,
              child: ListTile(
                dense: true,
                leading: const Icon(
                  CupertinoIcons.mail_solid,
                  color: MyTheme.primaryColor,
                ),
                trailing: BlocBuilder<UpdatePasswordCubit, UpdatePasswordState>(
                  builder: (context, state) {
                    if (state is UpdatePasswordLoading) {
                      return const CupertinoActivityIndicator(
                        animating: true,
                        radius: 10,
                      );
                    } else if (state is UpdatePasswordInitial) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (_formKeyEmail.currentState!.validate()) {
                            updatePasswordCubit.sendOtp(emailController.text);
                          }
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: MyTheme.primaryColor,
                        ),
                      );
                    }
                    return const SizedBox(height: 1, width: 1);
                  },
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
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
                      validator: (String? x) {
                        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(x.toString())) {
                          _keyEmail?.currentState?.forward();
                          return "Invalid email";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: "Enter your email",
                        contentPadding: EdgeInsets.all(0),
                        errorStyle: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          divider(),
          Expanded(
            child: BlocBuilder<UpdatePasswordCubit, UpdatePasswordState>(
              builder: (context, state) {
                if (state is UpdatePasswordOtpSent ||
                    state is UpdatePasswordChangeLoading) {
                  return AbsorbPointer(
                    absorbing: state is UpdatePasswordChangeLoading,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Shake(
                            preferences: const AnimationPreferences(
                                autoPlay: AnimationPlayStates.None),
                            key: _keyOtp,
                            child: ListTile(
                              dense: true,
                              leading: const Icon(
                                CupertinoIcons.number,
                                color: MyTheme.primaryColor,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "OTP Code",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: otpController,
                                    cursorColor: MyTheme.primaryColor,
                                    keyboardType: TextInputType.number,
                                    validator: (String? x) {
                                      if (x?.length != 6) {
                                        _keyOtp?.currentState?.forward();
                                        return "OTP must be of 6 digit.";
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    ),
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      isDense: true,
                                      hintText: "Enter OTP Code",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          divider(),
                          Shake(
                            preferences: const AnimationPreferences(
                                autoPlay: AnimationPlayStates.None),
                            key: _keyPassword,
                            child: ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.lock,
                                color: MyTheme.primaryColor,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "New Password",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: passwordController,
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      errorStyle: TextStyle(fontSize: 12),
                                      hintText: "Enter new password",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          divider(),
                          Shake(
                            preferences: const AnimationPreferences(
                                autoPlay: AnimationPlayStates.None),
                            key: _keyCPassword,
                            child: ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.lock,
                                color: MyTheme.primaryColor,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Confirm Password",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: cPasswordController,
                                    cursorColor: MyTheme.primaryColor,
                                    obscureText: true,
                                    obscuringCharacter: "*",
                                    validator: (String? x) {
                                      if (x != passwordController.text) {
                                        _keyCPassword?.currentState?.forward();
                                        return "Passwords don't match.";
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      errorStyle: TextStyle(fontSize: 12),
                                      hintText: "Enter new password again",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          divider(),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                updatePasswordCubit.updatePassword(
                                    otpController.text,
                                    passwordController.text);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.5),
                                color: MyTheme.primaryColor,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.5),
                              child: Center(
                                child: state is UpdatePasswordChangeLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        "Change",
                                        style: MyTheme.mainTextTheme.headline4
                                            ?.copyWith(color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
