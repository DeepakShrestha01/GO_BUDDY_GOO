import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel_filter.dart';
import '../../services/cubit/hotel_search_result/hotel_search_result_cubit.dart';
import 'filterCard.dart';

class FilterHotel extends StatefulWidget {
  final HotelSearchResultCubit? hotelSearchResultCubit;

  const FilterHotel(this.hotelSearchResultCubit);

  @override
  _FilterHotelState createState() => _FilterHotelState();
}

class _FilterHotelState extends State<FilterHotel> {
  HotelFilter? filter;
  HotelFilter? originalFilter;

  HotelSearchResultCubit? cubit;

  bool? expandHotelFacilities;
  bool? expandInventoriesFacilities;
  bool? expandInventoriesAmenities;
  bool? expandInventoriesFeatures;
  bool? expandHotelLandmark;
  bool? expandInventoryMeal;

  List<Widget>? hotelFacilitiesWidgets;
  List<Widget>? inventoriesFacilitiesWidgets;
  List<Widget>? inventoriesAmenitiesWidgets;
  List<Widget>? inventoriesFeaturesWidgets;
  List<Widget>? hotelLandmarkWidgets;
  List<Widget>? inventoryMealWidgets;

  TextStyle? subTitleTextStyle, titleTextStyle;

  @override
  void initState() {
    super.initState();
    subTitleTextStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
    titleTextStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

    filter = widget.hotelSearchResultCubit?.filter;

    // print(Get.arguments.filter);

    originalFilter = widget.hotelSearchResultCubit?.originalFilter;
    cubit = widget.hotelSearchResultCubit;

    setBooleans();
  }

  setBooleans() {
    expandHotelFacilities = filter!.hotelFacilities!.length > 5;
    expandInventoriesFacilities = filter!.inventoriesFacilities!.length > 5;
    expandInventoriesAmenities = filter!.inventoriesAmenities!.length > 5;
    expandInventoriesFeatures = filter!.inventoriesFeatures!.length > 5;
    expandHotelLandmark = filter!.hotelLandmark!.length > 5;
    expandInventoryMeal = filter!.inventoryMeal!.length > 5;
  }

