import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/hotel.dart';
import '../../../model/hotel_booking_detail_parameters.dart';
import '../../../model/hotel_filter.dart';
import '../../../model/keyword_search_result.dart';
import '../../../model/range.dart';
import '../../../model/value_notifier.dart';

part 'hotel_search_result_state.dart';

class HotelSearchResultCubit extends Cubit<HotelSearchResultState> {
  HotelSearchResultCubit() : super(HotelSearchResultInitial());

  List<Hotel>? hotelLists = [];
  String? searchQuery;
  Range? dateRange;
  int? maxAdults;
  int? maxChildren;
  int? noOfHotels;
  int? noOfRooms;
  String? bookingHour;
  HotelFilter? filter;
  HotelFilter? originalFilter;

  bool? sortPrice;
  bool? sortRating;

  bool sortAsc = true;

  bool allDataLoaded = false;

  int limit = 3;
  int page = 0;

  bool filteredApplied = false;

  HotelBookingDetailParameters? parameters;

  getPreviousParameters() {
    var formData = {
      "previous_parameters": {
        "number_of_adult": maxAdults,
        "number_of_child": maxChildren,
        "number_of_infant": 0,
        "check_in_date": DateTimeFormatter.formatDateServer(dateRange?.start),
        "check_out_date": DateTimeFormatter.formatDateServer(dateRange?.end),
        "required_room": noOfRooms,
        "page": page,
        "limit": limit,
      }
    };
    if (parameters?.selectedKeyword != null) {
      if (parameters?.selectedKeyword?.type == KeywordSearchType.HOTEL) {
        formData["previous_parameters"]?["hotel_id"] =
            parameters?.selectedKeyword?.id.toString();

        formData["previous_parameters"]?["lat"] = "";
        formData["previous_parameters"]?["long"] = "";
        formData["previous_parameters"]?["location"] = "";
      } else if (parameters?.selectedKeyword?.type == KeywordSearchType.CITY) {
        formData["previous_parameters"]?["location"] = searchQuery;
      }
    }

    if (parameters?.latLng != null) {
      formData["previous_parameters"]?["hotel_id"] = "";
      formData["previous_parameters"]?["location"] = "";

      formData["previous_parameters"]?["lat"] = parameters?.latLng?.latitude;
      formData["previous_parameters"]?["long"] = parameters?.latLng?.longitude;
    }

    if (parameters?.selectedKeyword == null && parameters?.latLng == null) {
      formData["previous_parameters"]?["location"] = searchQuery;
    }

    return formData;
  }

  getSearchResult() async {
    parameters = locator<HotelBookingDetailParameters>();
    searchQuery = parameters?.query;
    dateRange = parameters?.dateRange;
    maxAdults = parameters?.maxAdults;
    maxChildren = parameters?.maxChildren;
    noOfRooms = parameters?.noOfRooms;
    bookingHour = parameters?.bookingHour;

    emit(HotelSearchLoading());

    page++;

    FormData formData = FormData.fromMap({
      "number_of_adult": maxAdults,
      "number_of_child": maxChildren,
      "number_of_infant": 0,
      "check_in_date": DateTimeFormatter.formatDateServer(dateRange?.start),
      "check_out_date": DateTimeFormatter.formatDateServer(dateRange?.end),
      "required_room": noOfRooms,
      'booking_hour': bookingHour,
    });

    if (parameters?.selectedKeyword != null) {
      if (parameters?.selectedKeyword?.type == KeywordSearchType.HOTEL) {
        // formData.fields.add(MapEntry("location", null));
        formData.fields.add(
            MapEntry("hotel_id", parameters!.selectedKeyword!.id.toString()));
        // formData.fields.add(MapEntry("lat", null));
        // formData.fields.add(MapEntry("long", null));
      } else if (parameters?.selectedKeyword?.type == KeywordSearchType.CITY) {
        formData.fields.add(MapEntry("location", searchQuery.toString()));
      }
    }

    if (parameters?.latLng != null) {
      // formData.fields.add(MapEntry("location", null));
      // formData.fields.add(MapEntry("hotel_id", null));
      formData.fields
          .add(MapEntry("lat", parameters!.latLng!.latitude.toString()));
      formData.fields
          .add(MapEntry("long", parameters!.latLng!.longitude.toString()));
    }

    if (parameters?.selectedKeyword == null && parameters?.latLng == null) {
      formData.fields.add(MapEntry("location", searchQuery.toString()));
    }

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/hotel_search_by_parameters/?page=$page&limit=$limit",
      data: formData,
    );

