import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/route_manager.dart';

import '../../../../../common/model/user.dart';
import '../../../../../common/model/user_detail.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/logger.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../hive/hive_user.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  bool _phoneNumberVerified = false;

  String? _oldPhNumber;

  set oldPhNumber(String? value) {
    _oldPhNumber = value;
  }

  String? _newPhNumber;

  set newPhNumber(String? value) {
    _newPhNumber = value;
  }

  String? get newPhNumber => _newPhNumber;

  bool phoneNumberVerified(String? newPhNumber) {
    if (_oldPhNumber == newPhNumber) {
      return true;
    }
    return _phoneNumberVerified;
  }

  checkOtp(String otp, String phoneNumber, User u) async {
    BotToast.showLoading();

    User user;

    if (u == null) {
      user = HiveUser.getUser();
    } else {
      user = u;
    }

    FormData formData = FormData.fromMap({
      "otp": otp,
      "phone_number": phoneNumber,
    });

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/registration_otp/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );
    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      Get.back();
      showToast(text: "Phone number verified ! ", time: 5);
      _phoneNumberVerified = true;
      _newPhNumber = phoneNumber;
    } else if (response.statusCode == 400) {
      if (response.data["data"]["message"]
          .toString()
          .toLowerCase()
          .contains("duplicate")) {
        showToast(text: "Phone number already registered ! ", time: 5);
      } else {
        showToast(text: response.data["data"]["message"], time: 5);
      }
    } else {
      showToast(text: "Some error occured ! Try Again !!", time: 5);
    }
  }

  sendOtp(String phoneNumber, User u) async {
    BotToast.showLoading();

    User user;

    if (u == null) {
      user = HiveUser.getUser();
    } else {
      user = u;
    }

    Response response = await DioHttpService().handleGetRequest(
      "booking/api_v_1/send_otp/?phone_number=$phoneNumber",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();
    if (response.statusCode == 200) {
      showToast(text: "Please check your phone for OTP.", time: 5);
    } else {
      showToast(text: "Some error occured ! Try Again !!", time: 5);
    }
  }

  updateImage(String imagePath, {required User u}) async {
    User? user;

    if (u == null) {
      user = HiveUser.getUser();
    } else {
      user = u;
    }

    FormData formData = FormData.fromMap({});

    formData.files
        .add(MapEntry("image", MultipartFile.fromFileSync(imagePath)));

    Response response = await DioHttpService().handlePuttRequest(
      "booking/api_v_1/profile_update_front_end_user/${user.id}",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    if (response.statusCode == 200) {
      HiveUser.setUser(u);

      HiveUser.setUserDetail(UserDetail.fromJson(response.data));
    } else {
      showToast(text: "Error uploading image ! Try Again!!", time: 5);
    }
  }

  emailVerified(bool value) {
    _phoneNumberVerified = value;
  }

  updateDetails({
    String? fullName,
    String? address,
    int? countryId,
    String? gender,
    String? dob,
    User? u,
  }) async {
    emit(UpdateProfileLoading());
    User user;

    if (u == null) {
      user = HiveUser.getUser();
    } else {
      user = u;
    }

    FormData formData = FormData.fromMap({
      "name": fullName,
      "address": address,
      "gender": gender,
      "dob": dob,
      "contact": phoneNumberVerified(null) ? _newPhNumber : _oldPhNumber,
      "country": countryId,
    });

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/profile_update_front_end_user_for_web/${user.id}",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    if (response.statusCode == 200) {
      emit(UpdateProfileSuccess());
      printLog.d(response.data);
      if (u != null) {
        HiveUser.setUser(u);
        HiveUser.setUserDetail(UserDetail.fromJson(response.data));
        HiveUser.setLoggedIn(loggedIn: true);
        Get.offAndToNamed("/accountPage");
      } else {
        HiveUser.setUserDetail(UserDetail.fromJson(response.data));
        showToast(text: "Profile Updated !");
        Get.offAndToNamed("/accountPage");
      }
    } else {
      emit(UpdateProfileError());
      showToast(text: "Error updating profile ! Try Again !!");
    }
  }
}
