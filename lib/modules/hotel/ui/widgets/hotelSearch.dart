import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_animator/widgets/animator_widget.dart';
import 'package:flutter_animator/widgets/attention_seekers/shake.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/model/city_list.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/services/location_service.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/custom_clip_shodow.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../home/ui/widgets/customShapeClipper.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import '../../model/keyword_search_result.dart';
import '../../model/range.dart';
import '../../model/value_notifier.dart';
import '../../services/cubit/keyword_search/keyword_search_cubit.dart';

// import 'dart:math' show pi;

class HotelSearch extends StatefulWidget {
  const HotelSearch({super.key});

  @override
  _HotelSearchState createState() => _HotelSearchState();
}

class _HotelSearchState extends State<HotelSearch> {
  TextEditingController? destinationTextController;

  ValueNotifier adults = ValueNotifier(0);
  ValueNotifier children = ValueNotifier(0);
  ValueNotifier room = ValueNotifier(0);

  GlobalKey<AnimatorWidgetState>? _cityKey;
  GlobalKey<AnimatorWidgetState>? _guestsCountKey;
  GlobalKey<AnimatorWidgetState>? _dateKey;

  String checkInDate = "Select Date";
  String checkOutDate = "Select Date";

  DateTime? checkInDated;
  DateTime? checkOutDated;

  CityList? cityList;

  KeywordSearchCubit? keywordSearchCubit;

  KeywordSearchResult? selectedKeyword;

  HotelBookingDetailParameters? parameters;
  DateTime? date;
  TimeOfDay? time;
  DateTime? mydateTime;

