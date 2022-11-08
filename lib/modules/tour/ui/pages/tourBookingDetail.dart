import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../servies/cubit/tour_booking_detail/tour_booking_detail_cubit.dart';
import '../widgets/tourBookingDetailLoadedWidget.dart';
import '../widgets/tourBookingPayment.dart';

class TourGuestDetailPage extends StatelessWidget {
  const TourGuestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TourBookingDetailCubit()
        ..loadBookingDetails(Get.arguments)
        ..getUserPromotions()
        ..getUserPoints(),
      child: const TourGuestDetailBody(),
    );
  }
}

class TourGuestDetailBody extends StatefulWidget {
  const TourGuestDetailBody({
    Key? key,
  }) : super(key: key);

  @override
  _TourGuestDetailBodyState createState() => _TourGuestDetailBodyState();
}

class _TourGuestDetailBodyState extends State<TourGuestDetailBody> {
  @override
  Widget build(BuildContext context) {
    final TourBookingDetailCubit tourBookingDetailCubit =
        BlocProvider.of<TourBookingDetailCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Booking Details",
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
      ),
      body: BlocBuilder<TourBookingDetailCubit, TourBookingDetailState>(
        builder: (context, state) {
          if (state is BookingDetailLoaded) {
            return TourBookingDetailWidget(cubit: tourBookingDetailCubit);
          } else if (state is TourPaymentInitial) {
            return TourBookingPaymentWidget(cubit: tourBookingDetailCubit);
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
