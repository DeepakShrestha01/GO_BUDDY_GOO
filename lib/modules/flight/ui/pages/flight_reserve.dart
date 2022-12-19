import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../../../common/model/country_list.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../configs/backendUrl.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/ui/widgets/filterCard.dart';
import '../../model/flight_passanger.dart';
import '../../model/flightreserveresponse.dart';
import '../../model/selected_flights.dart';
import '../../services/cubit/flight_reserve/flight_reserve_cubit.dart';

class FlightReservePage extends StatelessWidget {
  const FlightReservePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FlightReserveCubit()
        ..reserveFlight()
        ..getUserPoints(),
      child: const FlightReserveBody(),
    );
  }
}

class FlightReserveBody extends StatefulWidget {
  const FlightReserveBody({Key? key}) : super(key: key);

  @override
  _FlightReserveBodyState createState() => _FlightReserveBodyState();
}

class _FlightReserveBodyState extends State<FlightReserveBody> {
  final selectedFlights = locator<SelectedFlights>();

  CountdownTimerController? countdownController;

  List<FlightPassenger>? passengers;

  FlightReserveCubit? cubit;

  final giftCodeController = TextEditingController();
  final giftCodeAmountController = TextEditingController();

  final rewardPointController = TextEditingController();

  @override
  void initState() {
    super.initState();

    countdownController = CountdownTimerController(
      endTime: DateTime.now()
          .add(const Duration(minutes: 9, seconds: 59))
          .millisecondsSinceEpoch,
      onEnd: () {
        countdownController?.disposeTimer();
      },
    );

    cubit = BlocProvider.of<FlightReserveCubit>(context);
    passengers = [];

    for (int i = 0;
        i <
            cubit!.parameters.adults! +
                cubit!.parameters.children! +
                cubit!.parameters.infants!;
        i++) {
      passengers?.add(FlightPassenger());
    }
  }

