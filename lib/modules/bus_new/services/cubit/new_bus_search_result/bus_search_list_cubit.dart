import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:go_buddy_goo_mobile/common/widgets/common_widgets.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_error_response.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:meta/meta.dart';

import '../../../model/new_bus_search_list_response.dart';

part 'bus_search_list_state.dart';

class BusSearchListCubit extends Cubit<BusSearchListState> {
  BusSearchListCubit() : super(BusSearchListInitial());

  List<Buses>? buses = [];
  NewBusSearchListParameters parameters = NewBusSearchListParameters();

  getNewBusSearchResult() async {
    emit(BusSearchListLoadingState());

    Response response = await DioHttpService().handleGetRequest(
      'bus/search/?from=${parameters.from}&to=${parameters.to}&date=${parameters.departureDate?.year}-${parameters.departureDate?.month}-${parameters.departureDate?.day}&shift=${parameters.shift}',
    );

    if (response.statusCode == 200) {
      var responsedata = NewBusSearchListResponse.fromJson(response.data);
      var errorResponse = NewBusErrorResponse.fromJson(response.data);
      if (responsedata.status == true) {
        buses = responsedata.buses;
        emit(BusSearchListSuccessState(response: responsedata));
      }

      if (errorResponse.status == false) {
        showToast(text: '${errorResponse.details}');
      }
    }
  }
}
