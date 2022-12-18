// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';

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
    print('mySelectttt : $selecteSeat');
    if (busSeats.bookingStatus == "na") {
      return Container(
        height: 30,
        width: 30,
        alignment: Alignment.center,
      );
    }

    if (busSeats.bookingStatus == 'No') {
      return selecteSeat == true
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
  }

  List<bool> isChooseSeat = List.generate(20, (index) => false);
  // final List<bool> _isSelectedA = List.generate(50, (index) {
  //   return false;
  // });
  List<dynamic> selectedSeats = [];

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
                              var seatNo =
                                  widget.buses.seatLayout![index].displayName;
                              isChooseSeat[index] = !isChooseSeat[index];
                              if (selectedSeats.contains(seatNo)) {
                                selectedSeats.remove(seatNo);
                              } else {
                                selectedSeats.add(seatNo);
                              }

                              // selectedSeats.add(
                              //     widget.buses.seatLayout![index].displayName);

                              print(
                                  'printed seat${widget.buses.seatLayout?[index].displayName}');
                              setState(() {});

                              print('no seats : $selectedSeats');
                            },
                            child: Center(
                              child: buildBusSeat(
                                  widget.buses.seatLayout![index],
                                  isChooseSeat[index]),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: MediaQuery.of(context).size.width,
                          color: MyTheme.primaryColor,
                        ),
                        Positioned(
                          left: 20,
                          top: 12,
                          child: Column(
                            children: [
                              Text(parameters.from.toString()),
                              const SizedBox(height: 3),
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyTheme.primaryColor,
                                ),
                              ),
                              Text(
                                widget.buses.departureTime.toString(),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 12,
                          child: Column(
                            children: [
                              Text(parameters.to.toString()),
                              const SizedBox(height: 3),
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyTheme.primaryColor,
                                ),
                              ),
                            ],
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
      ],
    );
  }
}
