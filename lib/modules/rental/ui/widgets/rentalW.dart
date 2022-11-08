import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/route_manager.dart';

import '../../../../common/model/city_list.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../model/rental_booking_detail_parameters.dart';
import '../../model/rental_item.dart';
import '../../services/cubit/rental/rental_cubit.dart';

class RentalW extends StatefulWidget {
  final RentalCubit? rentalCubit;

  const RentalW({Key? key, this.rentalCubit}) : super(key: key);

  @override
  _RentalWState createState() => _RentalWState();
}

class _RentalWState extends State<RentalW> {
  GlobalKey<AnimatorWidgetState>? _vehicleTypeKey;
  GlobalKey<AnimatorWidgetState>? _locationKey;

  TextEditingController? _pickupLocationController;

  @override
  void initState() {
    _vehicleTypeKey = GlobalKey<AnimatorWidgetState>();
    _locationKey = GlobalKey<AnimatorWidgetState>();

    _pickupLocationController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RentalItem> rentalItems = widget.rentalCubit!.rentalItems;

    RentalBookingDetailParameters parameters =
        locator<RentalBookingDetailParameters>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 5, top: 5),
              child: Text(
                "Choose your vehicle",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Shake(
              key: _vehicleTypeKey,
              preferences: const AnimationPreferences(
                  autoPlay: AnimationPlayStates.None),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10.0),
                decoration: const ShapeDecoration(
                  color: MyTheme.accentTextColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: MyTheme.primaryDimColor),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                child: DropdownButton<RentalItem>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  value: parameters.rentalItemId == null
                      ? null
                      : rentalItems
                          .firstWhere((e) => e.id == parameters.rentalItemId),
                  hint: const Text("Select"),
                  items: List<DropdownMenuItem<RentalItem>>.generate(
                      rentalItems.length,
                      (i) => DropdownMenuItem(
                            value: rentalItems[i],
                            onTap: () {
                              parameters.rentalItemId = rentalItems[i].id;
                              parameters.rentalItem = rentalItems[i].name;
                              setState(() {});
                            },
                            child: Text(rentalItems[i].name.toString()),
                          )),
                  onChanged: (x) {
                    parameters.rentalItemId = x?.id;
                    parameters.rentalItem = x?.name;
                    setState(() {});
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15, top: 30),
              child: Text(
                "Choose pickup location",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Shake(
              key: _locationKey,
              preferences: const AnimationPreferences(
                  autoPlay: AnimationPlayStates.None),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.location_solid,
                        color: MyTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TypeAheadField(
                          autoFlipDirection: true,
                          textFieldConfiguration: TextFieldConfiguration(
                            autofocus: false,
                            controller: _pickupLocationController,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            cursorColor: MyTheme.primaryColor,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search location",
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            CityList cityList = locator<CityList>();

                            return cityList.getPatternCities(pattern);
                          },
                          itemBuilder: (context, dynamic suggestion) {
                            return ListTile(
                              title: Text(suggestion.name), // goit
                              leading: const Icon(
                                CupertinoIcons.location_solid,
                                color: MyTheme.primaryColor,
                                size: 20,
                              ),
                            );
                          },
                          onSuggestionSelected: (dynamic suggestion) {
                            _pickupLocationController?.text =
                                suggestion.name; //go it
                            parameters.cityId = suggestion.id;
                            parameters.city = suggestion.name; //go it
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
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    height: 35,
                    thickness: 1,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10.0),

            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (parameters.rentalItemId == null ||
                      parameters.rentalItem == null) {
                    _vehicleTypeKey?.currentState?.forward();
                  } else if (parameters.cityId == null ||
                      parameters.city == null) {
                    _locationKey?.currentState?.forward();
                  } else {
                    Get.toNamed("/vehicleList", arguments: parameters.city);
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

            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   alignment: Alignment.center,
            //   child: Wrap(
            //     direction: Axis.horizontal,
            //     spacing: 15,
            //     runSpacing: 15,
            //     runAlignment: WrapAlignment.start,
            //     children: List<Widget>.generate(
            //       rentalItems.length,
            //       (i) => RentalOption(rentalItem: rentalItems[i]),
            //     ),
            //   ),
            // ),
            Divider(
              color: Colors.grey.shade300,
              height: 35,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
