import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../configs/theme.dart';
import '../../../bus/ui/widgets/bus_promotion_widget.dart';
import '../../../hotel/ui/widgets/filterCard.dart';
import '../../servies/cubit/tour_booking_detail/tour_booking_detail_cubit.dart';

class TourBookingPaymentWidget extends StatefulWidget {
  const TourBookingPaymentWidget({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final TourBookingDetailCubit cubit;

  @override
  _TourBookingPaymentWidgetState createState() =>
      _TourBookingPaymentWidgetState();
}

class _TourBookingPaymentWidgetState extends State<TourBookingPaymentWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                          "Package Pricing Detail",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("No. of guests"),
                                Text(
                                  widget.cubit.tour?.packageCostingType ==
                                          "per_group"
                                      ? widget.cubit.tour!.groupSize.toString()
                                      : widget.cubit.noOfGuest!.value
                                          .toString(),
                                  style: valueTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.cubit.tour?.packageCostingType ==
                                          "per_person"
                                      ? "Price per person"
                                      : "Price per group"),
                                  Text(
                                    widget.cubit.tour?.packageCostingType ==
                                            "per_person"
                                        ? "Rs. ${widget.cubit.tour?.costPerPerson}"
                                        : "Rs. ${widget.cubit.tour?.tourCost}",
                                    style: valueTextStyle,
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            // Row(
                            //     mainAxisSize: MainAxisSize.max,
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text("Discount"),
                            //       offer.offerAvailableStatus
                            //           ? Text(
                            //               offer.discountPricingType == "rate"
                            //                   ? "${offer.rate}%"
                            //                   : "Rs. ${offer.amount}",
                            //               style: valueTextStyle,
                            //             )
                            //           : Text(
                            //               "0.0%",
                            //               style: valueTextStyle,
                            //             ),
                            //     ]),
                          ],
                        ),
                      ),
                      divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Price",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Rs. ${widget.cubit.initialTotalPrice?.toStringAsFixed(2)}",
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
              if (widget.cubit.availablePromotions!.isNotEmpty)
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
          bottom: MediaQuery.of(context).padding.bottom,
          child: priceAndPaymentWidget(),
        ),
      ],
    );
  }

  Widget priceAndPaymentWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: WideButton(
        onTap: showPaymentOptions,
        text: "Pay Rs. ${widget.cubit.finalTotalPrice?.toStringAsFixed(2)}",
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
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        KhaltiScope.of(context).pay(
                          config: PaymentConfig(
                              amount:
                                  (widget.cubit.finalTotalPrice! * 100).toInt(),
                              productIdentity: "tour_${randomAlphaNumeric(10)}",
                              productName:
                                  "${"Go Buddy Goo Payment for ${widget.cubit.tour?.packageName}"} tour package"),
                          preferences: [
                            PaymentPreference.khalti,
                          ],
                          onSuccess: (result) {
                            widget.cubit.pay("khalti", result.token);
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

                    // GestureDetector(
                    //   behavior: HitTestBehavior.opaque,
                    //   onTap: () async {
                    //     KhaltiScope.of(context).pay(
                    //       config: PaymentConfig(
                    //           amount:
                    //               (widget.cubit.finalTotalPrice! * 100).toInt(),
                    //           productIdentity: "tour_${randomAlphaNumeric(10)}",
                    //           productName:
                    //               "${"Go Buddy Goo Payment for ${widget.cubit.tour?.packageName}"} tour package"),
                    //       preferences: [PaymentPreference.connectIPS],
                    //       onSuccess: (result) {
                    //         widget.cubit.pay("connectips", result.token);
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
                    //     //   environment:
                    //     //       // ESewaConfiguration.ENVIRONMENT_TEST
                    //     //       ESewaConfiguration.ENVIRONMENT_LIVE,
                    //     // );

                    //     // ESewaPnp eSewaPnp =
                    //     //     ESewaPnp(configuration: configuration);

                    //     // ESewaPayment payment = ESewaPayment(
                    //     //   amount: widget.cubit.finalTotalPrice,
                    //     //   productName:
                    //     //       "${"Go Buddy Goo Payment for ${widget.cubit.tour.packageName}"} tour package",
                    //     //   productID: "tour_${randomAlphaNumeric(10)}",
                    //     //   callBackURL: callBackUrl,
                    //     // );

                    //     // try {
                    //     //   final res =
                    //     //       await eSewaPnp.initPayment(payment: payment);
                    //     //   if (res.status == "COMPLETE") {
                    //     //     widget.cubit.pay("esewa", res.referenceId);
                    //     //   } else {
                    //     //     showToast(text: "Some error occured! Try Again!!");
                    //     //   }
                    //     // } on ESewaPaymentException catch (e) {
                    //     //   showToast(text: e.message);
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
        double.parse(widget.cubit.userPoints!.data!.usablePoints.toString()) !=
                0.0
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
                          widget.cubit.userPoints!.data!.usablePoints
                              .toString(),
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
                              scrollPadding: const EdgeInsets.all(150),
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
                            widget.cubit
                                .useRewardPoints(rewardPointController.text);
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
          child: widget.cubit.giftCard == null
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
                              scrollPadding: const EdgeInsets.all(150),
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
                            widget.cubit
                                .getGiftCardDetail(giftCodeController.text);
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
                        Text(widget.cubit.giftCardCode.toString()),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            widget.cubit.removeGiftCard();
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
                        Text("Rs. ${widget.cubit.giftCard?.amount}"),
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
                              scrollPadding: const EdgeInsets.all(150),
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
                            widget.cubit
                                .useGiftCard(giftCodeAmountController.text);
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
              children: List<Widget>.generate(
                  widget.cubit.availablePromotions!.length, (i) {
            return BusPromotionWidget(
              promotion: widget.cubit.availablePromotions![i],
              isSelected: widget.cubit.selectedPromotion?.promotionId ==
                  widget.cubit.availablePromotions?[i].promotionId,
              onTap: () {
                if (widget.cubit.selectedPromotion?.promotionId ==
                    widget.cubit.availablePromotions?[i].promotionId) {
                  widget.cubit.removePromotion();
                } else {
                  widget.cubit
                      .applyPromotion(widget.cubit.availablePromotions![i]);
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
