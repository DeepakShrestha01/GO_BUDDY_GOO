import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/rental.dart';
import '../../../model/rental_booking_detail_parameters.dart';
import '../../../model/rental_item.dart';
import '../../../model/rental_item_list.dart';
import '../../../model/value_notifier.dart';

part 'rental_search_result_state.dart';

class RentalSearchResultCubit extends Cubit<RentalSearchResultState> {
  RentalSearchResultCubit() : super(RentalSearchResultInitial());

  List<Rental> vehicleLists = [];

  String? searchQuery;

  bool allDataLoaded = false;

  int pageLimit = 10;
  int page = 0;

  List<RentalItem> rentalItems = [];
  int? selectedVehicleindex;
  RentalBookingDetailParameters? parameters;

  bool filterApplied = false;

  getSearchResult(bool isLoadMore) async {
    if (!isLoadMore) {
      emit(RentalSearchLoading());

      vehicleLists.clear();

      parameters = locator<RentalBookingDetailParameters>();

      searchQuery = parameters?.city;

      RentalItemList rentalItemList = locator<RentalItemList>();
      rentalItems = rentalItemList.rentalItems;
    }

    page++;
    FormData formData = FormData.fromMap({
      "page": page,
      "page_limit": pageLimit,
      "vehicle_type": "rental",
    });

    if (parameters?.cityId != null) {
      formData.fields.add(MapEntry("city_id", parameters!.cityId.toString()));
    }

    if (parameters?.rentalItemId != null) {
      formData.fields.add(
          MapEntry("vehicle_category_id", parameters!.rentalItemId.toString()));
    }

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/vehicle_inventory/get/vehicle_list/",
      data: formData,
    );

    if (response.statusCode == 200) {
      var data = response.data["rental_vehicle_list"];

      rentalSearchResultNumber.value = response.data["vehicle_count"];

      if (response.data["vehicle_count"] <= page * pageLimit) {
        allDataLoaded = true;
      }
      for (var x in data) {
        vehicleLists.add(Rental.fromJson(x));
      }

      emit(RentalSearchLoaded());
    }
  }

  applyFilters(bool isLoadMore) async {
    if (!isLoadMore) {
      filterApplied = true;
      emit(RentalSearchLoading());
      allDataLoaded = false;
      vehicleLists.clear();
      page = 0;
    }

    page++;
    FormData formData = FormData.fromMap({
      "page": page,
      "page_limit": pageLimit,
      "vehicle_type": "rental",
    });

    if (parameters?.cityId != null) {
      formData.fields.add(MapEntry("city_id", parameters!.cityId.toString()));
    }

    if (selectedVehicleindex != null || parameters?.rentalItemId != null) {
      rentalVehicleTyle.value = selectedVehicleindex != null
          ? rentalItems[selectedVehicleindex!].name.toString()
          : parameters!.rentalItem.toString();

      formData.fields.add(MapEntry(
          "vehicle_category_id",
          selectedVehicleindex != null
              ? rentalItems[selectedVehicleindex!].id.toString()
              : parameters!.rentalItemId.toString()));
    }

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/vehicle_inventory/get/vehicle_list/",
      data: formData,
    );

    if (response.statusCode == 200) {
      var data = response.data["rental_vehicle_list"];

      rentalSearchResultNumber.value = response.data["vehicle_count"];

      if (data.length < pageLimit) {
        allDataLoaded = true;
      }

      for (var x in data) {
        vehicleLists.add(Rental.fromJson(x));
      }

      emit(RentalSearchLoaded());
    }
  }
}
