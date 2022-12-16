import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';

class BusSeachlistWidget extends StatelessWidget {
  final Buses data;
  const BusSeachlistWidget({
    super.key,
    required this.data,
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
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data.operatorName}',
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
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '- ${data.departureTime}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
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
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '- ${data.journeyHour} hr',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
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
                        fontSize: 13, fontWeight: FontWeight.bold),
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
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyTheme.primaryColor),
                    onPressed: () {},
                    child: const Text('Book Now')),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // scrollDirection: Axis.horizontal,
                  itemCount: data.amenities?.length,
                  itemBuilder: (context, index) {
                    return Wrap(
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
