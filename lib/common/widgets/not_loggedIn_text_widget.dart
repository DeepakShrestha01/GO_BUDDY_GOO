import 'package:flutter/material.dart';

class NotLoggedInTextWidget extends StatelessWidget {
  final Function()? onTap;
  const NotLoggedInTextWidget({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You're not logged in yet."),
          GestureDetector(
            onTap: onTap,
            child: const Text("Login to view details."),
          ),
        ],
      ),
    );
  }
}
