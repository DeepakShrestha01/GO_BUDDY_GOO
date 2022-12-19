import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../model/new_bus_search_list_response.dart';
import '../../services/cubit/new_bus_search_result/bus_search_list_cubit.dart';
import '../widgets/bus_details_toppart_widget.dart';

class NewBusSearchDetails extends StatefulWidget {
  const NewBusSearchDetails({super.key});

  @override
  State<NewBusSearchDetails> createState() => _NewBusSearchDetailsState();
}

class _NewBusSearchDetailsState extends State<NewBusSearchDetails> {
  Buses buses = Get.arguments[0];
  int sessionid = Get.arguments[1];

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
      return selecteSeat == true
          ? Image.asset(
              "assets/images/seat_selected_2.png",
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

  List<bool> isChooseSeat = List.generate(30, (index) => false);

  List<String> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    var totalprice = '${buses.ticketPrice! * selectedSeats.length}';
    parameters.totalprice = int.parse(totalprice);

    final BusSearchListCubit cubit =
        BlocProvider.of<BusSearchListCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bus Detail",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BusDetailsTopPartWidget(
                operatorName: buses.operatorName.toString(),
                from: cubit.parameters.from.toString(),
                to: cubit.parameters.to.toString(),
                date: cubit.parameters.departureDate,
                shift: cubit.parameters.shift.toString(),
              ),
              Stack(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.5),
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
                                    height: 19,
                                    thickness: 1,
                                    color: Colors.grey),
                                GridView.builder(
                                  itemCount: buses.seatLayout?.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: buses.noOfColumn!),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        var seatNo = buses
                                            .seatLayout![index].displayName;
                                        isChooseSeat[index] =
                                            !isChooseSeat[index];
                                        if (selectedSeats.contains(seatNo)) {
                                          selectedSeats.remove(seatNo);
                                        } else {
                                          if (selectedSeats.length < 6) {
                                            selectedSeats.add(seatNo!);
                                          } else {
                                            isChooseSeat[index] = false;
                                            showToast(
                                                text:
                                                    "Can't add more than 6 seats");
                                          }
                                        }

                                        setState(() {});
                                      },
                                      child: Center(
                                        child: buildBusSeat(
                                            buses.seatLayout![index],
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
                                          buses.departureTime.toString(),
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
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: MyTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Seats : ${selectedSeats.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Total Price : ${buses.ticketPrice! * selectedSeats.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 55,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  // parameters.seats = selectedSeats;
                  // BlocProvider.of<BusSearchListCubit>(context)
                  //     .postSelectedBus(
                  //   buses.id.toString(),
                  //   sessionid,
                  // );

                  if (selectedSeats.isNotEmpty) {
                    if (HiveUser.getLoggedIn()) {
                      parameters.seats = selectedSeats;
                      BlocProvider.of<BusSearchListCubit>(context)
                          .postSelectedBus(
                        buses.id.toString(),
                        sessionid,
                      );
                      Get.toNamed('/passengerDetails', arguments: buses);
                    } else {
                      Get.toNamed("/accountPage");
                    }
                  } else {
                    showToast(text: "No seat selected.");
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'Proceed'.toUpperCase(),
                      style: const TextStyle(color: MyTheme.primaryColor),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: MyTheme.primaryColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
