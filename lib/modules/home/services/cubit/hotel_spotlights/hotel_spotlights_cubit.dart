import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../hotel/model/hotel.dart';

part 'hotel_spotlights_state.dart';

class HotelSpotlightCubit extends Cubit<HotelSpotlightState> {
  HotelSpotlightCubit() : super(HotelSpotlightInitial());

  List<Hotel> hotelSpotLights = [];
  getHotelSpotlights() async {
    emit(HotelSpotlightLoading());
    FormData formData = FormData.fromMap({'page': 1, 'limit': 10});
    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/hotel_spotlight/",
      data: formData,
    );
    if (response.statusCode == 200) {
      var spotlightData = response.data['data']['data'];
      for (var x in spotlightData) {
        hotelSpotLights.add(Hotel.fromJson(x));
        if (hotelSpotLights.isEmpty) {
          emit(HotelSpotlightNone());
        } else {
          emit(HotelSpotlightLoaded());
        }
      }
    } else {
      emit(HotelSpotlightError());
    }
  }

  getAllHotelSpotlights() async {
    emit(HotelSpotlightLoading());

    FormData formData = FormData.fromMap({"page": 1, "limit": 100});

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/hotel_spotlight/",
      data: formData,
    );

    if (response.statusCode == 200) {
      var spotlightData = response.data["data"]["data"];

      for (var x in spotlightData) {
        hotelSpotLights.add(Hotel.fromJson(x));
      }

      if (hotelSpotLights.isEmpty) {
        emit(HotelSpotlightNone());
      } else {
        emit(HotelSpotlightLoaded());
      }
    } else {
      emit(HotelSpotlightError());
    }
  }
}
