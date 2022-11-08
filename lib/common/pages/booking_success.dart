import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../widgets/bookingPayment.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Booking Success",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: BookingPaymentW(
        successText: Get.arguments == null ? null : Get.arguments[0],
      ),
    );
  }
}
