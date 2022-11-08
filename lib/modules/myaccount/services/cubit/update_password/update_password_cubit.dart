import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/widgets/common_widgets.dart';

part 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit() : super(UpdatePasswordInitial());

  String? email;
  String? phone;

  sendOtp(String e) async {
    emit(UpdatePasswordLoading());
    email = e;
    FormData formData = FormData.fromMap({"email": e});

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/front_end_user_password_reset/",
      data: formData,
    );

    if (response.statusCode == 200) {
      emit(UpdatePasswordOtpSent());
    } else {
      showToast(text: "Error sending OTP code ! Try Again!!");
      emit(UpdatePasswordInitial());
    }
  }

  updatePassword(String otp, String password) async {
    emit(UpdatePasswordChangeLoading());

    FormData formData =
        FormData.fromMap({"email": email, "password": password, "code": otp});

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/front_end_user_password_change/",
      data: formData,
    );

    if (response.statusCode == 200) {
      Get.back();
      showToast(text: "Password changed !");
    } else if (response.statusCode == 400) {
      showToast(text: "Incorrect OTP code!");
      emit(UpdatePasswordOtpSent());
    } else {
      showToast(text: "Error updating password ! Try Again!!");
      emit(UpdatePasswordOtpSent());
    }
  }

  reSendOtp(String phone) async {
    emit(UpdatePasswordLoading());
    this.phone = phone;

    Response response = await DioHttpService()
        .handleGetRequest("booking/api_v_1/resend_otp/?phone_number=$phone");

    if (response.statusCode == 200) {
      emit(UpdatePasswordOtpSent());
    } else {
      try {
        showToast(text: response.data['data']["message"]);
        emit(UpdatePasswordInitial());
      } catch (e) {
        showToast(text: "Error sending OTP code ! Try Again!!");
        emit(UpdatePasswordInitial());
      }
    }
  }

  checkOtp(String otp) async {
    BotToast.showLoading();

    FormData formData = FormData.fromMap({
      "otp": otp,
      "phone_number": phone,
    });

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/registration_otp_new/",
      data: formData,
    );
    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      Get.back();
      showToast(text: "Phone number verified ! Login to continue !!", time: 5);
    } else if (response.statusCode == 400) {
      showToast(text: "Sorry, the submitted OTP doesn't match.", time: 5);
    } else {
      showToast(text: "Some error occured ! Try Again !!", time: 5);
    }
  }
}
