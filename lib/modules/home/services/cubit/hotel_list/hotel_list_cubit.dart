import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/user_location.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../../hotel/model/hotel.dart';

part 'hotel_list_state.dart';

class HotelListCubit extends Cubit<HotelListState> {
  HotelListCubit() : super(HotelListInitial());

  List<Hotel> hotelLists = [];
  getHotelNearMe() async {
    emit(HotelListLoading());
    UserLocation userLocation = locator<UserLocation>();
    FormData formData = FormData.fromMap({});

    formData.fields.add(MapEntry("lat", userLocation.latitude.toString()));
    formData.fields.add(MapEntry("long", userLocation.longitude.toString()));
    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/hotels_nearme/",
      data: formData,
    );
    if (response.statusCode == 200) {
      var data = response.data["data"]["data"];

      for (var x in data) {
        hotelLists.add(Hotel.fromJson(x));
      }

      emit(HotelListLoaded());
    } else {
      emit(HotelListError());
    }
  }
}