    Response responseFilter = await DioHttpService().handlePostRequest(
      "booking/api_v_1/all_hotel_filters/",
      data: getPreviousParameters(),
    );

    if (response.statusCode == 200 && responseFilter.statusCode == 200) {
      var data = response.data["data"]["data"];

      if (data.length != 0) {
        originalFilter = HotelFilter.fromJson(responseFilter.data);
        filter = originalFilter?.copy();
      }

      if (response.data["data"]["total_data_count"] <= page * limit) {
        allDataLoaded = true;
      }

      for (var x in data) {
        hotelLists?.add(Hotel.fromJson(x));
      }

      noOfHotels = response.data["data"]["total_data_count"];
      hotelSearchResultNumber.value = noOfHotels as int;

      emit(HotelSearchLoaded());
    } else {
      emit(HotelSearchError());
    }
  }

  loadMoreHotels() async {
    emit(HotelSearchMoreLoading());

    page++;

    FormData formData = FormData.fromMap({
      "number_of_adult": maxAdults,
      "number_of_child": maxChildren,
      "number_of_infant": 0,
      "check_in_date": DateTimeFormatter.formatDateServer(dateRange?.start),
      "check_out_date": DateTimeFormatter.formatDateServer(dateRange?.end),
      "required_room": noOfRooms,
    });

    if (parameters?.selectedKeyword != null) {
      if (parameters?.selectedKeyword?.type == KeywordSearchType.HOTEL) {
        // formData.fields.add(MapEntry("location", null));
        formData.fields.add(
            MapEntry("hotel_id", parameters!.selectedKeyword!.id.toString()));
        // formData.fields.add(MapEntry("lat", null));
        // formData.fields.add(MapEntry("long", null));
      } else if (parameters?.selectedKeyword?.type == KeywordSearchType.CITY) {
        formData.fields.add(MapEntry("location", searchQuery.toString()));
      }
    }

    if (parameters?.latLng != null) {
      // formData.fields.add(MapEntry("location", null));
      // formData.fields.add(MapEntry("hotel_id", null));
      formData.fields
          .add(MapEntry("lat", parameters!.latLng!.latitude.toString()));
      formData.fields
          .add(MapEntry("long", parameters!.latLng!.longitude.toString()));
    }

    if (parameters!.selectedKeyword == null && parameters!.latLng == null) {
      formData.fields.add(MapEntry("location", searchQuery.toString()));
    }
    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/hotel_search_by_parameters/?page=$page&limit=$limit",
      data: formData,
    );

    if (response.statusCode == 200) {
      var data = response.data["data"]["data"];

      if (response.data["data"]["total_data_count"] <= page * limit) {
        allDataLoaded = true;
      }

      for (var x in data) {
        hotelLists?.add(Hotel.fromJson(x));
      }

      emit(HotelSearchLoaded());
    }
  }

  applyFilters(HotelFilter newFilter) async {
    emit(HotelSearchLoading());

    filteredApplied = true;
    page = 0;
    page++;
    filter = newFilter;

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/filter_inventories_by_parameters/",
      data: getFilterFormData(filter as HotelFilter),
    );

    if (response.statusCode == 200) {
      allDataLoaded = false;
      hotelLists?.clear();
      var data = response.data["hotel"]["data"];

      noOfHotels = response.data["hotel"]["total_data_count"];

      if (noOfHotels! <= page * limit) {
        allDataLoaded = true;
      }
      hotelSearchResultNumber.value = noOfHotels as int;

      for (var x in data) {
        hotelLists?.add(Hotel.fromJson(x));
      }

      if (sortPrice != null) {
        sortAsc
            ? hotelLists?.sort((a, b) => double.parse(a.minimumPrice.toString())
                .compareTo(double.parse(b.minimumPrice.toString())))
            : hotelLists?.sort((a, b) => double.parse(b.minimumPrice.toString())
                .compareTo(double.parse(a.minimumPrice.toString())));
      }

      if (sortRating != null) {
        sortAsc
            ? hotelLists?.sort(
                (a, b) => a.hotelRatingByUser!.compareTo(b.hotelRatingByUser!))
            : hotelLists?.sort(
                (a, b) => b.hotelRatingByUser!.compareTo(a.hotelRatingByUser!));
      }

      emit(HotelSearchLoaded());
    }
  }

  applyFiltersMore() async {
    filteredApplied = true;
    page++;

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/filter_inventories_by_parameters/",
      data: getFilterFormData(filter as HotelFilter),
    );

    if (response.statusCode == 200) {
      var data = response.data["hotel"]["data"];
      noOfHotels = response.data["hotel"]["total_data_count"];
      if (noOfHotels! <= page * limit) {
        allDataLoaded = true;
      }

      for (var x in data) {
        hotelLists?.add(Hotel.fromJson(x));
      }

      if (sortPrice != null) {
        sortAsc
            ? hotelLists?.sort((a, b) => double.parse(a.minimumPrice.toString())
                .compareTo(double.parse(b.minimumPrice.toString())))
            : hotelLists?.sort((a, b) => double.parse(b.minimumPrice.toString())
                .compareTo(double.parse(a.minimumPrice.toString())));
      }

      if (sortRating != null) {
        sortAsc
            ? hotelLists?.sort(
                (a, b) => a.hotelRatingByUser!.compareTo(b.hotelRatingByUser!))
            : hotelLists?.sort(
                (a, b) => b.hotelRatingByUser!.compareTo(a.hotelRatingByUser!));
      }

      emit(HotelSearchLoaded());
    }
  }

  getFilterFormData(HotelFilter filter) {
    Map<String, dynamic> filterFormData = {};

    filterFormData["page"] = page;
    filterFormData["limit"] = limit;

    filterFormData["previous_parameters"] = {
      "location": searchQuery,
      "number_of_adult": maxAdults,
      "number_of_child": maxChildren,
      "number_of_infant": 0,
      "check_in_date": DateTimeFormatter.formatDateServer(dateRange?.start),
      "check_out_date": DateTimeFormatter.formatDateServer(dateRange?.end),
      "required_room": noOfRooms,
    };

    //add hotel facilities
    List<Map<String, int>>? hotelFacilities = [];
    for (HotelFilterItem item in filter.hotelFacilities!) {
      if (item.checked!) {
        hotelFacilities.add({"id": item.id as int});
      }
    }
    filterFormData["hotel_facilities"] = hotelFacilities;

    //add inventories facilities
    List<Map<String, int>> inventoriesFacilities = [];
    for (HotelFilterItem item in filter.inventoriesFacilities!) {
      if (item.checked!) {
        inventoriesFacilities.add({"id": item.id!});
      }
    }
    filterFormData["inventories_facilities"] = inventoriesFacilities;

    //add inventories amenities
    List<Map<String, int>> inventoriesAmenities = [];
    for (HotelFilterItem item in filter.inventoriesAmenities!) {
      if (item.checked!) {
        inventoriesAmenities.add({"id": item.id!});
      }
    }
    filterFormData["inventories_amenities"] = inventoriesAmenities;

    //add inventories features
    List<Map<String, int>> inventoriesFeatures = [];
    for (HotelFilterItem item in filter.inventoriesFeatures!) {
      if (item.checked!) {
        inventoriesFeatures.add({"id": item.id!});
      }
    }
    filterFormData["inventories_features"] = inventoriesFeatures;

    //add hotel landmark
    List<Map<String, int>> hotelLandmark = [];
    for (HotelFilterItem item in filter.hotelLandmark!) {
      if (item.checked!) {
        hotelLandmark.add({"id": item.id!});
      }
    }
    filterFormData["hotel_landmark"] = hotelLandmark;

    //add inventory meal
    List<Map<String, int>> inventoryMeal = [];
    for (HotelFilterItem item in filter.inventoryMeal!) {
      if (item.checked!) {
        inventoryMeal.add({"id": item.id!});
      }
    }
    filterFormData["inventory_meal"] = inventoryMeal;

    //add inventory price
    Map<String, String> inventoryPrice = {};
    inventoryPrice["lowest"] = filter.inventoryPrice!.lowest.toString();
    inventoryPrice["highest"] = filter.inventoryPrice!.highest.toString();
    filterFormData["inventory_price"] = inventoryPrice;

    //add hotel safety
    Map<String, String> hotelSafety = {};
    hotelSafety["value"] = filter.hotelSafetyBool! ? "True" : "False";

    filterFormData["hotel_safety"] = hotelSafety;

    return filterFormData;
  }
}
