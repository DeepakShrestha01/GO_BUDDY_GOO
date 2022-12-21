import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo/modules/myaccount/ui/widgets/singleTile.dart';
import 'package:go_buddy_goo/modules/myaccount/ui/widgets/topPartLoggedIn.dart';

import '../../../../common/functions/getInitials.dart';
import '../../../../common/model/country_list.dart';
import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/services/logger.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/account/account_cubit.dart';
import '../../services/hive/hive_user.dart';

class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({super.key});

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  User? user;
  UserDetail? userDetail;

  CountryList? countryList;

  @override
  void initState() {
    super.initState();
    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();
    print(user?.toJson());
    print(userDetail?.toJson());
    print('------ Account page ------');

    countryList = locator<CountryList>();

    // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    // firebaseMessaging.requestPermission();
    // firebaseMessaging.getToken().then((fcmToken) {
    //   updateFcmAndLocation(fcmToken.toString());
    // });

    values = [
      user?.email ?? "NA",
      userDetail?.name ?? "NA",
      userDetail?.contact ?? "NA",
      userDetail?.country ?? "NA",
      userDetail?.address ?? "NA",
      userDetail?.gender ?? "NA",
      userDetail?.dob ?? "NA",
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();
    values = [
      user?.email ?? "NA",
      userDetail?.name ?? "NA",
      userDetail?.contact ?? "NA",
      userDetail?.country ?? "NA",
      userDetail?.address ?? "NA",
      userDetail?.gender ?? "NA",
      userDetail?.dob ?? "NA",
    ];
  }

  showSureDialog(BuildContext context) {
    final AccountCubit accountCubit = BlocProvider.of<AccountCubit>(context);

    showDialog(
      builder: (context) => AlertDialog(
        content: Text(
          "You are about to logout. Are you sure?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.secondaryColor,
            ),
            child: const Text(
              "No",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              printLog.d("logout");
              accountCubit.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.primaryColor,
            ),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      context: context,
      barrierDismissible: false,
    );
  }

  List<IconData> icons = [
    CupertinoIcons.mail_solid,
    CupertinoIcons.person_fill,
    CupertinoIcons.phone_fill,
    Icons.public,
    Icons.place,
    Icons.face,
    Icons.celebration,
  ];

  List<String> headers = [
    "Email",
    "Name",
    "Phone Number",
    "Country",
    "Address",
    "Gender",
    "Date of Birth"
  ];

  List<dynamic>? values;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TopPartLoggedIn(
                    image: userDetail!.image ?? userDetail!.image.toString(),
                    initials: getUserInitials(
                        userDetail!.name.toString(), user!.email.toString()),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.separated(
                      itemCount: headers.length,
                      itemBuilder: (BuildContext context, int i) {
                        return SingleTile(
                          icon: icons[i],
                          header: headers[i],
                          value: values?[i],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return divider();
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              child: GestureDetector(
                onTap: () {
                  showSureDialog(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    color: MyTheme.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.5),
                  child: Center(
                    child: Text(
                      "Log out",
                      style: MyTheme.mainTextTheme.headlineMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
