import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_buddy_goo/modules/hotel/ui/widgets/singleBookingDetail.dart';
import 'package:recase/recase.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/booking_detail/booking_detail_cubit.dart';

class BookingDetail extends StatefulWidget {
  final HotelBookingDetailCubit? hotelBookingDetailCubit;

  const BookingDetail(this.hotelBookingDetailCubit, {super.key});

  @override
  _BookingDetailState createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  @override
  Widget build(BuildContext context) {
    const headerTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
    );
    const valueTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 17,
    );
    return BlocBuilder<HotelBookingDetailCubit, HotelBookingDetailState>(
        builder: (context, state) {
      return AbsorbPointer(
        absorbing: state is HotelBookingDetailCheckingAvailability,
        child: Container(
          // height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: ListTile(
                        leading:

                            // Icon(
                            //   Icons.hotel,
                            //   color: MyTheme.primaryColor,
                            // ),

                            const PNGIconWidget(
                          asset: "assets/images/bed.png",
                          color: MyTheme.primaryColor,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hotel",
                              style: headerTextStyle,
                            ),
                            Text(
                              widget.hotelBookingDetailCubit!.bookings[0]
                                  .hotelName!.titleCase,
                              style: valueTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // divider(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 75),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            widget.hotelBookingDetailCubit?.bookings.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SingleBookingDetail(
                            hotelBookingDetail:
                                widget.hotelBookingDetailCubit?.bookings[index],
                            index: index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey.shade400),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      widget.hotelBookingDetailCubit?.checkAvailability();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryColor,
                    ),
                    child: state is HotelBookingDetailCheckingAvailability
                        ? const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          )
                        : Text(
                            "Check Availability".toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
