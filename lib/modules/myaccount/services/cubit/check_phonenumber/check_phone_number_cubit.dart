import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:go_buddy_goo_mobile/common/widgets/common_widgets.dart';
import 'package:go_buddy_goo_mobile/modules/myaccount/model/check_phone_number_model.dart';
import 'package:meta/meta.dart';

part 'check_phone_number_state.dart';

class CheckPhoneNumberCubit extends Cubit<CheckPhoneNumberState> {
  CheckPhoneNumberCubit() : super(CheckPhoneNumberInitial());

  checkPhoneNumber(String phoneNumber) async {
    String? otpcode;
    emit(CheckPhoneNumberLoadingState());
    try {
      FormData formData = FormData.fromMap({'contact': phoneNumber});
      Response response = await DioHttpService().handlePostRequest(
          'booking/api_v_1/get_otp_front_end_user/',
          data: formData);
      otpcode = response.data['data']['otp'];

      if (response.statusCode == 201) {
        emit(CheckPhoneNumberVerifyingState(response: response.data));
      } else if (response.statusCode == 404) {
        if (response.data['data']['message']
            .toString()
            .toLowerCase()
            .contains("user doesnot exist")) {
          Get.toNamed('/signupScreen', arguments: otpcode);
          showToast(text: '${response.data['data']['message']} ');
        } else {
          showToast(text: response.data["data"]["message"], time: 5);
        }
      }
    } catch (e) {
      emit(CheckPhoneNumberErrorState(error: e.toString()));
    }
  }
}