  @override
  void dispose() {
    countdownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<FlightReserveCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Flight Booking",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            selectedFlights.clear();
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: CountdownTimer(
              controller: countdownController,
              textStyle: const TextStyle(color: Colors.white),
              widgetBuilder: (_, CurrentRemainingTime? time) {
                if (time == null) {
                  return const Text('00:00',
                      style: TextStyle(color: Colors.white));
                }
                String minString = "0${time.min ?? 0}";

                String secString = time.sec.toString().length == 1
                    ? "0${time.sec ?? 0}"
                    : time.sec.toString();

                return Text('$minString:$secString',
                    style: const TextStyle(color: Colors.white));
              },
            ),
          ),
          const SizedBox(width: 5),
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
      body: BlocBuilder<FlightReserveCubit, FlightReserveState>(
        builder: (context, state) {
          if (state is FlightReserveSuccess) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Fill out travellers detail below, "),
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      children: List<Widget>.generate(
                        cubit.parameters.adults!,
                        (i) => TravellerDetailWidget(
                          index: i + 1,
                          passenger: passengers![i],
                          passengerId: cubit.flightBookingParams
                                      ?.flightReserveResponse?.length ==
                                  1
                              ? [
                                  cubit
                                      .flightBookingParams!
                                      .flightReserveResponse![0]
                                      .passengerIds![i]
                                ]
                              : [
                                  cubit
                                      .flightBookingParams!
                                      .flightReserveResponse![0]
                                      .passengerIds![i],
                                  cubit
                                      .flightBookingParams!
                                      .flightReserveResponse![1]
                                      .passengerIds![i]
                                ],
                          isChild: false,
                        ),
                      ),
                    ),
                    Column(
                      children: List<Widget>.generate(
                        cubit.parameters.children! + cubit.parameters.infants!,
                        (i) => TravellerDetailWidget(
                          index: i + 1,
                          passenger: passengers![cubit.parameters.adults! + i],
                          passengerId: cubit.flightBookingParams
                                      ?.flightReserveResponse?.length ==
                                  1
                              ? [
                                  cubit
                                          .flightBookingParams!
                                          .flightReserveResponse![0]
                                          .passengerIds![
                                      cubit.parameters.adults! + i]
                                ]
                              : [
                                  cubit
                                          .flightBookingParams!
                                          .flightReserveResponse![0]
                                          .passengerIds![
                                      cubit.parameters.adults! + i],
                                  cubit
                                          .flightBookingParams!
                                          .flightReserveResponse![1]
                                          .passengerIds![
                                      cubit.parameters.adults! + i]
                                ],
                          isChild: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: ElevatedButton(
                        onPressed: () async {
                          cubit.setPassengers(passengers!);
                          cubit.validateDetails();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Proceed",
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
            );
          } else if (state is FlightReservePayment ||
              state is FlightReservePaymentProcessing) {
            return AbsorbPointer(
              absorbing: state is FlightReservePaymentProcessing,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        getPricingDetailWidget(),
                        const SizedBox(height: 10),
                        giftCodeWidget(),
                        const SizedBox(height: 10),
                        rewardPointWidget(),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: priceAndPaymentWidget(),
                  ),
                ],
              ),
            );
          }

          return const Center(child: LoadingWidget());
        },
      ),
    );
  }

  Widget getPricingDetailWidget() {
    return ExpandedTileWidget(
      titleWidget: const Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          "Pricing Detail",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      expandedWidgets: [
        Column(
          children: List<Widget>.generate(
            cubit!.flightBookingParams!.flightReserveResponse!.length,
            (i) => getPriceWidget(
              cubit?.flightBookingParams?.flightReserveResponse?[i],
            ),
          ),
        ),
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
                "Rs. ${cubit?.initialTotalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
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

  Widget getPriceWidget(FlightReserveResponse? flight) {
    return Column(
      children: List.generate(
        flight!.pricingDetail!.length,
        (i) => getSinglePriceWidget(flight.pricingDetail![i]),
      ),
    );
  }

  Widget getSinglePriceWidget(PricingDetail pricingDetail) {
    double adultFare = double.parse(pricingDetail.adultFare.toString());

    if (pricingDetail.adultDiscount != "0") {
      adultFare =
          adultFare - double.parse(pricingDetail.adultDiscount.toString());
    }

    bool hasGbgDiscount = pricingDetail.gbgAdultDiscount != null;

    double adultFareWithGbgDiscount = adultFare;

    if (hasGbgDiscount) {
      if (pricingDetail.gbgDiscountType?.toLowerCase() == "percentage") {
        adultFareWithGbgDiscount = adultFareWithGbgDiscount *
            (100 - double.parse(pricingDetail.gbgAdultDiscount.toString())) /
            100;
      } else {
        adultFareWithGbgDiscount = adultFareWithGbgDiscount -
            double.parse(pricingDetail.gbgAdultDiscount.toString());
      }
    }

    double childFare = double.parse(pricingDetail.adultFare.toString());

    if (pricingDetail.childDiscount != "0") {
      childFare =
          childFare - double.parse(pricingDetail.childDiscount.toString());
    }

    double childFareWithGbgDiscount = childFare;

    if (pricingDetail.gbgDiscountType?.toLowerCase() == "percentage") {
      childFareWithGbgDiscount = childFareWithGbgDiscount *
          (100 - double.parse(pricingDetail.gbgChildDiscount.toString())) /
          100;
    } else {
      childFareWithGbgDiscount = childFareWithGbgDiscount -
          double.parse(pricingDetail.gbgChildDiscount.toString());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Route"),
              Text("${pricingDetail.sectorFrom}-${pricingDetail.sectorTo}"),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Adult Fare"),
              Text(
                "${"Rs. ${pricingDetail.adultFare}"} x ${pricingDetail.numberOfAdult}",
              ),
            ],
          ),
          const SizedBox(height: 5),

          // if (flight.pricingDetail[0].adultDiscount != "0.00")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Adult Discount (Airline)"),
              Text(
                "${"Rs. ${pricingDetail.adultDiscount}"} x ${pricingDetail.numberOfAdult}",
              ),
            ],
          ),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Adult Discount (Platform)"),
              Text(
                pricingDetail.gbgDiscountType?.toLowerCase() == "percentage"
                    ? "Rs. ${(adultFare - adultFareWithGbgDiscount).toStringAsFixed(2)} x ${pricingDetail.numberOfAdult}"
                    : "${"Rs. ${pricingDetail.gbgAdultDiscount}"} x ${pricingDetail.numberOfAdult}",
              ),
            ],
          ),
          const SizedBox(height: 5),

          if ((pricingDetail.numberOfChild) != 0)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Child Fare"),
                    Text(
                      "${"Rs. ${pricingDetail.childFare}"} x ${pricingDetail.numberOfChild}",
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Child Discount (Airline)"),
                    Text(
                      "${"Rs. ${pricingDetail.childDiscount}"} x ${pricingDetail.numberOfChild}",
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Child Discount (Platform)"),
                    Text(
                      "Rs. ${(childFare - childFareWithGbgDiscount).toStringAsFixed(2)} x ${pricingDetail.numberOfChild}",
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Surcharge"),
              Text(
                  "${"Rs. ${pricingDetail.surcharge}"} x ${pricingDetail.numberOfChild! + pricingDetail.numberOfAdult!}"),
            ],
          ),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tax"),
              Text(
                  "${"Rs. ${pricingDetail.tax}"} x ${pricingDetail.numberOfChild! + pricingDetail.numberOfAdult!}"),
            ],
          ),

          const SizedBox(height: 10),
          divider(),
          const SizedBox(height: 10),
        ],
      ),
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
                        Text("Rs. ${cubit?.giftCard?.amount}"),
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

  Widget priceAndPaymentWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: WideButton(
        onTap: showPaymentOptions,
        text: "Pay Rs. ${cubit?.finalTotalPrice.toStringAsFixed(2)}",
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
                        if (countdownController?.currentRemainingTime != null) {
                          String minString = countdownController
                                      ?.currentRemainingTime?.min ==
                                  null
                              ? "0"
                              : countdownController!.currentRemainingTime!.min
                                  .toString();

                          String secString = countdownController
                                      ?.currentRemainingTime?.sec ==
                                  null
                              ? "0"
                              : countdownController!.currentRemainingTime!.sec
                                  .toString();

                          String timeRemText =
                              "$minString minutes and $secString seconds ";

                          showToast(
                            text: "You have $timeRemText to make the payment.",
                            time: 5,
                          );

                          KhaltiScope.of(context).pay(
                            config: PaymentConfig(
                              amount: (cubit!.finalTotalPrice * 100).toInt(),
                              productIdentity:
                                  "flight_${randomAlphaNumeric(10)}",
                              productName:
                                  "Go Buddy Goo Payment for flight ${cubit?.selectedFlights.outBound?.sectorPair}",
                              productUrl: callBackUrl,
                            ),
                            preferences: [
                              PaymentPreference.khalti,
                            ],
                            onSuccess: (result) {
                              if (countdownController?.currentRemainingTime !=
                                  null) {
                                // print(result);
                                cubit?.pay("khalti", result.token);
                              } else {
                                showToast(
                                  text:
                                      "Payment time expired. Go back, check availability again and proceed further.",
                                  time: 5,
                                );
                              }
                            },
                            onFailure: (result) {
                              showToast(
                                text: "Khalti Payment Error: ${result.message}",
                              );
                            },
                          );
                        } else {
                          showToast(
                            text:
                                "Payment time expired. Go back, check availability again and proceed further.",
                            time: 5,
                          );
                        }
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

                    //  GestureDetector(
                    //   behavior: HitTestBehavior.opaque,
                    //   onTap: () async {
                    //     if (countdownController?.currentRemainingTime != null) {
                    //       String minString = countdownController
                    //                   ?.currentRemainingTime?.min ==
                    //               null
                    //           ? "0"
                    //           : countdownController!.currentRemainingTime!.min
                    //               .toString();

                    //       String secString = countdownController
                    //                   ?.currentRemainingTime?.sec ==
                    //               null
                    //           ? "0"
                    //           : countdownController!.currentRemainingTime!.sec
                    //               .toString();

                    //       String timeRemText =
                    //           "$minString minutes and $secString seconds ";

                    //       showToast(
                    //         text: "You have $timeRemText to make the payment.",
                    //         time: 5,
                    //       );

                    //       KhaltiScope.of(context).pay(
                    //         config: PaymentConfig(
                    //           amount: (cubit!.finalTotalPrice * 100).toInt(),
                    //           productIdentity:
                    //               "flight_${randomAlphaNumeric(10)}",
                    //           productName:
                    //               "Go Buddy Goo Payment for flight ${cubit?.selectedFlights.outBound?.sectorPair}",
                    //           productUrl: callBackUrl,
                    //         ),
                    //         preferences: [
                    //           PaymentPreference.connectIPS,
                    //         ],
                    //         onSuccess: (result) {
                    //           if (countdownController?.currentRemainingTime !=
                    //               null) {
                    //             // print(result);
                    //             cubit?.pay("connectIPS", result.token);
                    //           } else {
                    //             showToast(
                    //               text:
                    //                   "Payment time expired. Go back, check availability again and proceed further.",
                    //               time: 5,
                    //             );
                    //           }
                    //         },
                    //         onFailure: (result) {
                    //           showToast(
                    //             text: "ConnectIPS Payment Error: ${result.message}",
                    //           );
                    //         },
                    //       );
                    //     } else {
                    //       showToast(
                    //         text:
                    //             "Payment time expired. Go back, check availability again and proceed further.",
                    //         time: 5,
                    //       );
                    //     }
                    //   },
                    //   child: Column(
                    //     children: [
                    //       Image.asset(
                    //         "assets/images/connectips.png",
                    //         height: 50,
                    //       ),
                    //       const Text("Pay with connectIPS"),
                    //     ],
                    //   ),
                    // ),

                    // GestureDetector(
                    //   behavior: HitTestBehavior.opaque,
                    //   onTap: () async {
                    //     // if (countdownController?.currentRemainingTime != null) {
                    //     //   ESewaConfiguration configuration = ESewaConfiguration(
                    //     //     clientID: eSewaClientId,
                    //     //     secretKey: eSewaClientSecret,

                    //     //     // clientID:
                    //     //     //     "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
                    //     //     // secretKey:
                    //     //     //     "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
                    //     //     environment:
                    //     //         // ESewaConfiguration.ENVIRONMENT_TEST
                    //     //         ESewaConfiguration.ENVIRONMENT_LIVE,
                    //     //   );

                    //     //   ESewaPnp eSewaPnp =
                    //     //       ESewaPnp(configuration: configuration);

                    //     //   ESewaPayment payment = ESewaPayment(
                    //     //     amount: cubit!.finalTotalPrice,
                    //     //     productName:
                    //     //         "Go Buddy Goo Payment for flight ${cubit?.selectedFlights.outBound?.sectorPair}",
                    //     //     productID: "flight_${randomAlphaNumeric(10)}",
                    //     //     callBackURL: callBackUrl,
                    //     //   );

                    //     //   try {
                    //     //     final res =
                    //     //         await eSewaPnp.initPayment(payment: payment);

                    //     //     if (res.status == "COMPLETE") {
                    //     //       if (countdownController?.currentRemainingTime !=
                    //     //           null) {
                    //     //         // print(result);
                    //     //         cubit?.pay("esewa", res.referenceId.toString());
                    //     //       } else {
                    //     //         showToast(
                    //     //           text:
                    //     //               "Payment time expired. Go back, check availability again and proceed further.",
                    //     //           time: 5,
                    //     //         );
                    //     //       }
                    //     //     } else {
                    //     //       showToast(
                    //     //           text: "Some error occured! Try Again!!");
                    //     //     }
                    //     //   } on ESewaPaymentException catch (e) {
                    //     //     showToast(text: e.message);
                    //     //   }
                    //     // } else {
                    //     //   showToast(
                    //     //     text:
                    //     //         "Payment time expired. Go back, check availability again and proceed further.",
                    //     //     time: 5,
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
                            cubit?.useRewardPoints(rewardPointController.text);
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
}