  buildHotelFacilitiesWidgets() {
    hotelFacilitiesWidgets = List<Widget>.generate(
      filter!.hotelFacilities!.length,
      (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                filter!.hotelFacilities![i].name.toString(),
                style: subTitleTextStyle,
              ),
            ),
            Checkbox(
              onChanged: (bool? value) {
                filter?.hotelFacilities?[i].checked = value;

                setState(() {});
              },
              value: filter?.hotelFacilities?[i].checked,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: MyTheme.primaryColor,
            )
          ],
        );
      },
    );
  }

  buildInventoriesFacilitiesWidgets() {
    inventoriesFacilitiesWidgets = List<Widget>.generate(
      filter!.inventoriesFacilities!.length,
      (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                filter!.inventoriesFacilities![i].name.toString(),
                style: subTitleTextStyle,
              ),
            ),
            Checkbox(
              onChanged: (bool? value) {
                filter?.inventoriesFacilities?[i].checked = value;

                setState(() {});
              },
              value: filter?.inventoriesFacilities?[i].checked,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: MyTheme.primaryColor,
            )
          ],
        );
      },
    );
  }

  buildInventoriesAmenitiesWidgets() {
    inventoriesAmenitiesWidgets =
        List<Widget>.generate(filter!.inventoriesAmenities!.length, (i) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              filter!.inventoriesAmenities![i].name.toString(),
              style: subTitleTextStyle,
            ),
          ),
          Checkbox(
            onChanged: (bool? value) {
              filter?.inventoriesAmenities?[i].checked = value;

              setState(() {});
            },
            value: filter?.inventoriesAmenities?[i].checked,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: MyTheme.primaryColor,
          )
        ],
      );
    });
  }

  buildInventoriesFeaturesWidgets() {
    inventoriesFeaturesWidgets =
        List<Widget>.generate(filter!.inventoriesFeatures!.length, (i) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              filter!.inventoriesFeatures![i].name.toString(),
              style: subTitleTextStyle,
            ),
          ),
          Checkbox(
            onChanged: (bool? value) {
              filter?.inventoriesFeatures?[i].checked = value;

              setState(() {});
            },
            value: filter?.inventoriesFeatures?[i].checked,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: MyTheme.primaryColor,
          )
        ],
      );
    });
  }

  buildHotelLandmarkWidgets() {
    hotelLandmarkWidgets =
        List<Widget>.generate(filter!.hotelLandmark!.length, (i) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              filter!.hotelLandmark![i].name.toString(),
              style: subTitleTextStyle,
            ),
          ),
          Checkbox(
            onChanged: (bool? value) {
              filter?.hotelLandmark?[i].checked = value;

              setState(() {});
            },
            value: filter?.hotelLandmark?[i].checked,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: MyTheme.primaryColor,
          )
        ],
      );
    });
  }

  buildInventoryMealWidgets() {
    inventoryMealWidgets =
        List<Widget>.generate(filter!.inventoryMeal!.length, (i) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              filter!.inventoryMeal![i].name.toString(),
              style: subTitleTextStyle,
            ),
          ),
          Checkbox(
            onChanged: (bool? value) {
              filter?.inventoryMeal?[i].checked = value;

              setState(() {});
            },
            value: filter?.inventoryMeal?[i].checked,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: MyTheme.primaryColor,
          )
        ],
      );
    });
  }

  buildAllFilterWidgets() {
    buildHotelFacilitiesWidgets();
    buildInventoriesFacilitiesWidgets();
    buildInventoriesAmenitiesWidgets();
    buildInventoriesFeaturesWidgets();
    buildHotelLandmarkWidgets();
    buildInventoryMealWidgets();
  }

  applyFilter() {
    Get.back();

    cubit?.applyFilters(filter!);
  }

  applyReset() {
    filter = widget.hotelSearchResultCubit?.originalFilter?.copy();
    cubit?.filter = filter;
    cubit?.sortAsc = true;
    cubit?.sortPrice = null;
    cubit?.sortRating = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    buildAllFilterWidgets();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: applyReset,
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: MyTheme.primaryColor),
                  ),
                ),
                GestureDetector(
                  onTap: applyFilter,
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: MyTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 5,
            thickness: 0.5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text("Filters"),
                    ),
                    ExpandedTileWidget(
                      subtitleWidget: Text(
                        "Rs. ${filter?.inventoryPrice?.lowest?.round()} - Rs. ${filter?.inventoryPrice?.highest?.round()}",
                        style: subTitleTextStyle,
                      ),
                      titleWidget: Text("Price", style: titleTextStyle),
                      leadingWidget: const PNGIconWidget(
                        asset: "assets/images/money.png",
                        color: MyTheme.primaryColor,
                      ),
                      initiallyExpanded: true,
                      childrenPadding: EdgeInsets.zero,
                      expandedWidgets: [
                        RangeSlider(
                          onChanged: (RangeValues value) {
                            filter?.inventoryPrice?.lowest = value.start;
                            filter?.inventoryPrice?.highest = value.end;

                            setState(() {});
                          },
                          values: RangeValues(filter!.inventoryPrice!.lowest!,
                              filter!.inventoryPrice!.highest!),
                          min: originalFilter!.inventoryPrice!.lowest!,
                          max: originalFilter!.inventoryPrice!.highest!,

                          // divisions: 20,

                          activeColor: MyTheme.primaryColor,
                          inactiveColor: Colors.grey,
                          // labels: RangeLabels(
                          //   "${selectedPriceRange.start}",
                          //   "${selectedPriceRange.end}",
                          // ),
                        ),
                      ],
                    ),
                    ExpandedTileWidget(
                      expandedWidgets: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Search hotels that follow health and safety measures during pandemic?",
                                style: subTitleTextStyle,
                              ),
                            ),
                            Checkbox(
                              onChanged: (bool? value) {
                                filter?.hotelSafetyBool = value;
                                setState(() {});
                              },
                              value: filter?.hotelSafetyBool,
                              activeColor: MyTheme.primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                      leadingWidget: const PNGIconWidget(
                        asset: "assets/images/sanitized.png",
                        color: MyTheme.primaryColor,
                      ),
                      subtitleWidget: Text(
                        filter!.hotelSafetyBool! ? "Yes" : "Doesn't matter",
                        style: subTitleTextStyle,
                      ),
                      titleWidget: Text("Health and safety measures",
                          style: titleTextStyle),
                    ),
                    filter!.hotelFacilities!.isEmpty
                        ? Container()
                        : ExpandedTileWidget(
                            titleWidget:
                                Text("Hotel Facilities", style: titleTextStyle),
                            subtitleWidget: Text(
                              "${filter?.hotelFacilities?.where((x) => x.checked == true).length} selected",
                              style: subTitleTextStyle,
                            ),
                            leadingWidget: const PNGIconWidget(
                              asset: "assets/images/facilities.png",
                              color: MyTheme.primaryColor,
                            ),
                            expandedWidgets: [
                              for (int i = 0;
                                  expandHotelFacilities!
                                      ? i < 5
                                      : i < hotelFacilitiesWidgets!.length;
                                  i++)
                                hotelFacilitiesWidgets![i],
                              hotelFacilitiesWidgets!.length > 5
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (hotelFacilitiesWidgets!.length >
                                            5) {
                                          expandHotelFacilities =
                                              !expandHotelFacilities!;
                                          setState(() {});
                                        }
                                      },
                                      // color: MyTheme.primaryColor,
                                      child: Text(
                                        expandHotelFacilities!
                                            ? "Show more"
                                            : "Show less",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                    filter!.inventoriesFacilities!.isEmpty
                        ? Container()
                        : ExpandedTileWidget(
                            titleWidget: Text("Inventories Facilities",
                                style: titleTextStyle),
                            subtitleWidget: Text(
                              "${filter?.inventoriesFacilities?.where((x) => x.checked == true).length} selected",
                              style: subTitleTextStyle,
                            ),
                            leadingWidget: const PNGIconWidget(
                              asset: "assets/images/facilities.png",
                              color: MyTheme.primaryColor,
                            ),
                            expandedWidgets: [
                              for (int i = 0;
                                  expandInventoriesFacilities!
                                      ? i < 5
                                      : i <
                                          inventoriesFacilitiesWidgets!.length;
                                  i++)
                                inventoriesFacilitiesWidgets![i],
                              inventoriesFacilitiesWidgets!.length > 5
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (inventoriesFacilitiesWidgets!
                                                .length >
                                            5) {
                                          expandInventoriesFacilities =
                                              !expandInventoriesFacilities!;
                                          setState(() {});
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyTheme.primaryColor,
                                      ),
                                      child: Text(
                                        expandInventoriesFacilities!
                                            ? "Show more"
                                            : "Show less",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                    filter!.inventoriesAmenities!.isEmpty
                        ? Container()
                        : ExpandedTileWidget(
                            titleWidget: Text("Inventories Amenities",
                                style: titleTextStyle),
                            subtitleWidget: Text(
                              "${filter?.inventoriesAmenities?.where((x) => x.checked == true).length} selected",
                              style: subTitleTextStyle,
                            ),
                            leadingWidget:
                                const Icon(Icons.home_repair_service),
                            expandedWidgets: [
                              for (int i = 0;
                                  expandInventoriesAmenities!
                                      ? i < 5
                                      : i < inventoriesAmenitiesWidgets!.length;
                                  i++)
                                inventoriesAmenitiesWidgets![i],
                              inventoriesAmenitiesWidgets!.length > 5
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (inventoriesAmenitiesWidgets!
                                                .length >
                                            5) {
                                          expandInventoriesAmenities =
                                              !expandInventoriesAmenities!;
                                          setState(() {});
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyTheme.primaryColor,
                                      ),
                                      child: Text(
                                        expandInventoriesAmenities!
                                            ? "Show more"
                                            : "Show less",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                    filter!.inventoriesFeatures!.isEmpty
                        ? Container()
                        : ExpandedTileWidget(
                            titleWidget: Text("Inventories Features",
                                style: titleTextStyle),
                            subtitleWidget: Text(
                              "${filter?.inventoriesFeatures?.where((x) => x.checked == true).length} selected",
                              style: subTitleTextStyle,
                            ),
                            leadingWidget: const Icon(Icons.fastfood),
                            expandedWidgets: [
                              for (int i = 0;
                                  expandInventoriesFeatures!
                                      ? i < 5
                                      : i < inventoriesFeaturesWidgets!.length;
                                  i++)
                                inventoriesFeaturesWidgets![i],
                              inventoriesFeaturesWidgets!.length > 5
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (inventoriesFeaturesWidgets!.length >
                                            5) {
                                          expandInventoriesFeatures =
                                              !expandInventoriesFeatures!;
                                          setState(() {});
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyTheme.primaryColor,
                                      ),
                                      child: Text(
                                        expandInventoriesFeatures!
                                            ? "Show more"
                                            : "Show less",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                    filter!.hotelLandmark!.isEmpty
                        ? Container()
                        : ExpandedTileWidget(
                            titleWidget:
                                Text("Hotel Landmark", style: titleTextStyle),
                            subtitleWidget: Text(
                              "${filter?.hotelLandmark?.where((x) => x.checked == true).length} selected",
                              style: subTitleTextStyle,
                            ),
                            leadingWidget: const PNGIconWidget(
                              asset: "assets/images/landmark.png",
                              color: MyTheme.primaryColor,
                            ),
                            expandedWidgets: [
                              for (int i = 0;
                                  expandHotelLandmark!
                                      ? i < 5
                                      : i < hotelLandmarkWidgets!.length;
                                  i++)
                                hotelLandmarkWidgets![i],
                              hotelLandmarkWidgets!.length > 5
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (hotelLandmarkWidgets!.length > 5) {
                                          expandHotelLandmark =
                                              !expandHotelLandmark!;
                                          setState(() {});
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyTheme.primaryColor,
                                      ),
                                      child: Text(
                                        expandHotelLandmark!
                                            ? "Show more"
                                            : "Show less",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                    filter!.inventoryMeal!.isEmpty
                        ? Container()
                        : ExpandedTileWidget(
                            titleWidget:
                                Text("Inventory Meal", style: titleTextStyle),
                            subtitleWidget: Text(
                              "${filter?.inventoryMeal?.where((x) => x.checked == true).length} selected",
                              style: subTitleTextStyle,
                            ),
                            leadingWidget: const PNGIconWidget(
                              asset: "assets/images/meal.png",
                              color: MyTheme.primaryColor,
                            ),
                            expandedWidgets: [
                              for (int i = 0;
                                  expandInventoryMeal!
                                      ? i < 5
                                      : i < inventoryMealWidgets!.length;
                                  i++)
                                inventoryMealWidgets![i],
                              inventoryMealWidgets!.length > 5
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (inventoryMealWidgets!.length > 5) {
                                          expandInventoryMeal =
                                              !expandInventoryMeal!;
                                          setState(() {});
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyTheme.primaryColor,
                                      ),
                                      child: Text(
                                        expandInventoryMeal!
                                            ? "Show more"
                                            : "Show less",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                  ],
                ),
              ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
