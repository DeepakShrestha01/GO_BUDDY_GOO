import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../model/bus_detail.dart';

part 'bus_detail_state.dart';

class BusDetailCubit extends Cubit<BusDetailState> {
  BusDetailCubit() : super(BusDetailInitial());

  BusDetail? busDetail;

  getBusDetail({
    int? busId,
    String? bookingDate,
    bool? busDailyUpdatedStatus,
  }) async {
    emit(BusDetailLoading());

    FormData formData = FormData.fromMap({
      "bus_daily_id": busId,
      "booking_date": bookingDate,
      "bus_daily_updated_status": busDailyUpdatedStatus,
    });

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/bus_daily/detail/",
      data: formData,
    );

    if (response.statusCode == 200) {
      busDetail = BusDetail.fromJson(response.data);
      emit(BusDetailLoaded());
    }
  }
}
