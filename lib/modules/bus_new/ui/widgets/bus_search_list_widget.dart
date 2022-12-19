import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';
import 'package:recase/recase.dart';

class BusSeachlistWidget extends StatelessWidget {
  final Buses data;
  final int sessionId;
  const BusSeachlistWidget({
    super.key,
    required this.data,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyTheme.primaryDimColor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 5),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        height: 270,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.operatorName!.titleCase,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${data.busType}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.primaryColor),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Boarding:',
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        '- ${data.departureTime}',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Journey Hour:',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '- ${data.journeyHour} hr',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shift : ${data.shift} ",
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'NPR ${data.ticketPrice}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '/ Per Seat',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data.seatLayout?.length} Seats Available",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 90),
                        //   child: LinearPercentIndicator(
                        //     barRadius: const Radius.circular(5),
                        //     percent: data.seatLayout!.length / 20,
                        //     progressColor: Colors.green,
                        //     lineHeight: 7.5,
                        //   ),
                        // ),
                        Text(
                          "${data.seatLayout?.length} Total Seats ",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.primaryColor),
                        onPressed: () {
                          Get.toNamed(
                            '/newbusSearchDetail',
                            arguments: [
                              data,
                              sessionId,
                            ],
                          );
                        },
                        child: const Text('Book Now')),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.amenities?.length,
                  itemBuilder: (context, index) {
                    return Wrap(
                      spacing: 10,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 2.5,
                              backgroundColor: MyTheme.primaryColor,
                            ),
                            Text(
                              ' ${data.amenities![index].toUpperCase()}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5)
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
