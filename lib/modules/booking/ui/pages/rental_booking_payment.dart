import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../configs/theme.dart';
import '../../../bus/ui/widgets/bus_promotion_widget.dart';
import '../../../hotel/ui/widgets/filterCard.dart';
import '../../services/cubit/rental_booking_payment/rental_booking_payment_cubit.dart';

class RentalBookingPaymentPage extends StatelessWidget {
  const RentalBookingPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RentalBookingPaymentCubit()
        ..getUserPoints()
        ..getUserPromotions(Get.arguments[1])
        ..setInitialPriceAndBookingId(
          Get.arguments[3],
          Get.arguments[0],
          Get.arguments[2],
        ),
      child: const RentalBookingBody(),
    );
  }
}

class RentalBookingBody extends StatefulWidget {
  const RentalBookingBody({Key? key}) : super(key: key);

  @override
  _RentalBookingBodyState createState() => _RentalBookingBodyState();
}

class _RentalBookingBodyState extends State<RentalBookingBody> {
  final giftCodeController = TextEditingController();
  final giftCodeAmountController = TextEditingController();

  final rewardPointController = TextEditingController();

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 17,
  );

  RentalBookingPaymentCubit? cubit;

  String nextPaymentMethod = "online";

  int? bookingId;
  int? vecInvId;
  String? installment;
  String? price;

  @override
  void initState() {
    super.initState();
    cubit = context.read<RentalBookingPaymentCubit>();

    bookingId = Get.arguments[0];
    vecInvId = Get.arguments[1];
    installment = Get.arguments[2];
    price = Get.arguments[3];
  }

  @override
  Widget build(BuildContext context) {
    String installmentString = "Full Installment";

    if (installment.toString().contains("first")) {
      installmentString = "First Installment";
    } else if (installment.toString().contains("second")) {
      installmentString = "Second Installment";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rental Booking Payment",
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: () {
                  Get.offNamedUntil("/", (route) => false);
                },
                child: const Icon(CupertinoIcons.multiply_circle_fill)),
          ),
        ],
      ),
      body: BlocBuilder<RentalBookingPaymentCubit, RentalBookingPaymentState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Text(
                                "Rental Pricing Detail",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    installmentString,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Rs. $price",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (installment == "first")
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Text(
                                  "Select a second installment payment method,"),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        value: "online",
                                        groupValue: nextPaymentMethod,
                                        activeColor: MyTheme.primaryColor,
                                        onChanged: (x) {
                                          nextPaymentMethod = x.toString();
                                          setState(() {});
                                        },
                                      ),
                                      const Text("Online"),
                                    ],
                                  ),
                                  const SizedBox(width: 10.0),
                                  Row(
                                    children: [
                                      Radio(
                                        value: "cash_on_hand",
                                        groupValue: nextPaymentMethod,
                                        activeColor: MyTheme.primaryColor,
                                        onChanged: (x) {
                                          nextPaymentMethod = x.toString();
                                          setState(() {});
                                        },
                                      ),
                                      const Text("Cash on Hand"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (cubit!.availablePromotions.isNotEmpty)
                      promotionWidget(),
                    const SizedBox(height: 10),
                    giftCodeWidget(),
                    const SizedBox(height: 10),
                    rewardPointWidget(),
                    const SizedBox(height: 250),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: priceAndPaymentWidget(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget priceAndPaymentWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: WideButton(
        onTap: showPaymentOptions,
        text: "Pay Rs. ${cubit?.finalTotalPrice?.toStringAsFixed(2)}",
        color: MyTheme.primaryColor,
        context: context,
        icon: null,
        textColor: Colors.white,
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
                Wrap(
                  spacing: 40.0,
                  runSpacing: 40.0,
                  alignment: WrapAlignment.center,
                  children: [
                    // khalti
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        KhaltiScope.of(context).pay(
                          config: PaymentConfig(
                            amount: (cubit!.finalTotalPrice! * 100).toInt(),
                            productIdentity: "rental_${randomAlphaNumeric(10)}",
                            productName: "Go  Buddy Goo Payment for rental",
                          ),
                          preferences: [
                            PaymentPreference.khalti,
                          ],
                          onSuccess: (result) {
                            cubit?.pay(
                                "khalti", result.token, nextPaymentMethod);
                          },
                          onFailure: (result) {
                            showToast(
                              text: "Khalti Payment Error: ${result.message}",
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

                    // connectips

                    // GestureDetector(
                    //   behavior: HitTestBehavior.opaque,
                    //   onTap: () async {
                    //     KhaltiScope.of(context).pay(
                    //       config: PaymentConfig(
                    //         amount: (cubit!.finalTotalPrice! * 100).toInt(),
                    //         productIdentity: "rental_${randomAlphaNumeric(10)}",
                    //         productName: "Go  Buddy Goo Payment for rental",
                    //       ),
                    //       preferences: [
                    //         PaymentPreference.connectIPS,
                    //       ],
                    //       onSuccess: (result) {
                    //         cubit?.pay(
                    //             "connectIPS", result.token, nextPaymentMethod);
                    //       },
                    //       onFailure: (result) {
                    //         showToast(
                    //           text:
                    //               "ConnectIPS Payment Error: ${result.message}",
                    //         );
                    //       },
                    //     );
                    //   },
                    //   child: Column(
                    //     children: [
                    //       Image.asset(
                    //         "assets/images/connectips.png",
                    //         height: 50,
                    //       ),
                    //       const Text("Pay with ConnectIPS"),
                    //     ],
                    //   ),
                    // ),
                    // GestureDetector(
                    //   behavior: HitTestBehavior.opaque,
                    //   onTap: () async {
                    //     // ESewaConfiguration configuration = ESewaConfiguration(
                    //     //   clientID: eSewaClientId,
                    //     //   secretKey: eSewaClientSecret,

                    //     //   // clientID:
                    //     //   //     "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
                    //     //   // secretKey:
                    //     //   //     "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
                    //     //   environment: ESewaConfiguration.ENVIRONMENT_LIVE,
                    //     // );

                    //     // ESewaPnp eSewaPnp =
                    //     //     ESewaPnp(configuration: configuration);

                    //     // ESewaPayment payment = ESewaPayment(
                    //     //   amount: cubit.finalTotalPrice,
                    //     //   productName: "Go  Buddy Goo Payment for rental",
                    //     //   productID: "rental_${randomAlphaNumeric(10)}",
                    //     //   callBackURL: callBackUrl,
                    //     // );

                    //     // try {
                    //     //   final res =
                    //     //       await eSewaPnp.initPayment(payment: payment);
                    //     //   if (res.status == "COMPLETE") {
                    //     //     cubit.pay(
                    //     //         "esewa", res.referenceId, nextPaymentMethod);
                    //     //   } else {
                    //     //     showToast(text: "Some error occured! Try Again!!");
                    //     //   }
                    //     // } on ESewaPaymentException catch (e) {
                    //     //   showToast(
                    //     //     text: "eSewa Payment Error: ${e.message}",
                    //     //   );
                    //     // }
                    //   },
                    //   child: Column(
                    //     children: [
                    //       Image.asset(
                    //         "assets/images/esewa.png",
                    //         height: 50,
                    //       ),
                    //       const Text("Pay with eSewa"),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget rewardPointWidget() {
    return ExpandedTileWidget(
      titleWidget: const Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          "Use Reward Points",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: false,
      titlePadding: EdgeInsets.zero,
      expandedWidgets: [
        if (cubit?.userPoints != null)
          double.parse(cubit!.userPoints!.data!.usablePoints.toString()) != 0.0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Reward Points"),
                          Text(
                            cubit!.userPoints!.data!.usablePoints.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: TextField(
                                controller: rewardPointController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Points you want to use",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              cubit
                                  ?.useRewardPoints(rewardPointController.text);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: MyTheme.primaryColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Text(
                                "Apply",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "You don't have enough reward points to reedem for cash as of now."),
                ),
      ],
      leadingWidget: null,
      subtitleWidget: null,
    );
  }

  Widget giftCodeWidget() {
    return ExpandedTileWidget(
      titleWidget: const Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          "Use Gift Card",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      expandedWidgets: [
        Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          child: cubit?.giftCard == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Enter gift code below"),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextField(
                              controller: giftCodeController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Gift Code",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            cubit?.getGiftCardDetail(giftCodeController.text);
                            giftCodeController.clear();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "Reedem",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cubit!.giftCardCode.toString()),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            cubit?.removeGiftCard();
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "Remove",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Gift Card amount"),
                        Text("Rs. ${cubit?.giftCard?.amount.toString()}"),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextField(
                              controller: giftCodeAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Amount you want to use",
                                prefixText: "Rs. ",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            cubit?.useGiftCard(giftCodeAmountController.text);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "Apply",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
      subtitleWidget: null,
      leadingWidget: null,
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: false,
      titlePadding: EdgeInsets.zero,
    );
  }

  Widget promotionWidget() {
    return ExpandedTileWidget(
      titleWidget: const Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          "Apply Promotions",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      expandedWidgets: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children:
                  List<Widget>.generate(cubit!.availablePromotions.length, (i) {
            return BusPromotionWidget(
              promotion: cubit!.availablePromotions[i],
              isSelected: cubit?.selectedPromotion.promotionId ==
                  cubit?.availablePromotions[i].promotionId,
              onTap: () {
                if (cubit?.selectedPromotion.promotionId ==
                    cubit?.availablePromotions[i].promotionId) {
                  cubit?.removePromotion();
                } else {
                  cubit?.applyPromotion(cubit!.availablePromotions[i]);
                }
                setState(() {});
              },
            );
          })),
        ),
      ],
      subtitleWidget: null,
      leadingWidget: null,
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: false,
      titlePadding: EdgeInsets.zero,
    );
  }
}
