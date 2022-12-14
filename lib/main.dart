import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/configs/keys.dart';
import 'package:go_buddy_goo_mobile/modules/myaccount/services/cubit/login_with_password/login_with_password_cubit.dart';
import 'package:go_buddy_goo_mobile/modules/myaccount/services/cubit/registration/registration_cubit.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'common/pages/not_found.dart';
import 'common/routes/routes.dart';
import 'common/services/get_it.dart';
import 'common/services/hive.dart';
import 'configs/theme.dart';
import 'modules/bus_new/services/cubit/new_bus_search_result/bus_search_list_cubit.dart';
import 'modules/internet_connection/service/internet_check/int_check_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await FlutterDownloader.initialize(debug: kDebugMode);
  // await Firebase.initializeApp();
  // FirebaseCrashlytics.instance.crash();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await setUpHive();

  await setUpLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return BusSearchListCubit()..getNewBusSearchResult();
            },
          ),
          BlocProvider(
            create: (context) {
              return IntCheckCubit()..checkInternet();
            },
          ),
          BlocProvider(
            create: (context) {
              return LoginWithPasswordCubit();
            },
          ),
          BlocProvider(
            create: (context) {
              return RegistrationCubit();
            },
          ),
        ],
        child: KhaltiScope(
          // publicKey: "test_public_key_8e00f9ac707a4719ab12d1d8078d5ef1",
          publicKey: khaltiKey,
          builder: (context, navigatorKey) {
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              title: "Go Buddy Goo",
              getPages: routes,
              initialRoute: "/",
              unknownRoute: GetPage(name: "/404", page: () => PageNotFound()),
              debugShowCheckedModeBanner: false,
              supportedLocales: const [
                Locale('en', 'US'),
                // Locale('ne', 'NP'),
              ],
              localizationsDelegates: const [
                KhaltiLocalizations.delegate,
              ],
              theme: MyTheme.themeData,
              // defaultTransition: Transition.cupertino,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              home: const MainApp(),
            );
          },
        ));
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  PackageInfo? packageInfo;

  void getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPackageInfo();

    Future.delayed(const Duration(seconds: 4), () {
      Get.offNamedUntil("/main", (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                "assets/images/logo_gif.gif",
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
              const Spacer(),
              packageInfo == null
                  ? const SizedBox()
                  : Text(
                      "V ${packageInfo?.version}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
