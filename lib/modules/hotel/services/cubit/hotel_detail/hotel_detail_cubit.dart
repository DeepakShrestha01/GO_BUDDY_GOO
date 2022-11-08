import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/hotel.dart';
import '../../../model/hotel_booking_detail_parameters.dart';
import '../../../model/hotel_inventory.dart';
import '../../../model/range.dart';

part 'hotel_detail_state.dart';

class HotelDetailCubit extends Cubit<HotelDetailState> {
  HotelDetailCubit() : super(HotelDetailInitial());

  Hotel? hotel;

  getHotelDetailOffer(int offerId, int hotelId) async {
    emit(HotelDetailLoading());

    HotelBookingDetailParameters parameters =
        locator<HotelBookingDetailParameters>();

    parameters.dateRange = Range(
        start: DateTimeFormatter.formatDate(DateTime.now()),
        end: DateTimeFormatter.formatDate(
            DateTime.now().add(const Duration(days: 1))));
    parameters.maxAdults = 1;
    parameters.maxChildren = 0;
    parameters.noOfRooms = 1;

    FormData hotelOfferFormData = FormData.fromMap({
      "offer_id": offerId,
      "hotel_id": hotelId,
      "number_of_adult": 1,
      "number_of_child": 0,
      "no_infant": 0,
      "check_in_date": DateTimeFormatter.formatDateServer(DateTime.now()),
      "check_out_date": DateTimeFormatter.formatDateServer(
          DateTime.now().add(const Duration(days: 1))),
      "required_room": 1,
    });
    Response hotelOfferResponse = await DioHttpService().handlePostRequest(
      "booking/api_v_1/hotel_offer/",
      data: hotelOfferFormData,
    );

    if (hotelOfferResponse.statusCode == 200) {
      hotel =
          Hotel.fromJson(hotelOfferResponse.data["data"]["data"][0]["hotel"]);
      hotel?.offerDescription =
          hotelOfferResponse.data["data"]["data"][0]["offer_description"];
      parameters.hotel = hotel;
      parameters.query = hotel?.hotelCity;

      var hotelInventories = hotelOfferResponse.data["data"]["data"];

      hotel?.hotelInventories = List<HotelInventory>.generate(
          hotelInventories.length,
          (i) => HotelInventory.fromJson(hotelInventories[i]));
      emit(HotelDetailLoaded());
    } else {
      emit(HotelDetailError("Error loading detail"));
    }
  }

  getHotelDetail(Hotel hotel) async {
    emit(HotelDetailLoading());

    this.hotel = hotel;

    HotelBookingDetailParameters parameters =
        locator<HotelBookingDetailParameters>();

    parameters.query = parameters.isSearch ? parameters.query : hotel.hotelCity;

    String checkInDate = parameters.isSearch
        ? parameters.dateRange?.start
        : DateTimeFormatter.formatDate(DateTime.now());
    String checkOutDate = parameters.isSearch
        ? parameters.dateRange?.end
        : DateTimeFormatter.formatDate(
            DateTime.now().add(const Duration(days: 1)));

    parameters.dateRange = Range(start: checkInDate, end: checkOutDate);

    parameters.maxAdults = parameters.isSearch ? parameters.maxAdults : 1;
    parameters.maxChildren = parameters.isSearch ? parameters.maxChildren : 0;
    parameters.noOfRooms = parameters.isSearch ? parameters.noOfRooms : 1;

    FormData inventoryFormData = FormData.fromMap({
      "hotel_id": hotel.hotelId,
      "location": parameters.query,
      "number_of_adult": parameters.maxAdults,
      "number_of_child": parameters.maxChildren,
      "number_of_infant": 0,
      "check_in_date": DateTimeFormatter.formatDateServer(checkInDate),
      "check_out_date": DateTimeFormatter.formatDateServer(checkOutDate),
      "required_room": parameters.noOfRooms,
    });

    Response inventoryResponse = await DioHttpService().handlePostRequest(
      "booking/api_v_1/inventory_search_by_hotel/",
      data: inventoryFormData,
    );

    if (inventoryResponse.statusCode == 200) {
      var hotelInventories = inventoryResponse.data["data"]["data"];

      hotel.hotelInventories = List<HotelInventory>.generate(
          hotelInventories.length,
          (i) => HotelInventory.fromJson(hotelInventories[i]));

      emit(HotelDetailLoaded());
    } else if (inventoryResponse.statusCode == 400) {
      emit(HotelDetailLoaded());
    } else {
      emit(HotelDetailError("Error loading detail"));
    }
  }
}
