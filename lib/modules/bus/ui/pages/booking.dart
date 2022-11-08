import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/route_manager.dart';

import '../../../../configs/theme.dart';
import '../../services/cubit/bus_booking/bus_booking_cubit.dart';
import '../widgets/booking_confirmation.dart';
import '../widgets/bus_booking_payment.dart';

class BusBookingConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BusBookingCubit()
        ..getInitialTotalAmount()
        ..getUserPromotions()
        ..getUserPoints(),
      child: BusBookingConfirmationBody(),
    );
  }
}

class BusBookingConfirmationBody extends StatefulWidget {
  @override
  _BusBookingConfirmationBodyState createState() =>
      _BusBookingConfirmationBodyState();
}

class _BusBookingConfirmationBodyState
    extends State<BusBookingConfirmationBody> {
  late final CountdownTimerController controller;

  bool success = false;

  @override
  void initState() {
    super.initState();
    controller = CountdownTimerController(
      endTime: DateTime.now()
          .add(const Duration(minutes: 9, seconds: 59))
          .millisecondsSinceEpoch,
      onEnd: () {
        controller.disposeTimer();
      },
    );
  }

  showSureDialog(BuildContext context) {
    showDialog(
      builder: (context) => AlertDialog(
        content: Text(
          "You are about to cancel your current booking and go back. Are you sure to continue?",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.primaryColor,
            ),
            child: const Text(
              "No",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await BlocProvider.of<BusBookingCubit>(context)
                  .deleteBusBooking();
              Get.back();
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
    final BusBookingCubit cubit = BlocProvider.of<BusBookingCubit>(context);
    return WillPopScope(
      onWillPop: () {
        return showSureDialog(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Booking Confirmation",
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white),
          ),
          leading: success
              ? Container()
              : GestureDetector(
                  onTap: () async {
                    showSureDialog(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
          actions: [
            success
                ? Container()
                : Align(
                    alignment: Alignment.centerRight,
                    child: CountdownTimer(
                      controller: controller,
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
                  onTap: () async {
                    await context.read<BusBookingCubit>().deleteBusBooking();
                    Get.offNamedUntil("/", (route) => false);
                  },
                  child: const Icon(CupertinoIcons.multiply_circle_fill)),
            ),
          ],
        ),
        body: BlocConsumer<BusBookingCubit, BusBookingState>(
          listener: (context, state) {
            if (state is BusBookingSuccess) {
              controller.dispose();
              success = true;
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state is BusBookingInitial || state is BusBookingLoading) {
              return BookingConfirmationW(
                countDownController: controller,
                cubit: cubit,
              );
            } else if (state is BusBookingPaymentInitial ||
                state is BusBookingPaymentLoading) {
              return BusBookingPayment(
                cubit: cubit,
                countDownController: controller,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
