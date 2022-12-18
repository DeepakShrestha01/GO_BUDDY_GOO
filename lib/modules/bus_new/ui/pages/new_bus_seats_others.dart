// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';

import '../../../../common/widgets/common_widgets.dart';

class NewBusSeatsAndOthers extends StatefulWidget {
  Buses buses;
  NewBusSeatsAndOthers({
    Key? key,
    required this.buses,
  }) : super(key: key);

  @override
  State<NewBusSeatsAndOthers> createState() => _NewBusSeatsAndOthersState();
}

class _NewBusSeatsAndOthersState extends State<NewBusSeatsAndOthers> {
  NewBusSearchListParameters parameters = NewBusSearchListParameters();
  buildBusSeatImage(String image, {Color? color}) {
    return Image.asset(
      image,
      height: 20,
      width: 20,
      color: color,
    );
  }

  buildBusSeat(SeatLayout busSeats, bool selecteSeat) {
    if (busSeats.bookingStatus == "na") {
      return Container(
        height: 30,
        width: 30,
        alignment: Alignment.center,
      );
    }

    if (busSeats.bookingStatus == 'No') {
      return selecteSeat
          ? Image.asset(
              'assets/images/seat_available.png',
              color: MyTheme.primaryColor,
              scale: 2.5,
            )
          : Image.asset(
              'assets/images/seat_available.png',
              scale: 2.5,
            );
    } else if (busSeats.bookingStatus == 'Yes') {
      return Image.asset(
        'assets/images/seat_booked.png',
        scale: 2.5,
      );
    }
    return GestureDetector(
      onTap: () {
        if (busSeats.displayName != null) {
          if (selectedSeats.contains(busSeats)) {
            busSeats.bookingStatus == 'Yes';
            selectedSeats.remove(busSeats);
          } else {
            if (selectedSeats.length < 6) {
              busSeats.bookingStatus == "No";
              selectedSeats.add(busSeats);
            } else {
              showToast(text: "You can only book 6 seats in one booking.");
            }
          }
        }
      },
    );
  }

  bool isChooseSeat = false;
  final List<bool> _isSelectedA = List.generate(50, (index) {
    return false;
  });
  List<SeatLayout> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.5),
                        child: Wrap(
                          runSpacing: 20.0,
                          spacing: 30.0,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text("Selected"),
                                buildBusSeatImage(
                                    "assets/images/seat_selected_2.png"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Available"),
                                buildBusSeatImage(
                                    "assets/images/seat_available.png"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Sold"),
                                buildBusSeatImage(
                                    "assets/images/seat_selected_2.png",
                                    color: Colors.purple),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                          height: 19, thickness: 1, color: Colors.grey),
                      GridView.builder(
                        itemCount: widget.buses.seatLayout?.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widget.buses.noOfColumn!),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (widget.buses.seatLayout?[index].displayName !=
                                  null) {
                                if (selectedSeats.contains(
                                    widget.buses.seatLayout?[index])) {
                                  widget.buses.seatLayout?[index]
                                          .bookingStatus ==
                                      'Yes';
                                  selectedSeats
                                      .remove(widget.buses.seatLayout?[index]);
                                } else {
                                  if (selectedSeats.length < 6) {
                                    widget.buses.seatLayout?[index]
                                            .bookingStatus ==
                                        "No";
                                    selectedSeats
                                        .add(widget.buses.seatLayout![index]);
                                  } else {
                                    showToast(
                                        text:
                                            "You can only book 6 seats in one booking.");
                                  }
                                }
                              }
                            },
                            // onTap: () {
                            //   _isSelectedA[index] = !_isSelectedA[index];
                            //   // selectedSeats.add(value);

                            //   print('printed seat$index');
                            //   setState(() {});
                            // },
                            child: Center(
                              child: buildBusSeat(
                                  widget.buses.seatLayout![index],
                                  _isSelectedA[index]),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        Positioned(
          top: 20,
          child: Container(
            height: 50,
            color: Colors.black,
          ),
        )

        // Positioned(
        //   bottom: -10,
        //   child: Container(
        //     decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        //     height: 75,
        //     width: MediaQuery.of(context).size.width,
        //     padding: const EdgeInsets.symmetric(horizontal: 5),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: Center(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Expanded(
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: const [
        //                       Text(
        //                         "Selected Seats",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                       // Text(
        //                       //   getSelectedSeatsName(),
        //                       //   maxLines: 2,
        //                       //   overflow: TextOverflow.ellipsis,
        //                       //   style: const TextStyle(color: Colors.white),
        //                       // ),
        //                     ],
        //                   ),
        //                 ),
        //                 const SizedBox(width: 3),
        //                 Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   crossAxisAlignment: CrossAxisAlignment.end,
        //                   children: const [
        //                     Text(
        //                       "Total Price",
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontSize: 12,
        //                       ),
        //                     ),
        //                     // Text(
        //                     //   "Rs. ${getInitialTotalAmount().toStringAsFixed(2)}",
        //                     //   style: const TextStyle(color: Colors.white),
        //                     // ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 3),
        //         ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor: Colors.white,
        //             padding: const EdgeInsets.symmetric(horizontal: 3),
        //           ),
        //           onPressed: () {
        //             // if (selectedBusSeats.isNotEmpty) {
        //             //   if (HiveUser.getLoggedIn()) {
        //             //     parameters.selectedSeats = selectedBusSeats;
        //             //     Get.toNamed("/busBookingConfirm")?.whenComplete(() {
        //             //       BlocProvider.of<BusDetailCubit>(context).getBusDetail(
        //             //         busId: parameters.selectedBusId,
        //             //         bookingDate: DateTimeFormatter.formatDateServer(
        //             //             parameters.departureDate),
        //             //       );
        //             //     });
        //             //   } else {
        //             //     Get.toNamed("/accountPage");
        //             //   }
        //             // } else {
        //             //   showToast(text: "No seat selected.");
        //             // }
        //           },
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Text(
        //                 "Proceed".toUpperCase(),
        //                 style: TextStyle(
        //                   color: Theme.of(context).primaryColor,
        //                   fontWeight: FontWeight.w700,
        //                 ),
        //               ),
        //               const SizedBox(width: 5),
        //               Icon(
        //                 Icons.arrow_forward_ios,
        //                 color: Theme.of(context).primaryColor,
        //                 size: 20,
        //               ),
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
