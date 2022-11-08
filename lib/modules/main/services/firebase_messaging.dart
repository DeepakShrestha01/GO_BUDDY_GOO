// import 'dart:io' show Platform;

// import 'package:dio/dio.dart';

// import '../../../common/model/user.dart';
// import '../../../common/model/user_location.dart';
// import '../../../common/services/dio_http_service.dart';
// import '../../../common/services/get_it.dart';
// import '../../../common/services/logger.dart';
// import '../../myaccount/services/hive/hive_user.dart';

// updateFcmAndLocation(String fcmToken) async {
//   User user = HiveUser.getUser();
//   UserLocation userLocation = locator<UserLocation>();

//   FormData formData = FormData.fromMap({
//     "registration_id": fcmToken,
//     "device_id": "",
//   });

//   formData.fields.add(MapEntry("latitude", userLocation.latitude.toString()));
//   formData.fields.add(MapEntry("longitude", userLocation.longitude.toString()));

//   if (Platform.isAndroid) {
//     formData.fields.add(const MapEntry("device_type", "android"));
//   } else if (Platform.isIOS) {
//     formData.fields.add(const MapEntry("device_type", "ios"));
//   } else {
//     formData.fields.add(const MapEntry("device_type", "none"));
//   }

//   await DioHttpService().handlePostRequest(
//     "booking/api_v_1/front_end_user_update_notification_zone/",
//     data: formData,
//     options: Options(headers: {"Authorization": "Token ${user.token}"}),
//   );

//   // if (response.statusCode != 200) {
//   //   showToast(
//   //       text: "Error setting up notifications. Restart the app!", time: 5);
//   // }
// }

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   printLog.d(message);
//   if (message.containsKey('data')) {
//     // Handle data message
//     final dynamic data = message['data'];
//     return data as Future<dynamic>;
//   } else if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//     return notification as Future<dynamic>;
//   } else {
//     return message as Future<dynamic>;
//   }

//   // Or do other work.
// }
