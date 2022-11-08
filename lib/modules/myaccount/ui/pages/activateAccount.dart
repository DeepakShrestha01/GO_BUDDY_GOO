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

class ActivateAccountPage extends StatelessWidget {
  const ActivateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UpdatePasswordCubit(),
      child: const ActivateAccountBody(),
    );
  }
}

class ActivateAccountBody extends StatefulWidget {
  const ActivateAccountBody({super.key});

  @override
  _ActivateAccountBodyState createState() => _ActivateAccountBodyState();
}

class _ActivateAccountBodyState extends State<ActivateAccountBody> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _formKeyPhone = GlobalKey<FormState>();

  GlobalKey<AnimatorWidgetState>? _keyPhone, _keyOtp;

  @override
  void initState() {
    super.initState();

    _keyPhone = GlobalKey<AnimatorWidgetState>();
    _keyOtp = GlobalKey<AnimatorWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    final UpdatePasswordCubit updatePasswordCubit =
        BlocProvider.of<UpdatePasswordCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Activate Account",
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
                "Enter you phone number below to recieve an OTP code. You can use that code to activate your account.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKeyPhone,
            child: Shake(
              preferences: const AnimationPreferences(
                  autoPlay: AnimationPlayStates.None),
              key: _keyPhone,
              child: ListTile(
                dense: true,
                leading: const Icon(
                  CupertinoIcons.phone_solid,
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
                          if (_formKeyPhone.currentState!.validate()) {
                            updatePasswordCubit.reSendOtp(phoneController.text);
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
                      "Phone",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      cursorColor: MyTheme.primaryColor,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                      ),
                      validator: (String? x) {
                        if (x!.isEmpty || x.length != 10) {
                          _keyPhone?.currentState?.forward();
                          return "Invalid phone number";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: "Enter phone number",
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
                                      if (x!.isEmpty) {
                                        _keyOtp?.currentState?.forward();
                                        return "Enter OTP";
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
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                updatePasswordCubit
                                    .checkOtp(otpController.text);
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
                                        "Activate",
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
