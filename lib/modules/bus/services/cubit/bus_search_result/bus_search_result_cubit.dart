import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';

import '../../../model/bus.dart';
import '../../../model/bus_booking_detail_parameters.dart';

part 'bus_search_result_state.dart';

class BusSearchResultCubit extends Cubit<BusSearchResultState> {
  BusSearchResultCubit() : super(BusSearchResultInitial());

  List<Bus> buses = [];
  BusBookingDetailParameters? parameters;

  ValueNotifier<int>? noOfBuses = ValueNotifier(0);

  int page = 0;
  int limit = 10;

  bool allDataLoaded = false;

  getBusSearchResult(bool isLoadMore) async {
    if (!isLoadMore) {
      parameters = locator<BusBookingDetailParameters>();

      buses.clear();

      emit(BusSearchResultLoading());
    }
    page++;

    FormData formData = FormData.fromMap({
      "booking_date":
          DateTimeFormatter.formatDateServer(parameters?.departureDate),
      "bus_from": parameters?.fromId,
      "bus_to": parameters?.toId,
      "page": page,
      "page_limit": limit,
      "bus_shift": parameters?.shift,
    });

    Response response = await DioHttpService()
        .handlePostRequest("rental/api/bus_daily/list/", data: formData);

    if (response.statusCode == 200) {
      noOfBuses?.value = response.data["bus_count"];

      var data = response.data["bus_list"];

      if (response.data["bus_count"] <= page * limit) {
        allDataLoaded = true;
      }

      for (var x in data) {
        buses.add(Bus.fromJson(x));
      }

      emit(BusSearchResultLoaded());
    }
  }
}
