import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:meta/meta.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/airline_list_payload.dart';
import '../../../model/flight_search_parameters.dart';
import '../../../model/flightsearchresultdata.dart';
import '../../../model/no_of_flightnotifier.dart';

part 'flight_search_result_state.dart';

class FlightSearchResultCubit extends Cubit<FlightSearchResultState> {
  FlightSearchResultCubit() : super(FlightSearchResultInitial());

  final parameters = locator<FlightSearchParameters>();

  late final FlightSearchResultData searchData;

  Bound? selectedInbound;
  Bound? selectedOutbound;

  List<Bound>? outBoundData = [];
  List<Bound>? inBoundData = [];

  bool? sortPrice;

  bool? sortTime;

  bool? filterRefundable;

  Airline? selectedAirlines;

  bool sortAsc = true;

  updateValueNotifierValues() {
    noOfInboundFlights.value = inBoundData?.length;
    noOfOutboundFlights.value = outBoundData?.length;
  }

  selectInBound(Bound b) {
    if (selectedInbound != null) {
      if (selectedInbound == b) {
        selectedInbound = null;
      } else {
        selectedInbound = b;
      }
    } else {
      selectedInbound = b;
    }
  }

  selectOutBound(Bound b) {
    if (selectedOutbound != null) {
      if (selectedOutbound == b) {
        selectedOutbound = null;
      } else {
        selectedOutbound = b;
      }
    } else {
      selectedOutbound = b;
    }
  }

  filterAirline(Airline? airline) async {
    BotToast.showLoading();

    selectedAirlines = airline;
    selectedInbound = null;
    selectedOutbound = null;

    if (airline != null) {
      List<Bound> filteredOutBounds = [];

      for (var x in searchData.outbound!) {
        if (x.agency?.toLowerCase() == airline.agencyName?.toLowerCase()) {
          filteredOutBounds.add(x);
        }
      }
      outBoundData = filteredOutBounds;
    } else {
      outBoundData = searchData.outbound;
    }

    if (airline != null) {
      List<Bound> filteredInBounds = [];

      for (var x in searchData.inbound!) {
        if (x.agency?.toLowerCase() == airline.agencyName?.toLowerCase()) {
          filteredInBounds.add(x);
        }
      }
      inBoundData = filteredInBounds;
    } else {
      inBoundData = searchData.inbound;
    }

    if (sortPrice != null) {
      sortPrice = sortAsc;
      if (sortPrice!) {
        outBoundData?.sort((a, b) => double.parse(
                a.airFare!.totalPriceAfterDiscount.toString())
            .compareTo(
                double.parse(b.airFare!.totalPriceAfterDiscount.toString())));

        inBoundData?.sort((a, b) => double.parse(
                a.airFare!.totalPriceAfterDiscount.toString())
            .compareTo(
                double.parse(b.airFare!.totalPriceAfterDiscount.toString())));
      } else {
        outBoundData?.sort((b, a) => double.parse(
                a.airFare!.totalPriceAfterDiscount.toString())
            .compareTo(
                double.parse(b.airFare!.totalPriceAfterDiscount.toString())));

        inBoundData?.sort((b, a) => double.parse(
                a.airFare!.totalPriceAfterDiscount.toString())
            .compareTo(
                double.parse(b.airFare!.totalPriceAfterDiscount.toString())));
      }
    }

    if (sortTime != null) {
      sortTime = sortAsc;
      if (sortTime!) {
        outBoundData?.sort((a, b) {
          TimeOfDay time1 =
              DateTimeFormatter.formatTimeWithAmPm(a.departureTime.toString());
          int mins1 = time1.hour * 60 + time1.minute;

          TimeOfDay time2 =
              DateTimeFormatter.formatTimeWithAmPm(b.departureTime.toString());
          int mins2 = time2.hour * 60 + time2.minute;

          if (mins1 > mins2) {
            return 1;
          } else if (mins1 < mins2) {
            return -1;
          } else {
            return 0;
          }
        });

        inBoundData?.sort((a, b) {
          TimeOfDay time1 =
              DateTimeFormatter.formatTimeWithAmPm(a.departureTime.toString());
          int mins1 = time1.hour * 60 + time1.minute;

          TimeOfDay time2 =
              DateTimeFormatter.formatTimeWithAmPm(b.departureTime.toString());
          int mins2 = time2.hour * 60 + time2.minute;

          if (mins1 > mins2) {
            return 1;
          } else if (mins1 < mins2) {
            return -1;
          } else {
            return 0;
          }
        });
      } else {
        outBoundData?.sort((b, a) {
          TimeOfDay time1 =
              DateTimeFormatter.formatTimeWithAmPm(a.departureTime.toString());
          int mins1 = time1.hour * 60 + time1.minute;

          TimeOfDay time2 =
              DateTimeFormatter.formatTimeWithAmPm(b.departureTime.toString());
          int mins2 = time2.hour * 60 + time2.minute;

          if (mins1 > mins2) {
            return 1;
          } else if (mins1 < mins2) {
            return -1;
          } else {
            return 0;
          }
        });

        inBoundData?.sort((b, a) {
          TimeOfDay time1 =
              DateTimeFormatter.formatTimeWithAmPm(a.departureTime.toString());
          int mins1 = time1.hour * 60 + time1.minute;

          TimeOfDay time2 =
              DateTimeFormatter.formatTimeWithAmPm(b.departureTime.toString());
          int mins2 = time2.hour * 60 + time2.minute;

          if (mins1 > mins2) {
            return 1;
          } else if (mins1 < mins2) {
            return -1;
          } else {
            return 0;
          }
        });
      }
    }

    if (filterRefundable != null) {
      if (filterRefundable!) {
        outBoundData?.removeWhere((x) => x.refundable?.toLowerCase() == "no");

        inBoundData?.removeWhere((x) => x.refundable?.toLowerCase() == "no");
      } else {
        outBoundData?.removeWhere((x) => x.refundable?.toLowerCase() == "yes");

        inBoundData?.removeWhere((x) => x.refundable?.toLowerCase() == "yes");
      }
    }

    await Future.delayed(const Duration(seconds: 1), () {});

    updateValueNotifierValues();

    BotToast.closeAllLoading();
    emit(FlightSearchResultLoaded());
  }

