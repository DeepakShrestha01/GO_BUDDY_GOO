import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import '../widgets/hotelRoomDetail.dart';

class HotelRoomDetailPage extends StatefulWidget {
  @override
  _HotelRoomDetailPageState createState() => _HotelRoomDetailPageState();
}

class _HotelRoomDetailPageState extends State<HotelRoomDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Room Detail",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Colors.white)),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (bookingsCount.value > 0) Get.toNamed("/bookingDetail");
              },
              child: Row(
                children: [
                  const PNGIconWidget(asset: "assets/images/bed.png"),
                  ValueListenableBuilder(
                    builder: (BuildContext context, value, Widget? child) {
                      return Text(
                        "(${bookingsCount.value})",
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                    valueListenable: bookingsCount,
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                  onTap: () {
                    Get.offNamedUntil("/", (route) => false);
                  },
                  child: const Icon(CupertinoIcons.multiply_circle_fill)),
            ),
          ],
        ),
        body: RoomDetailLoadedWidget(room: Get.arguments));
  }
}
