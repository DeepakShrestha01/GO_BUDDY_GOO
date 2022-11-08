import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/tour.dart';
import '../../../model/tour_theme.dart';
import '../../../model/value_notifier.dart';



part 'tour_search_result_state.dart';

class TourSearchResultCubit extends Cubit<TourSearchResultState> {
  TourSearchResultCubit() : super(TourSearchResultInitial());

  List<TourPackage> tourList = [];

  bool allDataLoaded = false;

  PackageThemeList? packageThemes;

  final int limit = 10;
  int page = 0;
  String? searchQuery;
  final double startPrice = 100.0;
  final double endPrice = 200000.0;
  double selectedStartPrice = 100.0;
  double selectedEndPrice = 200000.0;
  final List<String> packageCostingType = ["Any", "Per Person", "Per Group"];
  int packageCostingTypeIndex = 0;

  List<String> activities = [];

  List<String> selectedActivities = [];

  int? startingCityId;

  int? themeId;

  getActivityList() async {
    Response response = await DioHttpService()
        .handleGetRequest("travel_tour/api/package/activities/");
    activities.clear();
    if (response.statusCode == 200) {
      for (var x in response.data["activities_list"]) {
        activities.add(x);
      }
    } else {
      emit(TourSearchError());
      return;
    }
  }

  getSearchResult(
      {required bool isInitial,
      String? query,
      int? packageThemeId,
      int? startingCity}) async {
    if (isInitial) {
      searchQuery = query.toString();
      themeId = packageThemeId;
      startingCityId = startingCity;
      page = 0;
      tourList.clear();
      emit(TourSearchLoading());
      await getActivityList();
    } else {
      emit(TourSearchMoreLoading());
    }

    packageThemes ??= locator<PackageThemeList>();

    page++;

    String packageCostingString = "all";
    if (packageCostingTypeIndex == 1) {
      packageCostingString = "per_person";
    } else if (packageCostingTypeIndex == 2) {
      packageCostingString = "per_group";
    }

    FormData formData = FormData.fromMap({
      "package_theme_id": themeId,
      "package_tags": searchQuery,
      "start_price": selectedStartPrice,
      "end_price": selectedEndPrice,
      "package_costing_type": packageCostingString,
      "page": page,
      "page_limit": limit,
      "start_city_id": startingCityId,
    });

    if (selectedActivities.isNotEmpty) {
      for (var x in selectedActivities) {
        formData.fields.add(MapEntry("activity_name_list", x));
      }
    }

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/package/travelPackageByTag/",
      data: formData,
    );

    if (response.statusCode == 200) {
      tourSearchResultNumber.value = response.data["package_count"];

      if (response.data["package_count"] <= page * limit) {
        allDataLoaded = true;
      }

      for (var x in response.data["package_list"]) {
        tourList.add(TourPackage.fromJson(x));
      }

      emit(TourSearchLoaded());
    } else {
      emit(TourSearchError());
    }
  }

  getHomeTourList() async {
    emit(TourSearchLoading());

    FormData formData = FormData.fromMap({
      "start_price": 0,
      "end_price": 2000000000,
      "package_costing_type": "all",
      "page": 1,
      "page_limit": 10,
    });

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/package/travelPackageByTag/",
      data: formData,
    );

    if (response.statusCode == 200) {
      tourSearchResultNumber.value = response.data["package_count"];

      for (var x in response.data["package_list"]) {
        tourList.add(TourPackage.fromJson(x));
      }

      emit(TourSearchLoaded());
    } else {
      emit(TourSearchError());
    }
  }

  applyFilters() async {
    await getSearchResult(
      isInitial: true,
      query: searchQuery,
      packageThemeId: themeId,
      startingCity: startingCityId,
    );
  }

  applyReset() {
    selectedActivities.clear();
    selectedStartPrice = startPrice;
    selectedEndPrice = endPrice;
    packageCostingTypeIndex = 0;
  }
}
