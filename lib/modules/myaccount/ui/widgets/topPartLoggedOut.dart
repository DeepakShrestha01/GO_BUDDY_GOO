import 'package:flutter/material.dart';

import '../../../../configs/theme.dart';

class TopPartLoggedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 175,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFFFE5B0),
                    // Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // image: DecorationImage(
                //   image: AssetImage("assets/images/bg_profile.jpg"),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          ),
          Positioned(
            top: 85,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 100,
                width: 250,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: MyTheme.primaryColor,
                      size: 75,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
