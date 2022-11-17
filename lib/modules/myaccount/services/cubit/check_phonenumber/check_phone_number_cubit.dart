import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:meta/meta.dart';

part 'check_phone_number_state.dart';

class CheckPhoneNumberCubit extends Cubit<CheckPhoneNumberState> {
  CheckPhoneNumberCubit() : super(CheckPhoneNumberInitial());

  checkPhoneNumber(String phoneNumber) async {
    emit(CheckPhoneNumberLoadingState());
    FormData formData = FormData.fromMap({'contact': phoneNumber});
    Response response = await DioHttpService().handlePostRequest(
        'booking/api_v_1/get_otp_front_end_user/',
        data: formData);
    if (response.statusCode == 200) {
      emit(CheckPhoneNumberVerifyingState());
    } else {
      emit(CheckPhoneNumberNotVerifyingState());
    }
  }
}
