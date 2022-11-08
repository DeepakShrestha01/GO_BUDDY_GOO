import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import '../../services/cubit/hotel_detail/hotel_detail_cubit.dart';
import '../widgets/hotelDetail.dart';

class HotelDetailOfferPage extends StatelessWidget {
  const HotelDetailOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HotelDetailCubit(),
      child: const HotelDetailOfferBody(),
    );
  }
}

class HotelDetailOfferBody extends StatefulWidget {
  const HotelDetailOfferBody({super.key});

  @override
  _HotelDetailOfferBodyState createState() => _HotelDetailOfferBodyState();
}

class _HotelDetailOfferBodyState extends State<HotelDetailOfferBody> {
  HotelBookingDetailParameters? parameters;
  @override
  void initState() {
    super.initState();
    parameters = locator<HotelBookingDetailParameters>();
    BlocProvider.of<HotelDetailCubit>(context)
        .getHotelDetailOffer(Get.arguments[0], Get.arguments[1]);
  }

  @override
  void dispose() {
    super.dispose();
    parameters?.clearBookings();
  }

  @override
  Widget build(BuildContext context) {
    final HotelDetailCubit hotelDetailCubit =
        BlocProvider.of<HotelDetailCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Hotel Detail",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
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
        ],
      ),
      body: BlocBuilder<HotelDetailCubit, HotelDetailState>(
        builder: (context, state) {
          if (state is HotelDetailLoaded) {
            return HotelDetail(hotel: hotelDetailCubit.hotel);
          } else if (state is HotelDetailError) {
            return Center(child: Text(state.errorMessage));
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
