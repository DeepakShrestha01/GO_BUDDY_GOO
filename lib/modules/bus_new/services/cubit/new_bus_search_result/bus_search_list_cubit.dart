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
  List<String>? boardingPoint;
  String? ticketSerialNo;
  NewBusSearchListParameters parameters = NewBusSearchListParameters();

  void getNewBusSearchResult() async {
    emit(BusSearchListLoadingState());

    Response response = await DioHttpService().handleGetRequest(
      'bus/search/?from=${parameters.from}&to=${parameters.to}&date=${parameters.departureDate?.year}-${parameters.departureDate?.month}-${parameters.departureDate?.day}&shift=${parameters.shift}',
    );

    if (response.statusCode == 200) {
      var responsedata = NewBusSearchListResponse.fromJson(response.data);
      var errorResponse = NewBusErrorResponse.fromJson(response.data);
      if (responsedata.status == true) {
        buses = responsedata.buses;
        sessionId = responsedata.sessionId;
        emit(BusSearchListSuccessState(response: responsedata));
      }

      if (errorResponse.status == false) {
        showToast(text: '${errorResponse.details}');
      }
    }
  }

  void postSelectedBus(String busId, List<String> seats) async {
    emit(SelectBusLoadingState());
    Response response =
        await DioHttpService().handlePostRequest('bus/select/', data: {
      'session_id': sessionId,
      'bus_id': busId,
      'seats': seats,
    });

    if (response.statusCode == 200) {
      var responsedata = SelectBusResponse.fromJson(response.data);
      var responseError = NewBusErrorResponse.fromJson(response.data);
      if (responseError.status == true) {
        boardingPoint = responsedata.detail?.boardingPoint;
        ticketSerialNo = responsedata.detail?.ticketSerialNo;
        emit(SelectBusSuccessState());
      } else if (responseError.status == false) {
        showToast(text: '${responseError.details}');
        emit(SelectBusErrorState());
      }
    }
  }

  void passengerDetails(
    int mobileNumber,
    String? email,
    String? name,
    DateTime boardingDate,
    List<String> seats,
  ) async {
    Response response =
        await DioHttpService().handlePostRequest('passengers/details/', data: {
      'session_id': sessionId,
      'ticket_serial_no': ticketSerialNo,
      'mobile_number': mobileNumber,
      'boarding_point': boardingPoint,
      'email': email,
      'name': name,
      'seats': []
    });

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
