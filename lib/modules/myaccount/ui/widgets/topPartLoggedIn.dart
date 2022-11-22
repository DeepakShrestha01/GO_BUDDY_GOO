import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';

class TopPartLoggedIn extends StatelessWidget {
  final String image;
  final String initials;

  const TopPartLoggedIn({Key? key, required this.image, required this.initials})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
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
              ),
            ),
          ),
          Positioned(
            top: 85,
            child: Align(
              alignment: Alignment.centerRight,
              child: CircularProfileAvatar(
                image.contains("http")
                    ? image.toString()
                    : backendServerUrlImage.toString() + image.toString(),

                // image.contains("https") ? image : backendServerUrlImage + image,
                cacheImage: true,
                elevation: 4,
                initialsText: Text(
                  initials.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                borderWidth: 2.5,
                borderColor: MyTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
