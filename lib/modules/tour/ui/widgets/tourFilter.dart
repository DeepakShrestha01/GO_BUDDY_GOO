import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/ui/widgets/filterCard.dart';
import '../../servies/cubit/tour_search_result/tour_search_result_cubit.dart';

class TourFilter extends StatefulWidget {
  final TourSearchResultCubit? tourSearchResultCubit;

  const TourFilter(this.tourSearchResultCubit, {super.key});

  @override
  _TourFilterState createState() => _TourFilterState();
}

class _TourFilterState extends State<TourFilter> {
  TourSearchResultCubit? cubit;

  bool? activities;

  List<Widget>? tourActivitiesWidgets;

  TextStyle subTitleTextStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

  TextStyle titleTextStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  @override
  void initState() {
    super.initState();

    cubit = widget.tourSearchResultCubit;

    setBooleans();
  }

  setBooleans() {
    activities = cubit!.activities.length > 5;
  }

  buildTourActivitiesWidgets() {
    tourActivitiesWidgets = List<Widget>.generate(
      cubit!.activities.length,
      (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                cubit!.activities[i],
                style: subTitleTextStyle,
              ),
            ),
            Checkbox(
              onChanged: (bool? value) {
                if (value!) {
                  if (!cubit!.selectedActivities
                      .contains(cubit?.activities[i])) {
                    cubit?.selectedActivities.add(cubit!.activities[i]);
                  }
                } else {
                  if (cubit!.selectedActivities
                      .contains(cubit?.activities[i])) {
                    cubit?.selectedActivities.remove(cubit?.activities[i]);
                  }
                }

                setState(() {});
              },
              value: cubit?.selectedActivities.contains(cubit?.activities[i]),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: MyTheme.primaryColor,
            )
          ],
        );
      },
    );
  }

  applyFilter() {
    Get.back();
    cubit?.applyFilters();
  }

  applyReset() {
    cubit?.applyReset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    buildTourActivitiesWidgets();

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
                        "Rs. ${cubit?.selectedStartPrice.round()} - Rs. ${cubit?.selectedEndPrice.round()}",
                        style: subTitleTextStyle,
                      ),
                      titleWidget: Text("Price", style: titleTextStyle),
                      leadingWidget: const PNGIconWidget(
                        asset: "assets/images/money.png",
                        color: MyTheme.primaryColor,
                      ),

                      // Icon(Icons.monetization_on),
                      initiallyExpanded: true,
                      childrenPadding: EdgeInsets.zero,
                      expandedWidgets: [
                        RangeSlider(
                          onChanged: (RangeValues value) {
                            cubit?.selectedStartPrice = value.start;
                            cubit?.selectedEndPrice = value.end;

                            setState(() {});
                          },
                          values: RangeValues(
                            cubit!.selectedStartPrice,
                            cubit!.selectedEndPrice,
                          ),
                          min: cubit!.startPrice,
                          max: cubit!.endPrice,

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
                    cubit!.activities.isEmpty
                        ? Container()
                        : ExpandedTileWidget(
                            titleWidget:
                                Text("Activities", style: titleTextStyle),
                            subtitleWidget: Text(
                              "${cubit?.selectedActivities.length} selected",
                              style: subTitleTextStyle,
                            ),
                            leadingWidget: const Icon(Icons.run_circle),
                            expandedWidgets: [
                              for (int i = 0;
                                  activities!
                                      ? i < 5
                                      : i < tourActivitiesWidgets!.length;
                                  i++)
                                tourActivitiesWidgets![i],
                              tourActivitiesWidgets!.length > 5
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (tourActivitiesWidgets!.length > 5) {
                                          activities = !activities!;
                                          setState(() {});
                                        }
                                      },
                                      // color: MyTheme.primaryColor,
                                      child: Text(
                                        activities! ? "Show more" : "Show less",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.5, horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Package Costing Type",
                                  style: titleTextStyle),
                              DropdownButton(
                                hint: Text(cubit!.packageCostingType[
                                    cubit!.packageCostingTypeIndex]),
                                items: List<DropdownMenuItem>.generate(
                                    cubit!.packageCostingType.length, (i) {
                                  return DropdownMenuItem(
                                    value: i,
                                    child: Text(cubit!.packageCostingType[i]),
                                  );
                                }),
                                onChanged: (value) {
                                  cubit?.packageCostingTypeIndex = value;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 0.5,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 7.5, horizontal: 10),
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text("Package Theme", style: titleTextStyle),
                    //           DropdownButton(
                    //             hint: Text(cubit.selectedThemeIndex == null
                    //                 ? "Any"
                    //                 : cubit
                    //                     .packageThemes
                    //                     .themes[cubit.selectedThemeIndex]
                    //                     .title),
                    //             items: List<DropdownMenuItem>.generate(
                    //                 cubit.packageThemes.themes.length, (i) {
                    //               return DropdownMenuItem(
                    //                 value: i,
                    //                 child: Text(
                    //                     cubit.packageThemes.themes[i].title),
                    //               );
                    //             }),
                    //             onChanged: (value) {
                    //               cubit.selectedThemeIndex = value;
                    //               setState(() {});
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Divider(
                    //   color: Colors.grey[400],
                    //   height: 5,
                    //   thickness: 0.5,
                    // ),
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
