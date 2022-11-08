import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/model/user.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../myaccount/services/hive/hive_user.dart';
import '../../../model/backend_booking_module.dart';
import '../../../model/hotel_booking_detail.dart';
import '../../../model/hotel_booking_detail_parameters.dart';

part 'booking_detail_state.dart';

class HotelBookingDetailCubit extends Cubit<HotelBookingDetailState> {
  HotelBookingDetailCubit() : super(HotelBookingDetailInitial());

  List<HotelBookingDetail> bookings = [];

  void loadBoookingsDetail() {
    emit(HotelBookingDetailLoading());
    HotelBookingDetailParameters parameters =
        locator<HotelBookingDetailParameters>();
    bookings = parameters.bookings;
    emit(HotelBookingDetailLoaded());
  }

  void checkAvailability() async {
    emit(HotelBookingDetailCheckingAvailability());

    bool userLoggedIn = HiveUser.getLoggedIn();
    User? user = HiveUser.getUser();

    if (!userLoggedIn) {
      emit(HotelBookingDetailLoaded());
      Get.toNamed("/accountPage");
    } else {
      BackendBookingModuleList moduleList = BackendBookingModuleList();
      moduleList.modules = [];

      for (HotelBookingDetail bookingDetail in bookings) {
        bookingDetail.updateTotalAmount();
        moduleList.modules?.add(
          BackendBookingModule(
            moduleName: "Hotel",
            quantity: bookingDetail.noOfRooms?.value,
            checkInDate:
                DateTimeFormatter.formatDateServer(bookingDetail.checkInDate),
            checkOutDate:
                DateTimeFormatter.formatDateServer(bookingDetail.checkOutDate),
            subTotal: bookingDetail.totalPrice.toString(),
            discount: bookingDetail.room?.offerRate.toString(),
            tax: "0.0",
            companyId: bookingDetail.hotelId,
            inventoryId: bookingDetail.room?.inventoryId,
            noOfAdult: bookingDetail.maxAdults?.value,
            noOfChild: bookingDetail.maxChildren?.value,
            priceType: bookingDetail.room!.europeanPlanSelected! ? "EP" : "BP",
            offerId: bookingDetail.room?.offerId,
            cancellationType: bookingDetail.room?.cancellationType,
            cancellationHour: bookingDetail.room?.cancellationHour,
          ),
        );
      }

      Response response = await DioHttpService().handlePostRequest(
        "booking/api_v_1/module_booking/",
        data: moduleList.moduleToJson(),
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
      );

      if (response.statusCode == 200) {
        if (response.data["data"]["module_id"].length == 0 ||
            response.data["data"]["booking_id"] == null) {
          emit(HotelBookingDetailLoaded());
          showToast(
            text: "Sorry, the rooms are not available for those days.",
            time: 5,
          );
        } else {
          List<int> moduleBookingIds = [];

          for (var x in response.data["data"]["module_id"]) {
            moduleBookingIds.add(x["id"]);
          }

          emit(HotelBookingDetailLoaded());
          Get.toNamed("/hotelBookingPayment", arguments: [
            moduleBookingIds,
            response.data["data"]["booking_id"]
          ]);
        }
      } else {
        emit(HotelBookingDetailError(response.data["data"]["message"]));
      }
    }
  }
}
