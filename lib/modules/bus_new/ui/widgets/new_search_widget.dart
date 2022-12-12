import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_buddy_goo_mobile/common/widgets/custom_clip_shodow.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:go_buddy_goo_mobile/modules/home/ui/widgets/customShapeClipper.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/model/city_list.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';

class NewBusSearchBox extends StatefulWidget {
  const NewBusSearchBox({super.key});

  @override
  State<NewBusSearchBox> createState() => _NewBusSearchBoxState();
}

class _NewBusSearchBoxState extends State<NewBusSearchBox> {
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
  void initState() {
    super.initState();
    _keyFromTo = GlobalKey<AnimatorWidgetState>();

    cityList = locator<CityList>();
    departureDate = DateTime.now();
    departureDateS = DateTimeFormatter.formatDate(departureDate!);

    shift ??= shiftList[0];
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
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 5),
                        blurRadius: 5,
                        spreadRadius: 0,
                      ),
                    ],
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
                                          hintText: "Kathmandu",
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return await cityList!
                                            .getPatternNewCities(pattern);
                                      },
                                      itemBuilder:
                                          (context, dynamic suggestion) {
                                        return ListTile(
                                          title: Text(suggestion.value),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (dynamic suggestion) {
                                        fromController.text = suggestion.value;

                                        from = suggestion.value;
                                        // fromId = suggestion.id;

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
                                        autofocus: true,
                                        controller: toController,
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
                                            .getPatternNewCities(pattern);
                                      },
                                      itemBuilder:
                                          (context, dynamic suggestion) {
                                        return ListTile(
                                          title: Text(suggestion.value),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (dynamic suggestion) {
                                        toController.text = suggestion.value;

                                        to = suggestion.value;
                                        // toId = suggestion.id;

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
              ),
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
                  NewBusSearchListParameters parameters =
                      locator<NewBusSearchListParameters>();
                  parameters.from = from;
                  parameters.to = to;
                  parameters.departureDate = departureDate;
                  parameters.shift = shift;
                


                  // BusBookingDetailParameters parameters =
                  //     locator<BusBookingDetailParameters>();
                  // parameters.from = from;
                  // parameters.fromId = fromId;
                  // parameters.to = to;
                  // parameters.toId = toId;
                  // parameters.departureDate = departureDate;
                  // parameters.shift = shift;

                  // Get.toNamed("/busList");
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
