import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:meta/meta.dart';

part 'bus_search_list_state.dart';

class BusSearchListCubit extends Cubit<BusSearchListState> {
  BusSearchListCubit() : super(BusSearchListInitial());

  List<NewBusSearchListResponse> newBuses = [];
  NewBusSearchListParameters parameters = NewBusSearchListParameters();
  getNewBusSearchResult() async {
    emit(BusSearchListLoadingState());
    FormData formData = FormData.fromMap({
      'from': parameters.from,
      'to': parameters.to,
      'date': parameters.departureDate,
      'shift': parameters.shift
    });

    Response response =
        await DioHttpService().handlePostRequest('bus/search/', data: formData);

    if (response.statusCode == 200) {
      var data = response.data['buses'];
      for (var x in data) {
        newBuses.add(x);
      }
    emit(BusSearchListSuccessState());
    }
  }
}
