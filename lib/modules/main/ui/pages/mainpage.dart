// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_buddy_goo/common/functions/new_citylist/new_citylist.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../common/functions/city_list.dart';
import '../../../../common/functions/country_list.dart';
import '../../../../common/functions/flight_sector.dart';
import '../../../../common/services/get_it.dart';
import '../../../../configs/theme.dart';
import '../../../booking/ui/pages/booking_page.dart';
import '../../../bus/model/bus_booking_detail_parameters.dart';
import '../../../contact_us/ui/contact_us_page.dart';
import '../../../ewallet/ui/pages/ewallet.dart';
import '../../../home/ui/pages/home.dart';
import '../../../hotel/model/hotel_booking_detail_parameters.dart';
import '../../../more/ui/pages/more.dart';
import '../../../rental/model/rental_booking_detail_parameters.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PersistentTabController _tabController =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const BookingPage(),
      const EwalletPage(),
      const MorePage(),
      const ContactUsPage(),
    ];
  }

  Color activeColor = MyTheme.primaryColor;
  Color inactiveColor = MyTheme.secondaryColor2;
  Color activeColorAlternate = Colors.white;

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: "Home",
        iconSize: 20,
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
        activeColorSecondary: activeColorAlternate,
        textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.library_books),
        title: "Bookings",
        iconSize: 20,
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
        activeColorSecondary: activeColorAlternate,
        textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_balance_wallet),
        title: "Redeem",
        iconSize: 20,
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
        activeColorSecondary: activeColorAlternate,
        textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.more_horiz),
        title: "About",
        iconSize: 20,
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
        activeColorSecondary: activeColorAlternate,
        textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.local_phone_outlined),
        title: "Contact Us",
        iconSize: 20,
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
        activeColorSecondary: activeColorAlternate,
        textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
    ];
  }

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    getCityList();
    getNewCityList();
    getCountryList();
    getFlightSectors();

    HotelBookingDetailParameters hotelBookingDetailParameters =
        locator<HotelBookingDetailParameters>();
    hotelBookingDetailParameters.clearAllField();

    RentalBookingDetailParameters rentalBookingDetailParameters =
        locator<RentalBookingDetailParameters>();
    rentalBookingDetailParameters.clearAllField();

    BusBookingDetailParameters busBookingDetailParameters =
        locator<BusBookingDetailParameters>();
    busBookingDetailParameters.clearAllField();

    // if (HiveUser.getLoggedIn()) {
    //   _firebaseMessaging.requestPermission();

    //   _firebaseMessaging.getToken().then((fcmToken) {
    //     updateFcmAndLocation(fcmToken.toString());
    //   });
    //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {});
    //   // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    //   //   return myBackgroundMessageHandler(message.data);
    //   // });

    //   // _firebaseMessaging.configure(
    //   //   onMessage: (Map<String, dynamic> message) async {
    //   //     // printLog.d(message);
    //   //   },
    //   //   onBackgroundMessage: myBackgroundMessageHandler,
    //   // );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _tabController,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      navBarStyle: NavBarStyle.style7,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      screenTransitionAnimation:
          const ScreenTransitionAnimation(animateTabTransition: true),
    );
  }
}
