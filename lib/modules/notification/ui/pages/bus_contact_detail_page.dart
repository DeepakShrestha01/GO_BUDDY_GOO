import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/modules/notification/model/notification.dart'  as Notification;

import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';

class BusContactDetailPage extends StatefulWidget {
  const BusContactDetailPage({super.key});

  @override
  _BusDetailPageState createState() => _BusDetailPageState();
}

class _BusDetailPageState extends State<BusContactDetailPage> {
  Notification.Notification? notification;

  @override
  void initState() {
    super.initState();
    notification = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    var splits = notification!.notificationDescription!.split(":");
    String busNumber = splits[1].split("Driver Name").first;
    String driverName = splits[2].split("Contact Number").first;
    String contactNumber = splits.last;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bus Contact Details",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    notification!.notificationHeader.toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                      height: 200,
                      child: showNetworkImage(
                        notification!.bannerImage.toString(),
                      )),
                  const SizedBox(height: 20.0),
                  Row(children: [
                    const Icon(
                      FontAwesomeIcons.bus,
                      color: MyTheme.primaryColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(child: Text(busNumber)),
                  ]),
                  const SizedBox(height: 10.0),
                  Row(children: [
                    const Icon(
                      Icons.person,
                      color: MyTheme.primaryColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(child: Text(driverName)),
                  ]),
                  const SizedBox(height: 10.0),
                  Row(children: [
                    const Icon(
                      Icons.phone,
                      color: MyTheme.primaryColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(child: Text(contactNumber)),
                  ]),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: GestureDetector(
              onTap: () {
                launchUrl(Uri(scheme: 'tel', path: contactNumber));
                // launch("tel://$contactNumber");
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5),
                  color: MyTheme.primaryColor,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.5),
                child: Center(
                  child: Text(
                    "Call",
                    style: MyTheme.mainTextTheme.headline4
                        ?.copyWith(color: Colors.white),
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
