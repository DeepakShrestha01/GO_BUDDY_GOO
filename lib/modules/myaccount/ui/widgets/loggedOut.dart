import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo_mobile/modules/myaccount/ui/widgets/topPartLoggedOut.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../model/login_type.dart';
import '../../services/cubit/account/account_cubit.dart';

class LoggedOutWidget extends StatefulWidget {
  @override
  _LoggedOutWidgetState createState() => _LoggedOutWidgetState();
}

class _LoggedOutWidgetState extends State<LoggedOutWidget> {
  showCustomDialog(BuildContext context, LoginVia? loginVia) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyText2;

    final AccountCubit accountCubit = BlocProvider.of<AccountCubit>(context);

    String termsAndServiceUrl = "${backendServerUrl}termsandconditionscustomer";
    String privacyPolicyUrl = "${backendServerUrl}privacy_policy";

    showDialog(
      builder: (context) => AlertDialog(
        content: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "By proceeding, you agree with our",
                style: textStyle,
              ),
              TextSpan(
                text: " Terms of Service ",
                style: textStyle?.copyWith(color: MyTheme.primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (await canLaunch(termsAndServiceUrl)) {
                      await launch(termsAndServiceUrl);
                    }
                  },
              ),
              TextSpan(
                text: " & ",
                style: textStyle,
              ),
              TextSpan(
                text: " Privacy Policy.",
                style: textStyle?.copyWith(color: MyTheme.primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (await canLaunch(privacyPolicyUrl)) {
                      await launch(privacyPolicyUrl);
                    }
                  },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.secondaryColor,
            ),
            child: Row(
              children: const [
                Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  CupertinoIcons.clear_circled,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();

              if (loginVia == LoginVia.Email) {
                accountCubit.loginWithEmail(
                    emailController.text, passwordController.text);
              } else if (loginVia == LoginVia.Facebook) {
                accountCubit.loginWithFacebook();
              } else if (loginVia == LoginVia.Google) {
                accountCubit.loginWithGoogle();
              } else {
                showToast(text: "Some error occured!", time: 5);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.primaryColor,
            ),
            child: Row(
              children: const [
                Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
      context: context,
      barrierDismissible: false,
    );
  }

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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  GlobalKey<AnimatorWidgetState>? _keyEmail;
  GlobalKey<AnimatorWidgetState>? _keyPassword;

  @override
  void initState() {
    super.initState();
    _keyEmail = GlobalKey<AnimatorWidgetState>();
    _keyPassword = GlobalKey<AnimatorWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state is AccountLoggingIn,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopPartLoggedOut(),
                // SizedBox(height: 25),
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
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
                              TextField(
                                controller: emailController,
                                style: valueTextStyle,
                                cursorColor: MyTheme.primaryColor,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your email",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _divider(),
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
                              TextField(
                                controller: passwordController,
                                style: valueTextStyle,
                                cursorColor: MyTheme.primaryColor,
                                obscureText: true,
                                obscuringCharacter: "*",
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your password",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: ElevatedButton(
                          onPressed: () {
                            if (emailController.text.isEmpty) {
                              _keyEmail?.currentState?.forward();
                            } else if (passwordController.text.isEmpty) {
                              _keyPassword?.currentState?.forward();
                            } else {
                              showCustomDialog(context, LoginVia.Email);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.primaryColor,
                          ),
                          child: state is AccountLoggingIn
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Log In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Get.toNamed("/updatePassword");
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Get.toNamed("/activateAccount");
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Activate Account",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCustomDialog(context, LoginVia.Facebook);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/fb.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Facebook',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showCustomDialog(context, LoginVia.Google);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Google',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed("/signUp");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
