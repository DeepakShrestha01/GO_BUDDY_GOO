import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:go_buddy_goo_mobile/common/widgets/common_widgets.dart';
import 'package:meta/meta.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  registration(Map<String, dynamic> credentials) async {
    emit(RegistrationLoadingState());

    Response response = await DioHttpService().handlePostRequest(
        'booking/api_v_1/register_front_end_user/',
        data: credentials);
    print(response.toString());

    if (response.statusCode == 201) {
      showToast(text: 'Successfully Registered');
      Get.offNamedUntil(
        '/accountPage',
        (route) => false,
      );

      emit(RegistrationSuccessState());
    } else if (response.statusCode == 400) {
      if (response.data['data'].toString().contains('email')) {
        showToast(text: 'user with this email address already exists.');
      } else if (response.data['data'].toString().contains('contact')) {
        showToast(text: 'user with this contact already exists.');
      }
    }
  }
}
