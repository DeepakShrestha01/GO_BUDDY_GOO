import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../../modules/myaccount/services/hive/hive_user.dart';
import '../model/user.dart';
import '../model/user_detail.dart';



Future<void> setUpHive() async {
  var dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserDetailAdapter());

  await Hive.openBox(HiveUser.hbUser);
  await Hive.openBox(HiveUser.hbLogin);
  await Hive.openBox(HiveUser.hbUserDetail);
}
