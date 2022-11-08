import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../common/widgets/appbar.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/not_loggedIn_text_widget.dart';
import '../../../../configs/theme.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../services/cubit/booking/booking_cubit.dart';
import '../widgets/cancelled_booking_list_widget.dart';
import '../widgets/completed_booking_list_widget.dart';
import '../widgets/enum_booking_selected.dart';
import '../widgets/top_menu_item.dart';
import '../widgets/upcoming_booking_list_widget.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookingCubit()..getCompletedBookings(isInitial: true),
      child: const BookingBody(),
    );
  }
}

class BookingBody extends StatefulWidget {
  const BookingBody({super.key});

  @override
  _BookingBodyState createState() => _BookingBodyState();
}

class _BookingBodyState extends State<BookingBody> {
  BookingSelected? _bookingSelected;

  @override
  void initState() {
    super.initState();
    _bookingSelected = BookingSelected.Completed;
  }

  @override
  Widget build(BuildContext context) {
    final BookingCubit bookingCubit = BlocProvider.of<BookingCubit>(context);

    return Scaffold(
      appBar: getMainAppBar(context, "Bookings", () {
        BlocProvider.of<BookingCubit>(context)
            .getCompletedBookings(isInitial: true);
      }),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(HiveUser.hbLogin).listenable(),
        builder: (context, box, child) {
          return BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
            bool? loggedin = box.get(HiveUser.hsLoggedIn);
            loggedin ??= false;
            if (!loggedin) {
              return const NotLoggedInTextWidget();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AbsorbPointer(
                          // absorbing: state is BookingLoading,
                          absorbing: false,
                          child: TopMenuItem(
                            onTap: () {
                              BlocProvider.of<BookingCubit>(context)
                                  .getCompletedBookings(isInitial: true);
                              setState(() {
                                _bookingSelected = BookingSelected.Completed;
                              });
                            },
                            mainbookingSelected: _bookingSelected,
                            bookingSelected: BookingSelected.Completed,
                            title: "Completed",
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: state is BookingInitialLoading,
                          child: TopMenuItem(
                            onTap: () {
                              BlocProvider.of<BookingCubit>(context)
                                  .getUpcomingBookings(isInitial: true);
                              setState(() {
                                _bookingSelected = BookingSelected.Upcoming;
                              });
                            },
                            mainbookingSelected: _bookingSelected,
                            bookingSelected: BookingSelected.Upcoming,
                            title: "Upcoming",
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: state is BookingInitialLoading,
                          child: TopMenuItem(
                            onTap: () {
                              BlocProvider.of<BookingCubit>(context)
                                  .getCancelledBookings(isInitial: true);
                              setState(() {
                                _bookingSelected = BookingSelected.Cancelled;
                              });
                            },
                            mainbookingSelected: _bookingSelected,
                            bookingSelected: BookingSelected.Cancelled,
                            title: "Cancelled",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Builder(
                      builder: (context) {
                        if (state is CompletedBookingLoaded) {
                          return RefreshIndicator(
                            color: Colors.white,
                            backgroundColor: MyTheme.primaryColor,
                            onRefresh: () {
                              return bookingCubit.getCompletedBookings(
                                isInitial: true,
                              );
                            },
                            child: CompletedBookingListWidget(
                              bookings: bookingCubit.completedBookings!,
                              cubit: bookingCubit,
                            ),
                          );
                        } else if (state is UpcomingBookingLoaded) {
                          return RefreshIndicator(
                            color: Colors.white,
                            backgroundColor: MyTheme.primaryColor,
                            onRefresh: () {
                              return bookingCubit.getUpcomingBookings(
                                  isInitial: true);
                            },
                            child: UpcomingBookingListWidget(
                              bookings: bookingCubit.upcomingBookings!,
                              cubit: bookingCubit,
                              refresh: () {
                                bookingCubit.getUpcomingBookings(
                                  isInitial: true,
                                );
                              },
                            ),
                          );
                        } else if (state is CancelledBookingLoaded) {
                          return RefreshIndicator(
                            color: Colors.white,
                            backgroundColor: MyTheme.primaryColor,
                            onRefresh: () {
                              return bookingCubit.getCancelledBookings(
                                isInitial: true,
                              );
                            },
                            child: CancelledBookingListWidget(
                              bookings: bookingCubit.cancelledBookings!,
                              cubit: bookingCubit,
                            ),
                          );
                        } else if (state is BookingError) {
                          return const Center(
                              child: Text("Error loading bookings"));
                        }
                        return const LoadingWidget();
                      },
                    ),
                  )
                ],
              );
            }
          });
        },
      ),
    );
  }
}
