import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel_inventory.dart';
import '../../services/cubit/booking_detail/booking_detail_cubit.dart';
import '../widgets/bookingDetail.dart';

class HotelBookingDetailPage extends StatelessWidget {
  const HotelBookingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HotelBookingDetailCubit(),
      child: HotelBookingDetailBody(room: Get.arguments),
    );
  }
}

// ignore: must_be_immutable
class HotelBookingDetailBody extends StatefulWidget {
  HotelInventory? room;
  HotelBookingDetailBody({Key? key, this.room}) : super(key: key);
  @override
  _HotelBookingDetailBodyState createState() => _HotelBookingDetailBodyState();
}

class _HotelBookingDetailBodyState extends State<HotelBookingDetailBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HotelBookingDetailCubit>(context).loadBoookingsDetail();
  }

  checkRoomSize(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("room size fix"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final HotelBookingDetailCubit bookingDetailCubit =
        BlocProvider.of<HotelBookingDetailCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Booking Detail",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white)),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
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
      body: BlocBuilder<HotelBookingDetailCubit, HotelBookingDetailState>(
        builder: (context, state) {
          if (state is HotelBookingDetailLoaded ||
              state is HotelBookingDetailCheckingAvailability) {
            return BookingDetail(bookingDetailCubit);
          } else if (state is HotelBookingDetailError) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.error),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Go Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
