// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:go_buddy_goo_mobile/modules/main/services/firebase_messaging.dart';

// Future<void> backgroundHandler(RemoteMessage message) async {
//   return myBackgroundMessageHandler(message.data);
// }

// class NotificationServices {
//   static Future<void> initilize() async {
//     NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission();
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       FirebaseMessaging.onBackgroundMessage(backgroundHandler);
//       FirebaseMessaging.onMessage.listen((event) {
//         log('message received : ${event.notification!.title}');
//       });
//     }
//   }
// }
