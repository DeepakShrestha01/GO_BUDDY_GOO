import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/route_manager.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/airline_list.dart';
import '../../../../common/functions/format_date.dart';
import '../../../../common/model/country.dart';
import '../../../../common/model/flight_sector.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/flight/flight_cubit.dart';

class FlightMainPage extends StatelessWidget {
  const FlightMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FlightCubit(),
      child: const FlightBody(),
    );
  }
}

class FlightBody extends StatefulWidget {
  const FlightBody({super.key});

  @override
  _FlightBodyState createState() => _FlightBodyState();
}

class _FlightBodyState extends State<FlightBody> {
  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();
  final nationalityTextController = TextEditingController();

  ValueNotifier adults = ValueNotifier(1);
  ValueNotifier children = ValueNotifier(0);
  ValueNotifier infants = ValueNotifier(0);

  GlobalKey<AnimatorWidgetState>? _fromKey;
  GlobalKey<AnimatorWidgetState>? _toKey;
  GlobalKey<AnimatorWidgetState>? _nationalityKey;

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  DateTime? departureDate;
  String? departureDateS;

  DateTime? returnDate;
  String? returnDateS;

  selectDepartureDate(BuildContext context) async {
    DateTime currentDateTime = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: currentDateTime,
      initialDate: departureDate ?? currentDateTime,
      lastDate: currentDateTime.add(const Duration(days: 365 * 5)),
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
          child: child!,
        );
      },
    );

    departureDate = selectedDate;
    departureDateS = DateTimeFormatter.formatDate(departureDate!);

    setState(() {});
  }

  selectReturnDate(BuildContext context) async {
    DateTime currentDateTime = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: currentDateTime,
      initialDate: departureDate ?? currentDateTime,
      lastDate: currentDateTime.add(const Duration(days: 365 * 5)),
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
          child: child!,
        );
      },
    );

    returnDate = selectedDate;
    returnDateS = DateTimeFormatter.formatDate(returnDate!);

    setState(() {});
  }

  String tripType = "one-way";

  @override
  void initState() {
    super.initState();
    getAirlineList();
    _fromKey = GlobalKey<AnimatorWidgetState>();
    _toKey = GlobalKey<AnimatorWidgetState>();
    _nationalityKey = GlobalKey<AnimatorWidgetState>();

    departureDate = DateTime.now();
    departureDateS = DateTimeFormatter.formatDate(departureDate!);

    returnDate = DateTime.now();
    returnDateS = DateTimeFormatter.formatDate(returnDate!);
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
                          if (adults.value < 7) {
                            adults.value++;
                          }
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
    final cubit = BlocProvider.of<FlightCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Search Flights",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              Shake(
                key: _fromKey,
                preferences: const AnimationPreferences(
                    autoPlay: AnimationPlayStates.None),
                child: Row(
                  children: [
                    const PNGIconWidget(
                      asset: "assets/images/flight.png",
                      color: MyTheme.primaryColor,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: fromTextController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              cursorColor: MyTheme.primaryColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search city",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return cubit.filterSector(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return SuggestionBuilder(sector: suggestion);
                            },
                            onSuggestionSelected: (suggestion) {
                              fromTextController.text =
                                  "${suggestion.sectorName.toString().titleCase} (${suggestion.sectorCode})";
                              cubit.setFromSector(suggestion);

                              setState(() {});
                            },
                            noItemsFoundBuilder: (context) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Text("No items found. Try something else."),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        MyTheme.primaryColor,
                                      ),
                                    ),
                                  ),
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
              const Divider(
                color: Colors.grey,
                height: 3,
                thickness: 1,
              ),
              const SizedBox(height: 30.0),
              Shake(
                key: _toKey,
                preferences: const AnimationPreferences(
                    autoPlay: AnimationPlayStates.None),
                child: Row(
                  children: [
                    Transform.rotate(
                      angle: 1.5708,
                      child: const PNGIconWidget(
                        asset: "assets/images/flight.png",
                        color: MyTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "To",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: toTextController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              cursorColor: MyTheme.primaryColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search city",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return cubit.filterSector(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return SuggestionBuilder(sector: suggestion);
                            },
                            onSuggestionSelected: (suggestion) {
                              toTextController.text =
                                  "${suggestion.sectorName.toString().titleCase} (${suggestion.sectorCode})";
                              cubit.setToSector(suggestion);

                              setState(() {});
                            },
                            noItemsFoundBuilder: (context) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Text("No items found. Try something else."),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        MyTheme.primaryColor,
                                      ),
                                    ),
                                  ),
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
              const Divider(
                color: Colors.grey,
                height: 3,
                thickness: 1,
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  const PNGIconWidget(
                    asset: "assets/images/trip.png",
                    color: MyTheme.primaryColor,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trip",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: "one-way",
                                  groupValue: tripType,
                                  visualDensity: const VisualDensity(
                                    horizontal: 0,
                                    vertical: -4,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: MyTheme.primaryColor,
                                  onChanged: (x) {
                                    tripType = x!;
                                    setState(() {});
                                  },
                                ),
                                const Text("One-way"),
                              ],
                            ),
                            const SizedBox(width: 30.0),
                            Row(
                              children: [
                                Radio(
                                  value: "return",
                                  groupValue: tripType,
                                  activeColor: MyTheme.primaryColor,
                                  visualDensity: const VisualDensity(
                                    horizontal: 0,
                                    vertical: -4,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (x) {
                                    tripType = x!;
                                    setState(() {});
                                  },
                                ),
                                const Text("Return"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.grey,
                height: 3,
                thickness: 1,
              ),
              const SizedBox(height: 30.0),
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,

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
                    selectDepartureDate(context);
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
              const Divider(
                color: Colors.grey,
                height: 3,
                thickness: 1,
              ),
              const SizedBox(height: 30.0),
              if (tripType == "return")
                Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,

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
                          selectReturnDate(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Return Date",
                              style: headerTextStyle,
                            ),
                            Text(
                              returnDateS.toString(),
                              style: valueTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 3,
                      thickness: 1,
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Travellers",
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
                            ],
                          ),
                          const SizedBox(height: 3),
                        ],
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
              const SizedBox(height: 30.0),
              Shake(
                key: _nationalityKey,
                preferences: const AnimationPreferences(
                    autoPlay: AnimationPlayStates.None),
                child: Row(
                  children: [
                    const PNGIconWidget(
                      asset: "assets/images/country.png",
                      color: MyTheme.primaryColor,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nationality",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TypeAheadField(
                            autoFlipDirection: true,
                            textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: nationalityTextController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              cursorColor: MyTheme.primaryColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search country",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return cubit.filterCountry(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return CountrySuggestionBuilder(
                                country: suggestion,
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              nationalityTextController.text =
                                  "${suggestion.name} (${suggestion.countryCode})";
                              cubit.setNationality(suggestion);

                              setState(() {});
                            },
                            noItemsFoundBuilder: (context) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Text("No items found. Try something else."),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        MyTheme.primaryColor,
                                      ),
                                    ),
                                  ),
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
              const Divider(
                color: Colors.grey,
                height: 3,
                thickness: 1,
              ),
              const SizedBox(height: 40.0),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (cubit.fromSector == null) {
                    _fromKey?.currentState?.forward();
                  } else if (cubit.toSector == null) {
                    _toKey?.currentState?.forward();
                  } else if (cubit.selectedNationality == null) {
                    _nationalityKey?.currentState?.forward();
                  } else {
                    cubit.searchFlight(
                      tripType: tripType == "return" ? "R" : "O",
                      departureDate: departureDate!,
                      returnDate: tripType== "return" ? returnDate : null  ,
                      adults: adults.value,
                      children: children.value,
                      infants: infants.value,
                    );
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SuggestionBuilder extends StatelessWidget {
  final FlightSector? sector;

  const SuggestionBuilder({Key? key, this.sector}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(sector!.sectorCode.toString()),
      title: Text(sector!.sectorName!.titleCase),
    );
  }
}

class CountrySuggestionBuilder extends StatelessWidget {
  final Country? country;

  const CountrySuggestionBuilder({Key? key, this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(country!.countryCode!.toUpperCase()),
      title: Text(country!.name.toString()),
    );
  }
}