class TravellerDetailWidget extends StatefulWidget {
  final int index;
  final FlightPassenger passenger;
  final List<String> passengerId;
  final bool isChild;
  const TravellerDetailWidget({
    Key? key,
    required this.index,
    required this.passenger,
    required this.passengerId,
    required this.isChild,
  }) : super(key: key);

  @override
  _TravellerDetailWidgetState createState() => _TravellerDetailWidgetState();
}

class _TravellerDetailWidgetState extends State<TravellerDetailWidget> {
  final List<String> genderList = ["Male", "Female", "Others"];

  final List<String> titleList = ["Mr", "Mrs", "Miss", "Dr"];

  String? gender;

  String? title;

  final genderController = TextEditingController();
  final titleController = TextEditingController();
  final countryController = TextEditingController();

  showGenderMenu(BuildContext context, Offset offset) async {
    return showMenu(
      context: context,
      items: List<PopupMenuEntry>.generate(genderList.length, (i) {
        return PopupMenuItem(
          value: i,
          child: Text(genderList[i]),
        );
      }),
      position: RelativeRect.fromLTRB(
        50,
        offset.dy,
        MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width,
      ),
    );
  }

  showTitleMenu(BuildContext context, Offset offset) async {
    return showMenu(
      context: context,
      items: List<PopupMenuEntry>.generate(titleList.length, (i) {
        return PopupMenuItem(
          value: i,
          child: Text(titleList[i]),
        );
      }),
      position: RelativeRect.fromLTRB(
        50,
        offset.dy,
        MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width,
      ),
    );
  }

