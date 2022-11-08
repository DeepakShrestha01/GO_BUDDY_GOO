import 'package:hive/hive.dart';

import '../../../../../common/model/user.dart';
import '../../../../../common/model/user_detail.dart';

class HiveUser {
  static String hbUser = "user";
  static String hsUserObj = "userObj";

  static String hbUserDetail = "userDetail";
  static String hsUserDetailObj = "userDetailObj";

  static String hbLogin = "login";
  static String hsSeenWalkThrough = "seenWalkThrough";
  static String hsLoggedIn = "loggedIn";

  static Future<void> setLoggedIn({required bool loggedIn}) async {
    var hbLoginBox = Hive.box(hbLogin);
    await hbLoginBox.put(hsLoggedIn, loggedIn);
  }

  static void setWalkThrough({required bool walkThrough}) {
    var hbLoginBox = Hive.box(hbLogin);
    hbLoginBox.put(hsSeenWalkThrough, walkThrough);
  }

  static bool getLoggedIn() {
    var hbLoginBox = Hive.box(hbLogin);
    return hbLoginBox.get(hsLoggedIn) ?? false;
  }

  static bool getWalkThrough() {
    var hbLoginBox = Hive.box(hbLogin);
    return hbLoginBox.get(hsSeenWalkThrough) ?? false;
  }

  static Future<void> setUser(User user) async {
    var hbUserBox = Hive.box(hbUser);
    await hbUserBox.put(hsUserObj, user);
  }

  static User getUser() {
    var hbUserBox = Hive.box(hbUser);
    User user = hbUserBox.get(hsUserObj) ?? User.init();
    return user;
  }

  static Future<void> setUserDetail(UserDetail userDetail) async {
    var hbUserDetailBox = Hive.box(hbUserDetail);
    await hbUserDetailBox.put(hsUserDetailObj, userDetail);
  }

  static UserDetail getUserDetail() {
    var hbUserDetailBox = Hive.box(hbUserDetail);
    UserDetail userDetail =
        hbUserDetailBox.get(hsUserDetailObj) ?? UserDetail.init();
    return userDetail;
  }
}
