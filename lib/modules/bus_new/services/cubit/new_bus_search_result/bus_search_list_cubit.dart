import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:meta/meta.dart';

import '../../../model/new_bus_search_list_response.dart';

part 'bus_search_list_state.dart';

class BusSearchListCubit extends Cubit<BusSearchListState> {
  BusSearchListCubit() : super(BusSearchListInitial());

  List<Buses>? buses ;
  NewBusSearchListParameters parameters = NewBusSearchListParameters();

  getNewBusSearchResult() async {
    emit(BusSearchListLoadingState());

    Response response = await DioHttpService().handleGetRequest(
      'bus/search/?from=${parameters.from}&to=${parameters.to}&date=${parameters.departureDate?.year}-${parameters.departureDate?.month}-${parameters.departureDate?.day}&shift=${parameters.shift}',
    );

    if (response.statusCode == 200) {
      // buses.add(Buses.fromJson(response.data['buses']));
      // var data = Buses.fromJson(response.data['buses']);
      // buses.add(data);

      // var data = NewBusSearchListResponse.fromJson(response.data);

      // var data1 = NewBusSearchListResponse.fromJson(response.data);

      // for (var x in response.data['buses']) {
      //   buses.add(Buses.fromJson(x));

      // }

      var responsedata = NewBusSearchListResponse.fromJson(response.data);
      buses = responsedata.buses;

      emit(BusSearchListSuccessState(response: responsedata));
    }
  }
}
