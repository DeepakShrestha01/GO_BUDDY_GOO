import 'package:bloc/bloc.dart';
// import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/model/user.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../myaccount/services/hive/hive_user.dart';
import '../../../model/rental.dart';
import '../../../model/rental_booking_detail_parameters.dart';

part 'booking_detail_state.dart';

class RentalBookingDetailCubit extends Cubit<RentalBookingDetailState> {
  RentalBookingDetailCubit() : super(BookingDetailInitial());

  DateTime? checkInDate, checkOutDate;
  String? companyName, vehicleName, destination, pickUp;
  int? companyId, vehicleId;
  int? destinationId;
  int? pickUpId;

  Rental? vehicle;

  void updateDates(List<DateTime> selectedDates) {
    checkInDate = selectedDates[0];
    checkOutDate = selectedDates[1];
  }

  // selectDates(BuildContext context) async {
  //   DateTime currentDateTime = DateTime.now();
  //   List<DateTime> selectedDates = await DateRangePicker.showDatePicker(
  //     context: context,
  //     initialFirstDate: checkInDate ?? currentDateTime,
  //     initialLastDate:
  //         checkOutDate ?? currentDateTime.add(const Duration(days: 1)),
  //     firstDate: currentDateTime.subtract(const Duration(days: 1)),
  //     lastDate: currentDateTime.add(const Duration(days: 365 * 2)),
  //   );

  //   if (selectedDates.length == 2 &&
  //       selectedDates[0].isBefore(selectedDates[1])) {
  //     updateDates(selectedDates);
  //   }
  //   emit(BookingDetailLoaded());
  // }

  loadBookingDetails(Rental vehicle) {
    emit(BookingDetailLoading());

    this.vehicle = vehicle;

    RentalBookingDetailParameters parameters =
        locator<RentalBookingDetailParameters>();

    pickUp = parameters.city;
    pickUpId = parameters.cityId;

    DateTime currentTime = DateTime.now();
    checkInDate = DateTimeFormatter.stringToDate(
        DateTimeFormatter.formatDate(currentTime));
    checkOutDate = DateTimeFormatter.stringToDate(
        DateTimeFormatter.formatDate(currentTime.add(const Duration(days: 1))));

    vehicleName =
        "${vehicle.vehicleModel?.vehicleBrand?.name} ${vehicle.vehicleModel?.model}";

    emit(BookingDetailLoaded());
  }

  bookRentalVehicle(
      String guestName, String guestContactNumber, String email) async {
    User user = HiveUser.getUser();
    emit(BookingDetailBooking());
    if (user.token == null) {
      emit(BookingDetailLoaded());
      Get.toNamed("/accountPage");
    } else {
      FormData formData = FormData.fromMap({
        "vehicle_inventory_id": vehicle?.id,
        "name": guestName,
        "phone": guestContactNumber,
        "start_date": DateTimeFormatter.formatDateServer(checkInDate),
        "end_date": DateTimeFormatter.formatDateServer(checkOutDate),
        "pick_up_location": pickUpId,
        "destination": destinationId,
        "email": email
      });

      Response response = await DioHttpService().handlePostRequest(
        "rental/api/rental_booking/vehicle_booking/create/",
        data: formData,
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
      );

      if (response.statusCode == 200) {
        emit(BookingDetailLoaded());
        if (response.data["status"] == "Fail") {
          showToast(
              text: "Error while booking the vehicle. Try Again!!", time: 5);
        } else {
          Get.offNamedUntil(
            "/bookingSuccess",
            (route) => false,
            arguments: [
              "Thank you for using our platform. You will receive a confirmation call soon."
            ],
          );
        }
      } else {
        emit(BookingDetailLoaded());
        showToast(
            text: "Error while booking the vehicle. Try Again!!", time: 5);
      }
    }
  }
}
