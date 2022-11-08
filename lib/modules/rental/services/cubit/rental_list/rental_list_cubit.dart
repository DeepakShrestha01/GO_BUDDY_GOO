import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/user_location.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/rental.dart';

part 'rental_list_state.dart';

class RentalListCubit extends Cubit<RentalListState> {
  RentalListCubit() : super(RentalListInitial());

  List<Rental> rentalList = [];
  getRentalList() async {
    emit(RentalListLoading());

    FormData formData = FormData.fromMap({
      "page": 1,
      "page_limit": 10,
      "vehicle_type": "rental",
    });

    UserLocation userLocation = locator<UserLocation>();

    if (userLocation != null) {
      formData.fields.addAll([
        MapEntry("near_me_status", true.toString()),
        MapEntry("longitude", userLocation.longitude.toString()),
        MapEntry("latitude", userLocation.latitude.toString()),
        MapEntry("radius", 10.toString()),
      ]);
    } else {
      formData.fields.add(const MapEntry("price_sorting_type", "any"));
    }

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/vehicle_inventory/get/vehicle_list/",
      data: formData,
    );

    if (response.statusCode == 200) {
      var data = response.data["rental_vehicle_list"];
      for (var x in data) {
        rentalList.add(Rental.fromJson(x));
      }
      emit(RentalListLoaded());
    } else {
      emit(RentalListError());
    }
  }
}
