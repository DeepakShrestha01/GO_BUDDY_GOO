import 'package:flutter/material.dart';
import 'package:go_buddy_goo/configs/theme.dart';

class InternetCheckScreen extends StatelessWidget {
  const InternetCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/nointernet.png',
                height: MediaQuery.of(context).size.height * 0.40,
              ),
              const Text(
                'No Internet Connection',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.primaryColor),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.primaryColor),
                child: const Text(
                  'Retry',
                  style: TextStyle(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
