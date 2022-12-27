// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo/modules/bus_new/services/cubit/new_bus_search_result/bus_search_list_cubit.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../model/new_bus_search_list_response.dart';

class BusFilter extends StatefulWidget {
  BusSearchListCubit? cubit;
  BusFilter({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  State<BusFilter> createState() => _BusFilterState();
}

class _BusFilterState extends State<BusFilter> {
  Buses? buses;
  @override
  void initState() {
    // cubit = BlocProvider.of<BusSearchListCubit>(context);
    super.initState();
  }

  applyReset() {
    Get.back();
  }

  applyFilter() {
    Get.back();
    widget.cubit?.filterBus(buses);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(children: [
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Sort By"),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {});
                              widget.cubit?.sortAsc = true;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: widget.cubit!.sortAsc
                                    ? MyTheme.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Asc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: widget.cubit!.sortAsc
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {});
                              widget.cubit?.sortAsc = false;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: widget.cubit!.sortAsc
                                    ? MyTheme.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Desc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: widget.cubit!.sortAsc
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 5,
                  thickness: 0.5,
                ),
                const SizedBox(height: 7.5),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    widget.cubit?.sortPrice = true;
                    widget.cubit?.sortTime = null;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(
                            color: widget.cubit?.sortPrice == null
                                ? Colors.black
                                : MyTheme.primaryColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Row(
                          children: [
                            PNGIconWidget(
                              asset: "assets/images/money.png",
                              color: widget.cubit?.sortPrice == null
                                  ? Colors.black
                                  : MyTheme.primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              widget.cubit?.sortPrice == null
                                  ? null
                                  : widget.cubit!.sortAsc
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                              color: MyTheme.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    widget.cubit?.sortTime = true;
                    widget.cubit?.sortPrice = null;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Time",
                          style: TextStyle(
                            color: widget.cubit?.sortTime == null
                                ? Colors.black
                                : MyTheme.primaryColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Row(
                          children: [
                            PNGIconWidget(
                              asset: "assets/images/clock.png",
                              color: widget.cubit?.sortTime == null
                                  ? Colors.black
                                  : MyTheme.primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.cubit?.sortTime == null
                                  ? "         "
                                  : widget.cubit!.sortAsc
                                      ? "Early"
                                      : "Late ",
                              style:
                                  const TextStyle(color: MyTheme.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 5,
                  thickness: 0.5,
                ),
              ],
            ),
          )
        ]));
  }
}
