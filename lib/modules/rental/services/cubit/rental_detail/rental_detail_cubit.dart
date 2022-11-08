import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/logger.dart';
import '../../../model/rental.dart';

part 'rental_detail_state.dart';

class RentalDetailCubit extends Cubit<RentalDetailState> {
  RentalDetailCubit() : super(RentalDetailInitial());

  Rental vehicle = Rental();

  getVehicleDetail(int rentalId) async {
    printLog.d(rentalId);
    emit(RentalDetailLoading());

    FormData formData = FormData.fromMap({"vehicle_inventory_id": rentalId});

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/vehicle_inventory/detail/",
      data: formData,
    );

    if (response.statusCode == 200) {
      vehicle = Rental.fromJson(response.data);
      emit(RentalDetailLoaded());
    }
  }
}
