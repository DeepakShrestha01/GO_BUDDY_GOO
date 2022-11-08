import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../model/rental.dart';
import '../../services/cubit/rental_booking_detail/booking_detail_cubit.dart';
import '../widgets/rentalBookingDetail.dart';

class RentalGuestDetailPage extends StatelessWidget {
  const RentalGuestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RentalBookingDetailCubit(),
      child: RentalGuestDetailBody(vehicle: Get.arguments),
    );
  }
}

class RentalGuestDetailBody extends StatefulWidget {
  final Rental? vehicle;
  const RentalGuestDetailBody({
    Key? key,
    this.vehicle,
  }) : super(key: key);

  @override
  _RentalGuestDetailBodyState createState() => _RentalGuestDetailBodyState();
}

class _RentalGuestDetailBodyState extends State<RentalGuestDetailBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RentalBookingDetailCubit>(context)
        .loadBookingDetails(widget.vehicle!);
  }

  @override
  Widget build(BuildContext context) {
    final RentalBookingDetailCubit rentalBookingDetailCubit =
        BlocProvider.of<RentalBookingDetailCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Booking Details",
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
      body: BlocBuilder<RentalBookingDetailCubit, RentalBookingDetailState>(
        builder: (context, state) {
          if (state is BookingDetailLoaded || state is BookingDetailBooking) {
            return AbsorbPointer(
              absorbing: state is BookingDetailLoading,
              child: RentalBookingDetail(cubit: rentalBookingDetailCubit),
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
