import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/logger.dart';
import '../../../../../common/widgets/common_widgets.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  String? emailAddress;
  String? phoneNumber;
  String ?token;

  register(
      String email, String password, String phone, String referralCode) async {
    emit(SignUpLoading());

    emailAddress = email;
    phoneNumber = phone;

    FormData formData = FormData.fromMap({
      "email": email,
      "password": password,
      "referral_code": referralCode.isEmpty ? "null" : referralCode,
      "contact": phone,
    });

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/register_front_end_user/",
      data: formData,
    );

    if (response.statusCode == 201) {
      // Get.back();
      // showToast(text: "Account created ! Login to continue !!", time: 5);
      token = response.data["token"];
      emit(SignUpOtpVerification());
    } else if (response.statusCode == 400) {
      if (response.data["data"].toString().contains("contact")) {
        showToast(text: "User with this phone number already exists.", time: 5);
      } else if (response.data["data"].toString().contains("email")) {
        showToast(
            text: "User with this email address already exists.", time: 5);
      } else {
        showToast(text: "Some error occured ! Try Again !!", time: 5);
      }

      emit(SignUpError());
    } else {
      showToast(text: "Some error occured ! Try Again !!", time: 5);
      emit(SignUpError());
    }
  }

  checkOtp(String otp) async {
    BotToast.showLoading();

    FormData formData = FormData.fromMap({
      "otp": otp,
      "phone_number": phoneNumber,
    });

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/registration_otp/",
      data: formData,
      options: Options(headers: {"Authorization": "Token $token"}),
    );
    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      printLog.d(response.data);
      Get.back();
      showToast(text: "Phone number verified ! Login to continue !!", time: 5);
    } else if (response.statusCode == 400) {
      showToast(text: "Sorry, the submitted OTP doesn't match.", time: 5);
    } else {
      showToast(text: "Some error occured ! Try Again !!", time: 5);
    }
  }

  resendOtp() async {
    BotToast.showLoading();

    Response response = await DioHttpService().handleGetRequest(
        "booking/api_v_1/registration_otp/?phone_number=$phoneNumber");

    BotToast.closeAllLoading();
    if (response.statusCode == 200) {
      showToast(text: "Please check your phone for OTP.", time: 5);
    } else {
      showToast(text: "Some error occured ! Try Again !!", time: 5);
    }
  }
}
