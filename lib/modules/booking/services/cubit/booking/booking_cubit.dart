import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart' show required, immutable;

import '../../../../../common/model/user.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../myaccount/services/hive/hive_user.dart';
import '../../../model/booking.dart';
import '../../../model/bus_booking.dart';
import '../../../model/flight_booking.dart';
import '../../../model/hotel_booking.dart';
import '../../../model/rental_booking.dart';
import '../../../model/tour_booking.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial()) {
    user = HiveUser.getUser();
  }

  List<Booking>? completedBookings;
  List<Booking>? upcomingBookings;
  List<Booking>? cancelledBookings;

  int page = 0;
  int limit = 10;
  bool allDataLoaded = false;

  User? user;

  getCompletedBookings({@required isInitial}) async {
    try {
      if (isInitial) {
        completedBookings = null;
        page = 0;
        allDataLoaded = false;
        user = HiveUser.getUser();
        emit(BookingInitialLoading());
      }

      page++;

      Response response = await DioHttpService().handleGetRequest(
        "booking/api_v_1/front_end_user_booking/?page=$page&limit=$limit&status=completed",
        options: Options(headers: {"Authorization": "Token ${user?.token}"}),
      );

      if (response.statusCode == 200) {
        if (page * limit >= response.data["data"]["total_data_count"]) {
          allDataLoaded = true;
        }

        completedBookings ??= [];

        for (var x in response.data["data"]["data"]) {
          if (x["module"] == "hotel") {
            completedBookings?.add(HotelBooking.fromJson(x["data"]));
          } else if (x["module"] == "bus_service") {
            completedBookings?.add(BusBooking.fromJson(x["data"]));
          } else if (x["module"] == "travel_tour") {
            completedBookings?.add(TourBooking.fromJson(x["data"]));
          } else if (x["module"] == "rental") {
            completedBookings?.add(RentalBooking.fromJson(x["data"]));
          } else if (x["module"] == "flight") {
            completedBookings?.add(FlightBooking.fromJson(x["data"]));
          }
        }
        emit(CompletedBookingLoaded());
      } else {
        emit(BookingError());
      }
    } catch (e) {
      emit(BookingError());
    }
  }

  getUpcomingBookings({@required isInitial}) async {
    try {
      if (isInitial) {
        upcomingBookings = null;
        page = 0;
        allDataLoaded = false;
        user = HiveUser.getUser();
        emit(BookingInitialLoading());
      }

      page++;

      Response response = await DioHttpService().handleGetRequest(
        "booking/api_v_1/front_end_user_booking/?page=$page&limit=$limit&status=up-coming",
        options: Options(headers: {"Authorization": "Token ${user?.token}"}),
      );

      if (response.statusCode == 200) {
        if (page * limit >= response.data["data"]["total_data_count"]) {
          allDataLoaded = true;
        }

        upcomingBookings ??= [];

        for (var x in response.data["data"]["data"]) {
          if (x["module"] == "hotel") {
            upcomingBookings?.add(HotelBooking.fromJson(x["data"]));
          } else if (x["module"] == "bus_service") {
            upcomingBookings?.add(BusBooking.fromJson(x["data"]));
          } else if (x["module"] == "travel_tour") {
            upcomingBookings?.add(TourBooking.fromJson(x["data"]));
          } else if (x["module"] == "rental") {
            upcomingBookings?.add(RentalBooking.fromJson(x["data"]));
          } else if (x["module"] == "flight") {
            upcomingBookings?.add(FlightBooking.fromJson(x["data"]));
          }
        }
        emit(UpcomingBookingLoaded());
      } else {
        emit(BookingError());
      }
    } catch (e) {
      emit(BookingError());
    }
  }

  getCancelledBookings({@required isInitial}) async {
    try {
      if (isInitial) {
        cancelledBookings = null;
        page = 0;
        allDataLoaded = false;
        user = HiveUser.getUser();
        emit(BookingInitialLoading());
      }

      page++;

      Response response = await DioHttpService().handleGetRequest(
        "booking/api_v_1/front_end_user_booking/?page=$page&limit=$limit&status=cancelled",
        options: Options(headers: {"Authorization": "Token ${user?.token}"}),
      );

      if (response.statusCode == 200) {
        if (page * limit >= response.data["data"]["total_data_count"]) {
          allDataLoaded = true;
        }

        cancelledBookings ??= [];

        for (var x in response.data["data"]["data"]) {
          if (x["module"] == "hotel") {
            cancelledBookings?.add(HotelBooking.fromJson(x["data"]));
          } else if (x["module"] == "bus_service") {
            cancelledBookings?.add(BusBooking.fromJson(x["data"]));
          } else if (x["module"] == "travel_tour") {
            cancelledBookings?.add(TourBooking.fromJson(x["data"]));
          } else if (x["module"] == "rental") {
            cancelledBookings?.add(RentalBooking.fromJson(x["data"]));
          } else if (x["module"] == "flight") {
            cancelledBookings?.add(FlightBooking.fromJson(x["data"]));
          }
        }
        emit(CancelledBookingLoaded());
      } else {
        emit(BookingError());
      }
    } catch (e) {
      emit(BookingError());
    }
  }
}
