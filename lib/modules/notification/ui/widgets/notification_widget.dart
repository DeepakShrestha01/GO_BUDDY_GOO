import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/modules/notification/model/notification.dart'
    as Notification;

import '../../../../common/widgets/network_image.dart';

class NotificationWidget extends StatelessWidget {
  final Notification.Notification? notification;

  const NotificationWidget(this.notification, {super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (notification?.module == "booked_bus_contact_detail") {
          Get.toNamed("/buscontactdetail", arguments: notification);
        } else {
          Get.toNamed("/offerClaim", arguments: notification);
        }
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: showNetworkImage(notification!.bannerImage.toString()),
              ),
              const SizedBox(width: 5),
              Text(notification!.notificationHeader.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
