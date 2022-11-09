import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../../../common/widgets/appbar.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/not_loggedIn_text_widget.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../services/cubit/ewallet_cubit.dart';

class EwalletPage extends StatelessWidget {
  const EwalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EwalletCubit()..loadInitialData(),
      child: const EwalletBody(),
    );
  }
}

class EwalletBody extends StatefulWidget {
  const EwalletBody({super.key});

  @override
  _EwalletBodyState createState() => _EwalletBodyState();
}

class _EwalletBodyState extends State<EwalletBody> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<EwalletCubit>(context).loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    final EwalletCubit cubit = BlocProvider.of<EwalletCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: getMainAppBar(context, "eWallet", () {
        BlocProvider.of<EwalletCubit>(context).loadInitialData();
      }),
      body: ValueListenableBuilder(
        builder: (context, box, child) =>
            BlocBuilder<EwalletCubit, EwalletState>(
          builder: (context, state) {
            bool? loggedin = box.get(HiveUser.hsLoggedIn);
            loggedin ??= false;

            if (loggedin) {
              if (state is EwalletLoaded) {
                return EwalletInfoLoaded(cubit: cubit);
              } else if (state is EwalletError) {
                return EwalletLoadingError(cubit: cubit);
              }
              return const LoadingWidget();
            } else {
              return NotLoggedInTextWidget(
                onTap: () {
                  Get.toNamed("/accountPage")?.then((_) {
                    BlocProvider.of<EwalletCubit>(context).loadInitialData();
                  });
                },
              );
            }
          },
        ),
        valueListenable: Hive.box(HiveUser.hbLogin).listenable(),
      ),
    );
  }
}

