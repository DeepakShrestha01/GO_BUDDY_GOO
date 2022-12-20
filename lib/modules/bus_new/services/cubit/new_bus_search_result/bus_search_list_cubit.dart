import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:go_buddy_goo_mobile/common/widgets/common_widgets.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_error_response.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_select_bus_response.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/passenger_details_response.dart';
import 'package:meta/meta.dart';

import '../../../model/new_bus_search_list_response.dart';

part 'bus_search_list_state.dart';

class BusSearchListCubit extends Cubit<BusSearchListState> {
  BusSearchListCubit() : super(BusSearchListInitial());

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
      var responsedata = SelectBusResponse.fromJson(response.data);
      var responseError = NewBusErrorResponse.fromJson(response.data);
      if (responseError.status == true) {
        emit(SelectBusSuccessState(response: responsedata));

        boardingPoint = responsedata.detail?.boardingPoint;
        ticketSerialNo = responsedata.detail?.ticketSerialNo;
      } else if (responseError.status == false) {
        // showToast(text: '${responseError.details}');
        emit(SelectBusErrorState(response: responseError.details));
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
}
