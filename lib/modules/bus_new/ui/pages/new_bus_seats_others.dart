// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';

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
  buildBusSeatImage(String image, {Color? color}) {
    return Image.asset(
      image,
      height: 20,
      width: 20,
      color: color,
    );
  }

  buildBusSeat(SeatLayout busSeats) {
    if (busSeats.bookingStatus == "na") {
      return Container(
        height: 30,
        width: 30,
        alignment: Alignment.center,
      );
    }

    if (busSeats.bookingStatus == 'No') {
      return isChooseSeat
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
            busSeats.bookingStatus == 'No';
            selectedSeats.remove(busSeats);
          }
        }
      },
    );
  }

  bool isChooseSeat = false;

  List<SeatLayout> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 2,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
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
                            child: Center(
                              child:
                                  buildBusSeat(widget.buses.seatLayout![index]),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