class EwalletInfoLoaded extends StatefulWidget {
  const EwalletInfoLoaded({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final EwalletCubit cubit;

  @override
  _EwalletInfoLoadedState createState() => _EwalletInfoLoadedState();
}

class _EwalletInfoLoadedState extends State<EwalletInfoLoaded> {
  final GlobalKey<AnimatorWidgetState> _keyName =
      GlobalKey<AnimatorWidgetState>();

  final GlobalKey<AnimatorWidgetState> _keyAmount =
      GlobalKey<AnimatorWidgetState>();

  final GlobalKey<AnimatorWidgetState> _keyEmail =
      GlobalKey<AnimatorWidgetState>();

  final fullNameController = TextEditingController();

  final amountController = TextEditingController();

  final emailController = TextEditingController();

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 15,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }

  Widget getSingleRow(String? title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toString()),
          Text(value.toString()),
        ],
      ),
    );
  }

  showPaymentOptions() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black12.withOpacity(0.75),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
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
                Center(
                  child: Wrap(
                    spacing: 40.0,
                    runSpacing: 40.0,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      // khalti
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          KhaltiScope.of(context).pay(
                            config: PaymentConfig(
                              amount:
                                  (double.parse(amountController.text) * 100)
                                      .toInt(),
                              productIdentity: "gift_${randomAlphaNumeric(10)}",
                              productName: "Go Buddy Goo Payment for gift card",
                              productUrl: callBackUrl,
                            ),
                            preferences: [
                              PaymentPreference.khalti,
                            ],
                            onSuccess: (result) {
                              Get.back();
                              widget.cubit.buyGiftCard(
                                amount:
                                    (double.parse(amountController.text) * 100)
                                        .toInt(),
                                email: emailController.text,
                                name: fullNameController.text,
                                provider: "khalti",
                                token: result.token,
                              );
                            },
                            onFailure: (result) {
                              showToast(
                                text: result.message,
                                time: 5,
                              );
                            },
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
                      ),

                      // connectIPS

                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          KhaltiScope.of(context).pay(
                            config: PaymentConfig(
                              amount:
                                  (double.parse(amountController.text) * 100)
                                      .toInt(),
                              productIdentity: "gift_${randomAlphaNumeric(10)}",
                              productName: "Go Buddy Goo Payment for gift card",
                              productUrl: callBackUrl,
                            ),
                            preferences: [
                              PaymentPreference.connectIPS,
                            ],
                            onSuccess: (result) {
                              Get.back();
                              widget.cubit.buyGiftCard(
                                amount:
                                    (double.parse(amountController.text) * 100)
                                        .toInt(),
                                email: emailController.text,
                                name: fullNameController.text,
                                provider: "connectIPS",
                                token: result.token,
                              );
                            },
                            onFailure: (result) {
                              showToast(
                                text: result.message,
                                time: 5,
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/connectips.png",
                              height: 50,
                            ),
                            const Text("Pay with ConnectIPS"),
                          ],
                        ),
                      ),

                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          // ESewaConfiguration configuration = ESewaConfiguration(
                          //   clientID: eSewaClientId,
                          //   secretKey: eSewaClientSecret,

                          //   // clientID:
                          //   //     "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
                          //   // secretKey:
                          //   //     "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
                          //   environment: ESewaConfiguration.ENVIRONMENT_LIVE,

                          //   // .ENVIRONMENT_TEST
                          // );

                          // ESewaPnp eSewaPnp =
                          //     ESewaPnp(configuration: configuration);

                          // ESewaPayment payment = ESewaPayment(
                          //   amount: double.parse(amountController.text),
                          //   productName: "Go Buddy Goo Payment for gift card",
                          //   productID: "gift_${randomAlphaNumeric(10)}",
                          //   callBackURL: callBackUrl,
                          // );
                          // Get.back();

                          // try {
                          //   final res =
                          //       await eSewaPnp.initPayment(payment: payment);

                          //   if (res.status == "COMPLETE") {
                          //     widget.cubit.buyGiftCard(
                          //         amount: int.parse(amountController.text),
                          //         email: emailController.text,
                          //         name: fullNameController.text,
                          //         provider: "esewa",
                          //         token: res.referenceId.toString());

                          //     // fullNameController.clear();
                          //     // emailController.clear();
                          //     // amountController.clear();
                          //     // Get.back();
                          //   } else {
                          //     showToast(
                          //         text: "Some error occured! Try Again!!");
                          //   }
                          // } on ESewaPaymentException catch (e) {
                          //   showToast(
                          //     text: "eSewa Payment Error: ${e.message}",
                          //   );
                          // }
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/esewa.png",
                              height: 50,
                            ),
                            const Text("Pay with eSewa"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  makePayment() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    showDialog(
      builder: (context) => AlertDialog(
        content: Text(
          "Make sure that you have provided correct information.We won't be responsible for any issues caused because of misinformation. Continue?",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.secondaryColor,
            ),
            child: const Text(
              "No",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              showPaymentOptions();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.primaryColor,
            ),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      context: context,
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/money.png",
                        height: 40,
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Column(
                          children: [
                            getSingleRow(
                              "Your total points",
                              widget.cubit.userPoints?.data?.totalPoints,
                            ),
                            getSingleRow(
                              "Points you can redeem",
                              widget.cubit.userPoints?.data?.usablePoints
                                  .toString(),
                            ),
                            // getSingleRow(
                            //   "Minimum Points to redeem",
                            //   widget.cubit.userPoints.data.minimumPoint,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Note: You can only redeem ${widget.cubit.userPoints?.data?.usablePercentage}% of points at a moment.",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.cubit.userPoints!.data!.pointMessage.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Text(
                  //   widget.cubit.userPoints.message,
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     // fontWeight: FontWeight.w600,
                  //   ),
                  // )
                ],
              ),
            ),
          ),

          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Buy gift card"),
                      Text(
                        "Want to gift your loved ones? Enter their details below to buy them a gift card,",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Shake(
                  key: _keyName,
                  preferences: const AnimationPreferences(
                      autoPlay: AnimationPlayStates.None),
                  child: ListTile(
                    leading: const Icon(
                      CupertinoIcons.person_fill,
                      color: MyTheme.primaryColor,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Full Name",
                          style: headerTextStyle,
                        ),
                        TextField(
                          controller: fullNameController,
                          style: valueTextStyle,
                          cursorColor: MyTheme.primaryColor,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter full name",
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
                  key: _keyEmail,
                  preferences: const AnimationPreferences(
                      autoPlay: AnimationPlayStates.None),
                  child: ListTile(
                    leading: const Icon(
                      CupertinoIcons.mail_solid,
                      color: MyTheme.primaryColor,
                    ),
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
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter email",
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
                  key: _keyAmount,
                  preferences: const AnimationPreferences(
                      autoPlay: AnimationPlayStates.None),
                  child: ListTile(
                    leading: const Icon(
                      Icons.money,
                      color: MyTheme.primaryColor,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gift Card Amount",
                          style: headerTextStyle,
                        ),
                        TextField(
                          controller: amountController,
                          style: valueTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: MyTheme.primaryColor,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter amount",
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
                    onPressed: () async {
                      if (fullNameController.text.isEmpty) {
                        _keyName.currentState?.forward();
                      } else if (emailController.text.isEmpty) {
                        _keyEmail.currentState?.forward();
                      } else if (amountController.text.isEmpty) {
                        _keyAmount.currentState?.forward();
                      } else if (double.parse(amountController.text) < 10.0 ||
                          double.parse(amountController.text) > 10000.0) {
                        showToast(
                          text: "Amount should be between Rs. 10 and Rs. 10000",
                          time: 5,
                        );

                        _keyAmount.currentState?.forward();
                      } else {
                        makePayment();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Buy",
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
          ),

          // Card(
          //     child: ExpandedTileWidget(
          //   backgroundColor: Colors.white,
          //   titleWidget: Padding(
          //     padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          //     child: Text(
          //       "Buy Gift Card",
          //       style: TextStyle(
          //         fontWeight: FontWeight.w800,
          //       ),
          //     ),
          //   ),
          //   childrenPadding: EdgeInsets.zero,
          //   initiallyExpanded: false,
          //   titlePadding: EdgeInsets.zero,
          //   expandedWidgets: [
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //       child: Text(
          //         "Want to gift your loved ones? Enter their details below to buy them a gift card,",
          //         style: TextStyle(fontSize: 12),
          //       ),
          //     ),
          //     SizedBox(height: 5),
          //     Shake(
          //       key: _keyName,
          //       preferences:
          //           AnimationPreferences(autoPlay: AnimationPlayStates.None),
          //       child: ListTile(
          //         leading: Icon(
          //           CupertinoIcons.person_fill,
          //           color: MyTheme.primaryColor,
          //         ),
          //         title: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Full Name",
          //               style: headerTextStyle,
          //             ),
          //             TextField(
          //               controller: fullNameController,
          //               style: valueTextStyle,
          //               cursorColor: MyTheme.primaryColor,
          //               decoration: InputDecoration(
          //                 border: InputBorder.none,
          //                 hintText: "Enter full name",
          //                 isDense: true,
          //                 contentPadding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     _divider(),
          //     Shake(
          //       key: _keyEmail,
          //       preferences:
          //           AnimationPreferences(autoPlay: AnimationPlayStates.None),
          //       child: ListTile(
          //         leading: Icon(
          //           CupertinoIcons.mail_solid,
          //           color: MyTheme.primaryColor,
          //         ),
          //         title: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Email",
          //               style: headerTextStyle,
          //             ),
          //             TextField(
          //               controller: emailController,
          //               style: valueTextStyle,
          //               cursorColor: MyTheme.primaryColor,
          //               decoration: InputDecoration(
          //                 border: InputBorder.none,
          //                 hintText: "Enter email",
          //                 isDense: true,
          //                 contentPadding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     _divider(),
          //     Shake(
          //       key: _keyAmount,
          //       preferences:
          //           AnimationPreferences(autoPlay: AnimationPlayStates.None),
          //       child: ListTile(
          //         leading: Icon(
          //           Icons.money,
          //           color: MyTheme.primaryColor,
          //         ),
          //         title: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Gift Card Amount",
          //               style: headerTextStyle,
          //             ),
          //             TextField(
          //               controller: amountController,
          //               style: valueTextStyle,
          //               keyboardType: TextInputType.number,
          //               cursorColor: MyTheme.primaryColor,
          //               decoration: InputDecoration(
          //                 border: InputBorder.none,
          //                 hintText: "Enter amount",
          //                 isDense: true,
          //                 contentPadding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     _divider(),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 100),
          //       child: ElevatedButton(
          //         onPressed: () async {
          //           if (fullNameController.text.isEmpty) {
          //             _keyName.currentState.forward();
          //           } else if (emailController.text.isEmpty) {
          //             _keyEmail.currentState.forward();
          //           } else if (amountController.text.isEmpty) {
          //             _keyAmount.currentState.forward();
          //           } else if (double.parse(amountController.text) < 10.0 ||
          //               double.parse(amountController.text) > 1000.0) {
          //             showToast(
          //               text: "Amount should be between Rs. 10 and Rs. 10000",
          //               time: 5,
          //             );

          //             _keyAmount.currentState.forward();
          //           } else {
          //             makePayment();
          //           }
          //         },
          //         color: MyTheme.primaryColor,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text(
          //               "Buy",
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.w700,
          //               ),
          //             ),
          //             SizedBox(width: 5),
          //             Icon(
          //               Icons.arrow_forward_ios,
          //               color: Colors.white,
          //               size: 20,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          //   leadingWidget: null,
          //   subtitleWidget: null,
          // )),
        ],
      ),
    );
  }
}

class EwalletLoadingError extends StatelessWidget {
  const EwalletLoadingError({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final EwalletCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Error loading details"),
          const SizedBox(height: 10.0),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                cubit.loadInitialData();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Reload"),
                  SizedBox(width: 5),
                  Icon(
                    Icons.refresh,
                    color: MyTheme.primaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
