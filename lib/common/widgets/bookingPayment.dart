import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../configs/theme.dart';

class BookingPaymentW extends StatefulWidget {
  const BookingPaymentW({Key? key, required this.successText})
      : super(key: key);

  @override
  _BookingPaymentWState createState() => _BookingPaymentWState();
  final String? successText;
}

class _BookingPaymentWState extends State<BookingPaymentW> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250.0,
              width: 250.0,
              child: Image.asset("assets/images/success.png"),
            ),
            const SizedBox(height: 20),
            Text(
              widget.successText ??
                  "Thank you for using our platform. The invoice will be sent to your email.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Return to Home".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
