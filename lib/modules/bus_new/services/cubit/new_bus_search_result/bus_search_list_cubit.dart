import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_buddy_goo/common/services/dio_http_service.dart';
import 'package:go_buddy_goo/common/widgets/common_widgets.dart';
import 'package:go_buddy_goo/modules/bus_new/model/new_bus_error_response.dart';
import 'package:go_buddy_goo/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:go_buddy_goo/modules/bus_new/model/new_select_bus_response.dart';
import 'package:go_buddy_goo/modules/bus_new/model/passenger_details_response.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../model/new_bus_search_list_response.dart';
import '../../../model/no_of_busnotifier.dart';

part 'bus_search_list_state.dart';

class BusSearchListCubit extends Cubit<BusSearchListState> {
  BusSearchListCubit() : super(BusSearchListInitial());

  bool? sortPrice;
  bool? sortTime;
  bool sortAsc = true;

  // updateValueNotifierValues() {
  //   noOfBusesFilter.value = inBoundData?.length;
  // }

  NewBusSearchListResponse? responsedatafilter;

  List<Buses>? buses = [];
  int? sessionId;
  String? busID;
  List<String>? boardingPoint;
  String? ticketSerialNo;

  List<String>? selectedSeats;
  NewBusSearchListParameters parameters = NewBusSearchListParameters();

  void getNewBusSearchResult() async {
    emit(BusSearchListLoadingState());

    Response response = await DioHttpService().handleGetRequest(
      'bus/search/?from=${parameters.from}&to=${parameters.to}&date=${parameters.departureDate?.year}-${parameters.departureDate?.month}-${parameters.departureDate?.day}&shift=both',
      // 'bus/search/?from=${parameters.from}&to=${parameters.to}&date=${parameters.departureDate?.year}-${parameters.departureDate?.month}-${parameters.departureDate?.day}&shift=${parameters.shift}',
    );

    if (response.statusCode == 200) {
      var responsedata = NewBusSearchListResponse.fromJson(response.data);
      var errorResponse = NewBusErrorResponse.fromJson(response.data);
      if (responsedata.status == true) {
        buses = responsedata.buses;
        // sessionId = responsedata.sessionId;
        emit(BusSearchListSuccessState(response: responsedata));
      }

      if (errorResponse.status == false) {
        emit(BusSearchListErrorState());
        showToast(text: '${errorResponse.details}');
      }
    }
  }

// -----------------------------------------------------------
  String getBusSeatReservedString(String busSeat) {
    return '["$busSeat"]';
  }

  void postSelectedBus(String busId, int sessionID, List<String> seats) async {
    busID = busId;
    sessionId = sessionID;
    parameters.sessionID = sessionID;
    selectedSeats = parameters.seats;
    // print("selectbos : $selectedSeats");

    FormData formData = FormData.fromMap({
      'session_id': sessionID,
      'bus_id': busId,
      // 'seats': seats.map((e) {
      //   return <String>['"$e"'];
      // }).toList()
    });
    for (String seat in selectedSeats!) {
      formData.fields.add(MapEntry('seats', getBusSeatReservedString(seat)));
    }

    Response response =
        await DioHttpService().handlePostRequest('bus/select/', data: formData);

    if (response.statusCode == 200) {
      if (response.data['status'] == false) {
        showToast(text: response.data['details']);
      }
      if (response.data['status'] == true) {
        var responsedata = SelectBusResponse.fromJson(response.data);
        boardingPoint = responsedata.detail?.boardingPoint;
        ticketSerialNo = responsedata.detail?.ticketSerialNo;
        emit(SelectBusSuccessState(response: responsedata));
      }
    }
  }

// --------------------------------------------------------------

  // String getBusSeatSelected(String busSeat) {
  //   return "[$busSeat]";
  // }

  void passengerDetails(
      {String? mobileNumber,
      String? boardingPoint,
      String? email,
      String? name,
      required List<Map<String, String>> seats,
      String? boardingDate}) async {
    FormData formData = FormData.fromMap({
      'session_id': sessionId,
      'bus_id': busID,
      'ticket_serial_no': ticketSerialNo,
      'mobile_number': mobileNumber,
      'boarding_point': boardingPoint,
      'boarding_date': boardingDate,
      'email': email,
      'name': name,
      'seats': seats.map((e) {
        return {
          'seat': e['seat'],
          'name_of_passenger': e['name_of_passenger'],
          'age': e['age']
        };
      })
    });

    // for (String seat in selectedSeats!) {
    //   formData.fields.add(MapEntry('seats', getBusSeatSelected(seat)));
    // }

    Response response = await DioHttpService().handlePostRequest(
      'bus/passengers/details/',
      data: formData,
    );

    if (response.statusCode == 200) {
      var responseData = PassengerDetailsResponse.fromJson(response.data);
      var responseError = NewBusErrorResponse.fromJson(response.data);

      if (responseData.status == true) {
        showToast(text: '${responseData.detail}');
      }

      if (responseError.status == false) {
        showToast(text: '${responseError.details}');
      }
    }
  }

//  filter by price and time
  void filterBus() async {
    BotToast.showLoading();

    if (sortPrice != null) {
      sortPrice = sortAsc;
      print('asc : $sortPrice');

      if (sortPrice!) {
        buses?.sort(
          (a, b) {
            return double.parse(a.ticketPrice.toString())
                .compareTo(double.parse(b.ticketPrice.toString()));
          },
        );
      } else {
        buses?.sort(
          (a, b) {
            return double.parse(b.ticketPrice.toString())
                .compareTo(double.parse(a.ticketPrice.toString()));
          },
        );
      }
    }

    if (sortTime != null) {
      sortTime = sortAsc;
      if (sortTime!) {
        buses?.sort(
          (a, b) {
            TimeOfDay time1 = DateTimeFormatter.formatTimeWithAmPm(
                a.departureTime.toString());
            int mins1 = time1.hour * 60 + time1.minute;

            TimeOfDay time2 = DateTimeFormatter.formatTimeWithAmPm(
                b.departureTime.toString());
            int mins2 = time2.hour * 60 + time2.minute;

            if (mins1 > mins2) {
              return 1;
            } else if (mins1 < mins2) {
              return -1;
            } else {
              return 0;
            }
          },
        );
      } else {
        buses?.sort(
          (a, b) {
            TimeOfDay time1 = DateTimeFormatter.formatTimeWithAmPm(
                b.departureTime.toString());
            int mins1 = time1.hour * 60 + time1.minute;

            TimeOfDay time2 = DateTimeFormatter.formatTimeWithAmPm(
                a.departureTime.toString());
            int mins2 = time2.hour * 60 + time2.minute;

            if (mins1 > mins2) {
              return 1;
            } else if (mins1 < mins2) {
              return -1;
            } else {
              return 0;
            }
          },
        );
      }
    }
    await Future.delayed(const Duration(seconds: 1), () {});

    BotToast.closeAllLoading();
    emit(BusSearchListSuccessState(response: responsedatafilter!));
  }
}