  clearFilter() {
    selectedInbound = null;
    selectedOutbound = null;
    outBoundData = searchData.outbound;
    inBoundData = searchData.inbound;
    sortPrice = null;
    sortTime = null;
    filterRefundable = null;
    sortAsc = true;
    selectedAirlines = null;
    updateValueNotifierValues();

    emit(FlightSearchResultLoaded());
  }

  getFlightSearchResult() async {
    emit(FlightSearchResultLoading());

    String flightDate =
        "${parameters.departureDate?.year}-${parameters.departureDate?.month}-${parameters.departureDate?.day}";

    String returnDate;
    if (parameters.tripType == "R") {
      returnDate =
          "${parameters.returnDate?.year}-${parameters.returnDate?.month}-${parameters.returnDate?.day}";
    } else {
      returnDate = "";
    }

    FormData formData = FormData.fromMap({
      "sector_from": parameters.fromSector?.sectorCode,
      "sector_to": parameters.toSector?.sectorCode,
      "flight_date": flightDate,
      "return_date": returnDate,
      "trip_type": parameters.tripType,
      "number_of_adult": parameters.adults,
      "number_of_child": parameters.children,
      "number_of_infant": parameters.infants,
      "nationality": parameters.nationality?.countryCode,
    });

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/flight_v1/flight_availability/",
      data: formData,
    );

    if (response.statusCode == 200 && response.data["success"]) {
      searchData = FlightSearchResultData.fromJson(response.data["data"]);

      outBoundData = searchData.outbound;
      inBoundData = searchData.inbound;

      updateValueNotifierValues();

      emit(FlightSearchResultLoaded());
    } else {
      emit(FlightSearchResultError());
    }
  }
}
