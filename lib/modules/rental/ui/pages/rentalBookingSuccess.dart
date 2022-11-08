import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../configs/theme.dart';

class RentalBookingSuccess extends StatelessWidget {
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
        // leading: GestureDetector(
        //   onTap: () {
        //     Get.back();
        //   },
        //   child: Icon(Icons.arrow_back),
        // ),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Booking success.."),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: MyTheme.primaryColor,
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
                      // SizedBox(width: 5),
                      // Icon(
                      //   CupertinoIcons.home,
                      //   color: Colors.white,
                      //   size: 20,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
