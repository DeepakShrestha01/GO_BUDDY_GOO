import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_animator/widgets/animator_widget.dart';
import 'package:flutter_animator/widgets/attention_seekers/shake.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/route_manager.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/model/city_list.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/custom_clip_shodow.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../home/ui/widgets/customShapeClipper.dart';
import '../../model/bus_booking_detail_parameters.dart';
// import 'dart:math' show pi;

class BusSearchBox extends StatefulWidget {
  const BusSearchBox({super.key});

  @override
  _BusSearchBoxState createState() => _BusSearchBoxState();
}

class _BusSearchBoxState extends State<BusSearchBox> {
  GlobalKey<AnimatorWidgetState>? _keyFromTo;

  DateTime? departureDate;
  String? departureDateS;

  String? from, to;

  int? fromId, toId;

  CityList? cityList;

  final fromController = TextEditingController();
  final toController = TextEditingController();

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  Widget divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 15,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }

  String? shift;

  List<String> shiftList = ["all", "day", "night"];

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

  @override
  void initState() {
    super.initState();

    _keyFromTo = GlobalKey<AnimatorWidgetState>();

    cityList = locator<CityList>();

    departureDate = DateTime.now();
    departureDateS = DateTimeFormatter.formatDate(departureDate!);

    shift ??= shiftList[0];
  }

  selectDate(BuildContext context) async {
    DateTime currentDateTime = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: currentDateTime,
      initialDate: departureDate ?? currentDateTime,
      lastDate: currentDateTime.add(const Duration(days: 28)),
      builder: (BuildContext context, Widget? child) {
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

    departureDate = selectedDate;
    departureDateS = DateTimeFormatter.formatDate(departureDate!);

    setState(() {});
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
          Column(
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
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 5),
                        blurRadius: 5,
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black,
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Shake(
                        key: _keyFromTo,
                        preferences: const AnimationPreferences(
                            autoPlay: AnimationPlayStates.None),
                        child: ListTile(
                          leading: const PNGIconWidget(
                            asset: "assets/images/address.png",
                            color: MyTheme.primaryColor,
                          ),
                          title: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "From",
                                      style: headerTextStyle,
                                    ),
                                    TypeAheadField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        autofocus: true,
                                        controller: fromController,
                                        style: valueTextStyle,
                                        cursorColor: MyTheme.primaryColor,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Pokhara",
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return await cityList!
                                            .getPatternCities(pattern);
                                      },
                                      itemBuilder:
                                          (context, dynamic suggestion) {
                                        return ListTile(
                                          title: Text(suggestion.name),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (dynamic suggestion) {
                                        fromController.text = suggestion.name;

                                        from = suggestion.name;
                                        fromId = suggestion.id;

                                        setState(() {});
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "No cities found",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "To",
                                      style: headerTextStyle,
                                    ),
                                    TypeAheadField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        autofocus: false,
                                        controller: toController,
                                        style: valueTextStyle,
                                        cursorColor: MyTheme.primaryColor,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Dharan",
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return cityList!
                                            .getPatternCities(pattern);
                                      },
                                      itemBuilder:
                                          (context, dynamic suggestion) {
                                        return ListTile(
                                          title: Text(suggestion.name),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (dynamic suggestion) {
                                        toController.text = suggestion.name;

                                        to = suggestion.name;
                                        toId = suggestion.id;

                                        setState(() {});
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "No cities found",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      divider(),
                      ListTile(
                        leading: const PNGIconWidget(
                          asset: "assets/images/calendar.png",
                          color: MyTheme.primaryColor,
                        ),

                        // Icon(
                        //   CupertinoIcons.calendar,
                        //   color: MyTheme.primaryColor,
                        // ),
                        title: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            selectDate(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Departure Date",
                                style: headerTextStyle,
                              ),
                              Text(
                                departureDateS.toString(),
                                style: valueTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      divider(),
                      ListTile(
                        leading: const Icon(
                          CupertinoIcons.clock,
                          color: MyTheme.primaryColor,
                        ),
                        title: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (TapDownDetails details) async {
                            int selectedGenderIndex = await showShiftMenu(
                                context, details.globalPosition);
                            shift = shiftList[selectedGenderIndex];
                            setState(() {});
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Shift",
                                style: headerTextStyle,
                              ),
                              Text(
                                shift!.titleCase,
                                style: valueTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      divider(),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 10,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (to == null) {
                  _keyFromTo?.currentState?.forward();
                } else {
                  BusBookingDetailParameters parameters =
                      locator<BusBookingDetailParameters>();
                  parameters.from = from;
                  parameters.fromId = fromId;
                  parameters.to = to;
                  parameters.toId = toId;
                  parameters.departureDate = departureDate;
                  parameters.shift = shift;

                  Get.toNamed("/busList");
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
                    // Icon(Icons.search),
                    PNGIconWidget(
                      asset: "assets/images/search.png",
                      // color: MyTheme.primaryColor,
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
