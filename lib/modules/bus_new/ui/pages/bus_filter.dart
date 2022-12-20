// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo/modules/bus_new/model/new_bus_search_list_response.dart';

import '../../../../configs/theme.dart';

class BusFilter extends StatefulWidget {
  List<Buses> buses;
  BusFilter({
    Key? key,
    required this.buses,
  }) : super(key: key);

  @override
  State<BusFilter> createState() => _BusFilterState();
}

class _BusFilterState extends State<BusFilter> {
  applyReset() {
    Get.back();
  }

  applyFilter() {
    Get.back();
  }

  ascendingOrder() {
    widget.buses.sort(
      (a, b) {
        return a.ticketPrice!.compareTo(b.ticketPrice!);
      },
    );
  }

  descendingOrder() {
    widget.buses.sort(
      (a, b) {
        return b.ticketPrice!.compareTo(a.ticketPrice!);
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        const Text("Sort By Price"),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {});
                                ascendingOrder();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  // color: widget.cubit!.sortAsc
                                  //     ? MyTheme.primaryColor
                                  //     : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Asc",
                                  style: TextStyle(
                                    fontSize: 16,
                                    // color: widget.cubit!.sortAsc
                                    //     ? Colors.white
                                    //     : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // widget.cubit!.sortAsc = false;
                                // setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  // color: !widget.cubit!.sortAsc
                                  //     ? MyTheme.primaryColor
                                  //     : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Desc",
                                  style: TextStyle(
                                    fontSize: 16,
                                    // color: !widget.cubit!.sortAsc
                                    //     ? Colors.white
                                    //     : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sort By Time"),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  // color: widget.cubit!.sortAsc
                                  //     ? MyTheme.primaryColor
                                  //     : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Asc",
                                  style: TextStyle(
                                    fontSize: 16,
                                    // color: widget.cubit!.sortAsc
                                    //     ? Colors.white
                                    //     : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // widget.cubit!.sortAsc = false;
                                // setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  // color: !widget.cubit!.sortAsc
                                  //     ? MyTheme.primaryColor
                                  //     : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Desc",
                                  style: TextStyle(
                                    fontSize: 16,
                                    // color: !widget.cubit!.sortAsc
                                    //     ? Colors.white
                                    //     : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
