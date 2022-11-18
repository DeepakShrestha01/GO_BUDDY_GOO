import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:meta/meta.dart';

import '../../../../../common/widgets/common_widgets.dart';

part 'login_with_password_state.dart';

class LoginWithPasswordCubit extends Cubit<LoginWithPasswordState> {
  LoginWithPasswordCubit() : super(LoginWithPasswordInitial());
  loginwithPassword({required String phone, required String password}) async {
    emit(LoginWithPasswordLoadingState());

    FormData formData = FormData.fromMap(
      {
        'phone': phone,
        'password': password,
        'is_verified': false,
      },
    );
    Response response = await DioHttpService().handlePostRequest(
      'booking/api_v_1/login_front_end_user/',
      data: formData,
    );
    // RegistrationResponse responsedata =
    //     RegistrationResponse.fromJson(response.data);

    // print('passwordcre : ${responsedata.toString()}');
    if (response.statusCode == 200) {
      Get.offAndToNamed('/');
    } else if (response.statusCode == 400) {
      showToast(text: '${response.data['data']}', time: 5);
    }
  }
}
