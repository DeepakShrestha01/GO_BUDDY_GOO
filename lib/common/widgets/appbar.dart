import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/common/widgets/png_icon_widget.dart';

import '../../configs/theme.dart';

AppBar getMainAppBar(
    BuildContext context, String? title, Function()? callback) {
  return AppBar(
    iconTheme: const IconThemeData(color: MyTheme.primaryColor),
    leading: GestureDetector(
      onTap: () {
        Get.offNamedUntil("/main", (route) => false);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
        child: Image.asset(
          "assets/images/logo.PNG",
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () {
          Get.toNamed("/notification");
        },
        child: const PNGIconWidget(asset: "assets/images/notification.png"),
      ),
      const SizedBox(width: 15),
      GestureDetector(
        onTap: () {
          Get.toNamed("/accountPage")?.then((_) {
            if (callback != null) callback();
          });
        },
        child: const Icon(CupertinoIcons.profile_circled),
      ),
      const SizedBox(width: 15),
    ],
  );
}
