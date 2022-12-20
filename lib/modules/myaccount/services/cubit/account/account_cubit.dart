import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo/modules/myaccount/model/otp_response.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/user.dart';
import '../../../../../common/model/user_detail.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/logger.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../hive/hive_user.dart';

// import 'package:convex_bottom_bar/convex_bottom_bar.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());
  String? otpcode;
  getAccountState() async {
    emit(AccountProcessing());
    bool loggedIn = HiveUser.getLoggedIn();

    if (loggedIn) {
      emit(AccountLoggedIn());
    } else {
      emit(AccountLoggedOut());
    }
  }

  loginWithOTP({required Map<String, dynamic> credentials}) async {
    emit(AccountLoggingIn());

    Response response = await DioHttpService().handlePostRequest(
        'booking/api_v_1/login_front_end_user/',
        data: credentials);

    if (response.statusCode == 200) {
      if (response.data["profile_status"] == "True") {
        User newUser = User.fromJson(response.data);

        Response responseDetail = await DioHttpService().handleGetRequest(
          "booking/api_v_1/profile_get_front_end_user/",
          options:
              Options(headers: {"Authorization": "Token ${newUser.token}"}),
        );

        if (responseDetail.statusCode == 200) {
          await HiveUser.setUser(newUser);
          await HiveUser.setLoggedIn(loggedIn: true);
          UserDetail userDetail = UserDetail.fromJson(responseDetail.data);
          await HiveUser.setUserDetail(userDetail);

          emit(AccountLoggedIn());
        } else {
          showToast(text: "Some error occured! Try Again!!", time: 5);
          emit(AccountLoggedOut());
        }
      } else if (response.data['profile_status'] == 'False') {
        Get.offAndToNamed("/updateProfile",
            arguments: User.fromJson(response.data));
      }
    } else if (response.statusCode == 400) {
      try {
        showToast(text: response.data['data']['non_field_errors'][0], time: 5);
      } catch (e) {
        showToast(text: "Some error occured! Try Again!!", time: 5);
      }
      emit(AccountLoggedOut());
    } else {
      showToast(text: "Some error occured! Try Again!!", time: 5);
      emit(AccountLoggedOut());
    }
  }

  loginWithPassword({required String phone, required String password}) async {
    emit(AccountLoggingIn());
    FormData formData = FormData.fromMap(
      {
        'phone': phone,
        'password': password,
        'is_verified': false,
      },
    );

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/login_front_end_user/",
      data: formData,
    );

    if (response.statusCode == 200) {
      if (response.data["profile_status"] == "True") {
        User newUser = User.fromJson(response.data);

        Response responseDetail = await DioHttpService().handleGetRequest(
          "booking/api_v_1/profile_get_front_end_user/",
          options:
              Options(headers: {"Authorization": "Token ${newUser.token}"}),
        );

        if (responseDetail.statusCode == 200) {
          await HiveUser.setUser(newUser);
          await HiveUser.setLoggedIn(loggedIn: true);
          UserDetail userDetail = UserDetail.fromJson(responseDetail.data);
          await HiveUser.setUserDetail(userDetail);

          emit(AccountLoggedIn());
        } else {
          showToast(text: "Some error occured! Try Again!!", time: 5);
          emit(AccountLoggedOut());
        }
      } else {
        Get.offAndToNamed("/updateProfile",
            arguments: User.fromJson(response.data));
      }
    } else if (response.statusCode == 400) {
      try {
        showToast(text: response.data['data']['non_field_errors'][0], time: 5);
      } catch (e) {
        showToast(text: "Some error occured! Try Again!!", time: 5);
      }
      emit(AccountLoggedOut());
    } else {
      showToast(text: "Some error occured! Try Again!!", time: 5);
      emit(AccountLoggedOut());
    }
  }

  // checkPhoneNumber(String phoneNumber) async {
  //   FormData formData = FormData.fromMap({
  //     'phone_number': phoneNumber,
  //   });
  //   Response response = await DioHttpService().handlePostRequest(
  //       'booking/api_v_1/get_otp_front_end_user/',
  //       data: formData);

  //   if (response.statusCode == 200) {
  //     var responsedata = OtpResponse.fromJson(response.data);
  //     emit(AccountLogginWithOTP(otp: responsedata));
  //   } else if (response.statusCode == 404) {
  //     if (response.data['data']['message']
  //         .toString()
  //         .toLowerCase()
  //         .contains("register")) {
  //       showToast(text: '${response.data['data']['message']} ');
  //       Get.toNamed('/signupScreen', arguments: phoneNumber);
  //     } else {
  //       showToast(text: response.data["data"]["message"], time: 5);
  //     }
  //   }
  // }

  loginWithEmail(String email, String password) async {
    emit(AccountLoggingIn());

    FormData formData =
        FormData.fromMap({"username": email, "password": password});

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/login_front_end_user/",
      data: formData,
    );

    if (response.statusCode == 200) {
      if (response.data["profile_status"] == "True") {
        User newUser = User.fromJson(response.data);

        Response responseDetail = await DioHttpService().handleGetRequest(
          "booking/api_v_1/profile_get_front_end_user/",
          options:
              Options(headers: {"Authorization": "Token ${newUser.token}"}),
        );

        if (responseDetail.statusCode == 200) {
          await HiveUser.setUser(newUser);
          await HiveUser.setLoggedIn(loggedIn: true);
          UserDetail userDetail = UserDetail.fromJson(responseDetail.data);
          await HiveUser.setUserDetail(userDetail);

          emit(AccountLoggedIn());
        } else {
          showToast(text: "Some error occured! Try Again!!", time: 5);
          emit(AccountLoggedOut());
        }
      } else {
        Get.offAndToNamed("/updateProfile",
            arguments: User.fromJson(response.data));
      }
    } else if (response.statusCode == 400) {
      try {
        showToast(text: response.data['data']['non_field_errors'][0], time: 5);
      } catch (e) {
        showToast(text: "Some error occured! Try Again!!", time: 5);
      }
      emit(AccountLoggedOut());
    } else {
      showToast(text: "Some error occured! Try Again!!", time: 5);
      emit(AccountLoggedOut());
    }
  }

  loginWithGoogle() async {
    emit(AccountLoggingIn());

    final result = await googleLogin();
    if (result["success"]) {
      Response response = await DioHttpService().handlePostRequest(
        "booking/api_v_1/social-login/",
        options: Options(headers: {
          "Authorization": "bearer google-oauth2 ${result["token"]}"
        }),
      );

      printLog.d(response.data);

      if (response.statusCode == 200) {
        if (response.data["profile_status"] == "True") {
          User newUser = User.fromJson(response.data);

          Response responseDetail = await DioHttpService().handleGetRequest(
            "booking/api_v_1/profile_get_front_end_user/",
            options:
                Options(headers: {"Authorization": "Token ${newUser.token}"}),
          );

          if (responseDetail.statusCode == 200) {
            await HiveUser.setUser(newUser);
            await HiveUser.setLoggedIn(loggedIn: true);

            UserDetail userDetail = UserDetail.fromJson(responseDetail.data);
            await HiveUser.setUserDetail(userDetail);

            emit(AccountLoggedIn());
          } else {
            showToast(text: "Some error occured! Try Again!!", time: 5);
            emit(AccountLoggedOut());
          }
        } else {
          Get.offAndToNamed("/updateProfile",
              arguments: User.fromJson(response.data));
        }
      } else {
        showToast(text: "Some error occured! Try Again!!", time: 5);
        emit(AccountLoggedOut());
      }
    } else {
      print(result.toString());
      showToast(text: "Some error occured! Try Again!!", time: 5);
      emit(AccountLoggedOut());
    }
  }

  // loginWithFacebook() async {
  //   emit(AccountLoggingIn());

  //   final result = await facebookLogin();
  //   if (result["success"]) {
  //     Response response = await DioHttpService().handlePostRequest(
  //       "booking/api_v_1/social-login/",
  //       options: Options(
  //           headers: {"Authorization": "bearer facebook ${result["token"]}"}),
  //     );

  //     if (response.statusCode == 200) {
  //       if (response.data["profile_status"] == "True") {
  //         User newUser = User.fromJson(response.data);

  //         Response responseDetail = await DioHttpService().handleGetRequest(
  //           "booking/api_v_1/profile_get_front_end_user/",
  //           options:
  //               Options(headers: {"Authorization": "Token ${newUser.token}"}),
  //         );

  //         if (responseDetail.statusCode == 200) {
  //           await HiveUser.setUser(newUser);
  //           await HiveUser.setLoggedIn(loggedIn: true);

  //           UserDetail userDetail = UserDetail.fromJson(responseDetail.data);
  //           await HiveUser.setUserDetail(userDetail);

  //           emit(AccountLoggedIn());
  //         } else {
  //           showToast(text: "Some error occured! Try Again!!", time: 5);
  //           emit(AccountLoggedOut());
  //         }
  //       } else {
  //         Get.offAndToNamed("/updateProfile",
  //             arguments: User.fromJson(response.data));
  //       }
  //     } else {
  //       showToast(text: "Some error occured! Try Again!!", time: 5);
  //       emit(AccountLoggedOut());
  //     }
  //   } else {
  //     showToast(text: result["token"], time: 5);
  //     emit(AccountLoggedOut());
  //   }
  // }

  logout() async {
    emit(AccountProcessing());
    HiveUser.setUser(User.init());
    HiveUser.setUserDetail(UserDetail.init());
    HiveUser.setLoggedIn(loggedIn: false);
    emit(AccountLoggedOut());
  }

  Future<Map<String, dynamic>> googleLogin() async {
    printLog.log(Level.debug, 'googleLogin');
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final x = await googleSignInAccount!.authentication;
      return {"success": true, "token": x.accessToken};
    } catch (e) {
      return {"success": false, "token": "Login Failed"};
    }
  }

  // Future<Map<String, dynamic>> facebookLogin() async {
  //   final facebookLogin = FacebookLogin();
  //   await facebookLogin.logOut();
  //   final result = await facebookLogin.logIn(permissions: [
  //     FacebookPermission.email,
  //   ]);

  //   // print(result.toString());

  //   switch (result.status) {
  //     case FacebookLoginStatus.success:
  //       return {'success': true, 'token': result.accessToken?.token};
  //     case FacebookLoginStatus.cancel:
  //       return {'success': false, 'token': ' Canceled by user'};
  //     case FacebookLoginStatus.error:
  //       return {'success': false, 'token': result.error};
  //     default:
  //       return {'success': false, 'token': 'Unknown Error'};
  //   }
  // }
}
