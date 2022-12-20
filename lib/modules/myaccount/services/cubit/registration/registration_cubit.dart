import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo/common/services/dio_http_service.dart';
import 'package:go_buddy_goo/common/widgets/common_widgets.dart';
import 'package:meta/meta.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  String? emailAddress;
  String? phoneNumber;
  String? token;
  String? otp;

  checkPhoneNumber(String phoneNumber, String signatureID) async {
    emit(RegistrationLoadingState());
    FormData formData = FormData.fromMap(
        {'phone_number': phoneNumber, 'signature_id': signatureID});
    Response response = await DioHttpService().handlePostRequest(
        'booking/api_v_1/get_otp_front_end_user/',
        data: formData);

    if (response.statusCode == 200) {
      emit(RegistertaionOtpState());
      // var responsedata = OtpResponse.fromJson(response.data);
    } else if (response.statusCode == 400) {
      otp = response.data['data']['otp'];

      if (response.data['data']['message']
          .toString()
          .toLowerCase()
          .contains("register")) {
        showToast(text: 'Please Register', time: 3);
        Get.toNamed('/signupScreen', arguments: [phoneNumber, otp]);
      } else {
        showToast(text: response.data['data']['phone_number'][0], time: 5);
      }
    }
  }

  // newcheckOtp({required String otp, required String phoneNumber}) async {
  //   BotToast.showLoading();

  //   FormData formData = FormData.fromMap({
  //     "otp": otp,
  //     "phone_number": phoneNumber,
  //   });

  //   Response response = await DioHttpService().handlePostRequest(
  //     "booking/api_v_1/registration_otp/",
  //     data: formData,
  //     options: Options(headers: {"Authorization": "Token $token"}),
  //   );
  //   BotToast.closeAllLoading();

  //   if (response.statusCode == 200) {
  //     printLog.d(response.data);
  //     // Get.back();
  //     showToast(text: "Phone number verified! login please wait !!", time: 5);
  //   } else if (response.statusCode == 400) {
  //     showToast(text: "Sorry, the submitted OTP doesn't match.", time: 5);
  //   } else {
  //     showToast(text: "Some error occureddddd ! Try Again !!", time: 5);
  //   }
  // }

  registration(Map<String, dynamic> credentials) async {
    emit(RegistrationLoadingState());

    Response response = await DioHttpService().handlePostRequest(
        'booking/api_v_1/register_front_end_user/',
        data: credentials);

    if (response.statusCode == 200) {
      token = response.data['token'];
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
      } else {
        showToast(text: response.data['data']['message']);
      }
    } else if (response.statusCode == 500) {
      showToast(text: response.data['data']['message']);
    }
  }
}