  String? shift;

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );
  List<String> shiftList = ["Hourly", " Daily"];

  showShiftMenu(BuildContext context, Offset offset) async {
    return showMenu(
      context: context,
      items: List<PopupMenuEntry>.generate(shiftList.length, (i) {
        return PopupMenuItem(
          value: i,
          child: Text(shiftList[i].titleCase),
        );
      }),
      position: RelativeRect.fromLTRB(
        75,
        offset.dy,
        MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width,
      ),
    );
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 28)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(primary: MyTheme.primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            highlightColor: MyTheme.primaryColor,
            textTheme: MyTheme.mainTextTheme,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.grey,
              selectionColor: MyTheme.primaryColor,
            ),
          ),
          child: child as Widget,
        );
      },
    );
    if (newDate == null) return null;
    setState(() {
      date = newDate;
    });
    return date;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(primary: MyTheme.primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            highlightColor: MyTheme.primaryColor,
            textTheme: MyTheme.mainTextTheme,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.grey,
              selectionColor: MyTheme.primaryColor,
            ),
          ),
          child: child as Widget,
        );
      },
    );
    if (newTime == null) return null;
    setState(() {
      time = newTime;
    });
    return time;
  }

  Future pickDateTime(BuildContext context) async {
    var mydate = await pickDate(context);
    if (mydate == null) return;
    final mytime = await pickTime(context);
    if (mytime == null) return;
    setState(() {
      mydateTime = DateTime(
        mydate.year,
        mydate.month,
        mydate.day,
        mytime.hour,
        mytime.minute,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    shift ??= shiftList[0];
    destinationTextController = TextEditingController();
    destinationTextController?.text =
        searchHotelString.value == "Search" ? "" : searchHotelString.value;
    _cityKey = GlobalKey<AnimatorWidgetState>();
    _guestsCountKey = GlobalKey<AnimatorWidgetState>();
    _dateKey = GlobalKey<AnimatorWidgetState>();

    cityList = locator<CityList>();
    parameters = locator<HotelBookingDetailParameters>();

    //Default values for checkin and checkout date
    checkInDated = DateTime.now();
    checkInDate = DateTimeFormatter.formatDate(checkInDated!);
    checkOutDated = checkInDated?.add(const Duration(days: 1));
    checkOutDate = DateTimeFormatter.formatDate(checkOutDated!);

    //default value for guests
    adults.value++;
    room.value++;

    keywordSearchCubit = BlocProvider.of<KeywordSearchCubit>(context);
  }

  showGuestCounterDialog() {
    showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Adults"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          adults.value++;
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(adults.value.toString()),
                            ),
                          );
                        },
                        valueListenable: adults,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (adults.value > 1) {
                            adults.value--;
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Children"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          children.value++;
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(children.value.toString()),
                            ),
                          );
                        },
                        valueListenable: children,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (children.value > 0) {
                            children.value--;
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Rooms"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          room.value++;
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(room.value.toString()),
                            ),
                          );
                        },
                        valueListenable: room,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (room.value > 1) {
                            room.value--;
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      context: context,
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
      color: Colors.grey[50],
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        children: [
          ClipShadow(
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
            clipper: CustomShapeClipper(),
            child: Container(
              width: mediaQuery.size.width,
              decoration: const BoxDecoration(
                  color: MyTheme.primaryDimColor2,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 5),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ]),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Shake(
                    key: _cityKey,
                    preferences: const AnimationPreferences(
                        autoPlay: AnimationPlayStates.None),
                    child: Row(
                      children: [
                        const PNGIconWidget(
                          asset: "assets/images/address.png",
                          color: MyTheme.primaryColor,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Destination",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  autofocus: false,
                                  controller: destinationTextController,
                                  onTap: () {
                                    selectedKeyword = null;
                                    parameters?.latLng = null;
                                  },
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  cursorColor: MyTheme.primaryColor,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search city, hotel",
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return keywordSearchCubit!
                                      .getSearchKeyword(pattern);
                                },
                                itemBuilder: (context, suggestion) {
                                  return SuggestionBuilder(
                                      keywordSearchResult: suggestion);
                                },
                                onSuggestionSelected: (suggestion) {
                                  selectedKeyword = suggestion;

                                  destinationTextController?.text =
                                      selectedKeyword!.name.toString();

                                  setState(() {});
                                },
                                noItemsFoundBuilder: (context) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            MyTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder: (context) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            MyTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 3),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            await setUserLocation();
                            destinationTextController?.clear();
                            selectedKeyword = null;
                            Get.toNamed("/selectOnMap")?.whenComplete(() {
                              destinationTextController?.text =
                                  parameters!.query!;
                            });
                          },
                          child: Image.asset(
                            "assets/images/location.png",
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 3,
                    thickness: 1,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (TapDownDetails details) async {
                      int selectedGenderIndex =
                          await showShiftMenu(context, details.globalPosition);
                      shift = shiftList[selectedGenderIndex];
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.clock,
                          color: MyTheme.primaryColor,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Hourly/Daily",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              shift.toString().titleCase,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 3,
                    thickness: 1,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => pickDateTime(context),
                    child: Row(
                      children: [
                        const PNGIconWidget(
                          asset: "assets/images/calendar.png",
                          color: MyTheme.primaryColor,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Check-Date-Time",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              mydateTime != null
                                  ? DateTimeFormatter.formatDateTime(
                                      mydateTime!)
                                  : 'Chose Date and Time',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 3,
                    thickness: 1,
                  ),
                  const SizedBox(height: 30),
                  Shake(
                    key: _dateKey,
                    preferences: const AnimationPreferences(
                        autoPlay: AnimationPlayStates.None),
                    child: Row(
                      children: [
                        const PNGIconWidget(
                          asset: "assets/images/calendar.png",
                          color: MyTheme.primaryColor,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              brightness: Brightness.light,
                              colorScheme: ColorScheme.fromSwatch()
                                  .copyWith(secondary: MyTheme.primaryColor),
                            ),
                            child: Builder(
                              builder: (context) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    DateTime currentDateTime = DateTime.now();
                                    showCustomDateRangePicker(
                                      context,
                                      dismissible: true,
                                      minimumDate: currentDateTime
                                          .subtract(const Duration(days: 1)),
                                      maximumDate: currentDateTime
                                          .add(const Duration(days: 365 * 2)),
                                      startDate: checkInDated,
                                      endDate: checkOutDated,
                                      onApplyClick: ((startDate, endDate) {
                                        setState(() {
                                          checkInDated = startDate;
                                          checkOutDated = endDate;
                                        });
                                      }),
                                      onCancelClick: () {
                                        setState(() {
                                          checkInDated = null;
                                          checkOutDated = null;
                                          showToast(text: "Select proper date");
                                        });
                                      },
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Check-In",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                checkInDated != null
                                                    ? DateFormat("dd, MMM, y")
                                                        .format(checkInDated!)
                                                    : checkInDate,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Check-Out",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                checkOutDated != null
                                                    ? DateFormat("dd, MMM, y")
                                                        .format(checkOutDated!)
                                                    : checkOutDate,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 3,
                    thickness: 1,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.person_2,
                        color: MyTheme.primaryColor,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            showGuestCounterDialog();
                          },
                          child: Shake(
                            key: _guestsCountKey,
                            preferences: const AnimationPreferences(
                                autoPlay: AnimationPlayStates.None),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Guests & No. of Rooms",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    ValueListenableBuilder(
                                      builder: (BuildContext context, value,
                                          Widget? child) {
                                        return Text(
                                          "${adults.value} Adults,",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        );
                                      },
                                      valueListenable: adults,
                                    ),
                                    ValueListenableBuilder(
                                      builder: (BuildContext context, value,
                                          Widget? child) {
                                        return Text(
                                          " ${children.value} Children",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        );
                                      },
                                      valueListenable: children,
                                    ),
                                    const Text("   ||   "),
                                    ValueListenableBuilder(
                                      builder: (BuildContext context, value,
                                          Widget? child) {
                                        return Text(
                                          "${room.value} Rooms",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        );
                                      },
                                      valueListenable: room,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 3,
                    thickness: 1,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (destinationTextController!.text.isEmpty) {
                  _cityKey?.currentState?.forward();
                } else if (adults.value == 0) {
                  _guestsCountKey?.currentState?.forward();
                } else if (checkOutDated == null ||
                    checkInDated!.isAfter(checkOutDated!)) {
                  _dateKey?.currentState?.forward();
                } else {
                  parameters?.query = destinationTextController?.text;
                  parameters?.maxAdults = adults.value;
                  parameters?.maxChildren = children.value;
                  parameters?.dateRange = Range(
                    // start: checkInDated,
                    start: DateTimeFormatter.formatDate(checkInDated!),
                    end: DateTimeFormatter.formatDate(checkOutDated!),
                  );
                  parameters?.noOfRooms = room.value;
                  parameters?.isSearch = true;
                  parameters?.selectedKeyword = selectedKeyword;
                  parameters?.bookingHour = shift?.toLowerCase();
                  Get.toNamed("/hotelList");
                }
              },
              child: Container(
                height: 50,
                width: mediaQuery.size.width * 0.4,
                decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.circular(17.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    PNGIconWidget(
                      asset: "assets/images/search.png",
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Search",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestionBuilder extends StatelessWidget {
  final KeywordSearchResult? keywordSearchResult;

  const SuggestionBuilder({Key? key, this.keywordSearchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;

    if (keywordSearchResult?.type == KeywordSearchType.CITY) {
      leadingWidget = const PNGIconWidget(
        asset: "assets/images/address.png",
        color: MyTheme.primaryColor,
      );
    } else if (keywordSearchResult?.type == KeywordSearchType.HOTEL) {
      leadingWidget = const PNGIconWidget(
        asset: "assets/images/hotel.png",
        color: MyTheme.primaryColor,
      );
    } else if (keywordSearchResult?.type == KeywordSearchType.LANDMARK) {
      leadingWidget = const PNGIconWidget(
        asset: "assets/images/landmark.png",
        color: MyTheme.primaryColor,
      );
    }

    return ListTile(
      leading: leadingWidget,
      title: Text(keywordSearchResult!.name.toString()),
    );
  }
}
