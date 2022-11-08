import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/modules/booking/ui/widgets/rental_booking_widget.dart';
import 'package:go_buddy_goo_mobile/modules/booking/ui/widgets/tour_booking_widget.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../model/booking.dart';
import '../../model/bus_booking.dart';
import '../../model/flight_booking.dart';
import '../../model/hotel_booking.dart';
import '../../model/rental_booking.dart';
import '../../model/tour_booking.dart';
import '../../services/cubit/booking/booking_cubit.dart';
import 'bus_booking_widget.dart';
import 'flight_booking_widget.dart';
import 'hotel_booking_widget.dart';

class CompletedBookingListWidget extends StatelessWidget {
  const CompletedBookingListWidget({
    Key? key,
    required this.bookings,
    required this.cubit,
  }) : super(key: key);

  final List<Booking> bookings;
  final BookingCubit cubit;

  @override
  Widget build(BuildContext context) {
    return bookings.isEmpty
        ? const Center(child: Text("No booking found"))
        : NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  scrollInfo is ScrollEndNotification) {
                if (!cubit.allDataLoaded) {
                  cubit.getCompletedBookings(isInitial: false);
                }
              }
              return false;
            },
            child: ListView.builder(
                itemCount: bookings.length + 1,
                itemBuilder: (BuildContext context, int i) {
                  if (i == bookings.length) {
                    return !cubit.allDataLoaded
                        ? const SizedBox(height: 50, child: XLoadingWidget())
                        : const SizedBox();
                  }
                  if (bookings[i].module == "hotel") {
                    return HotelBookingWidget(
                      booking: bookings[i] as HotelBooking,
                      flag: 0,
                      onTap: () {},
                    );
                  } else if (bookings[i].module == "rental") {
                    return RentalBookingWidget(
                      booking: bookings[i] as RentalBooking,
                      flag: 0,
                      onTap: () {},
                    );
                  } else if (bookings[i].module == "bus") {
                    return BusBookingWidget(
                      booking: bookings[i] as BusBooking,
                      flag: 0,
                      onTap: () {},
                    );
                  } else if (bookings[i].module == "tour") {
                    return TourBookingWidget(
                      booking: bookings[i] as TourBooking,
                      flag: 0,
                      onTap: () {},
                    );
                  } else if (bookings[i].module == "flight") {
                    return FlightBookingWidget(
                      booking: bookings[i] as FlightBooking,
                      flag: 0,
                    );
                  }
                  return const Text("Error loading booking detail");
                }),
          );
  }
}