  CountryList countryList = locator<CountryList>();

  @override
  void initState() {
    super.initState();
    print(widget.passengerId);
    widget.passenger.passengerId = widget.passengerId;
    widget.passenger.passengerTypeRcd = "ADULT";
    widget.passenger.titleRcd = "";
    widget.passenger.addressLine1 = "";
    widget.passenger.district = "";
    widget.passenger.province = "";

    if (widget.isChild) {
      widget.passenger.passengerTypeRcd = "CHD";
      widget.passenger.contactEmail = "";
      widget.passenger.phoneMobile = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isChild
                    ? "Detail of Child Traveller ${widget.index}"
                    : "Detail of Adult Traveller ${widget.index}",
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: headerTextStyle,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (TapDownDetails details) async {
                      int index =
                          await showTitleMenu(context, details.globalPosition);
                      title = titleList[index];
                      titleController.text = title.toString();
                      widget.passenger.titleRcd = title;
                      setState(() {});
                    },
                    child: TextField(
                      style: valueTextStyle,
                      enabled: false,
                      cursorColor: MyTheme.primaryColor,
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Title",
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
              divider(),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "First Name",
                    style: headerTextStyle,
                  ),
                  TextField(
                    style: valueTextStyle,
                    cursorColor: MyTheme.primaryColor,
                    onChanged: (x) {
                      widget.passenger.firstname = x;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter first name",
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              divider(),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Middle Name (optional)",
                    style: headerTextStyle,
                  ),
                  TextField(
                    style: valueTextStyle,
                    cursorColor: MyTheme.primaryColor,
                    onChanged: (x) {
                      widget.passenger.middlename = x;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter middle name",
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              divider(),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last Name",
                    style: headerTextStyle,
                  ),
                  TextField(
                    style: valueTextStyle,
                    cursorColor: MyTheme.primaryColor,
                    onChanged: (x) {
                      widget.passenger.lastname = x;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter last name",
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              divider(),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gender",
                    style: headerTextStyle,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (TapDownDetails details) async {
                      int selectedGenderIndex =
                          await showGenderMenu(context, details.globalPosition);
                      gender = genderList[selectedGenderIndex];
                      genderController.text = gender.toString();
                      widget.passenger.gender = gender?[0];
                      setState(() {});
                    },
                    child: TextField(
                      style: valueTextStyle,
                      enabled: false,
                      cursorColor: MyTheme.primaryColor,
                      controller: genderController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Gender",
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
              divider(),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nationality",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TypeAheadField(
                    autoFlipDirection: true,
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      controller: countryController,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                      ),
                      cursorColor: MyTheme.primaryColor,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: "Select your country",
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await countryList.getPatternCountries(pattern);
                    },
                    itemBuilder: (context, dynamic suggestion) {
                      return ListTile(
                        title: Text(suggestion.name),
                      );
                    },
                    onSuggestionSelected: (dynamic suggestion) {
                      countryController.text = suggestion.name;
                      widget.passenger.nationalityRcd = suggestion.countryCode;
                      widget.passenger.countryRcd = suggestion.countryCode;
                      setState(() {});
                    },
                    noItemsFoundBuilder: (context) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "No country found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  )
                ],
              ),
              if (!widget.isChild) divider(),
              if (!widget.isChild) const SizedBox(height: 10),
              if (!widget.isChild)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: headerTextStyle,
                    ),
                    TextField(
                      style: valueTextStyle,
                      cursorColor: MyTheme.primaryColor,
                      onChanged: (x) {
                        widget.passenger.contactEmail = x;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter contact email",
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              if (!widget.isChild) divider(),
              if (!widget.isChild) const SizedBox(height: 10),
              if (!widget.isChild)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone Number",
                      style: headerTextStyle,
                    ),
                    TextField(
                      style: valueTextStyle,
                      keyboardType: TextInputType.number,
                      cursorColor: MyTheme.primaryColor,
                      onChanged: (x) {
                        widget.passenger.phoneMobile = x;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter phone number",
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
