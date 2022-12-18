import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/ui/pages/new_bus_seats_others.dart';

import '../../model/new_bus_search_list_response.dart';
import '../../services/cubit/new_bus_search_result/bus_search_list_cubit.dart';
import '../widgets/bus_details_toppart_widget.dart';

class NewBusSearchDetails extends StatefulWidget {
  const NewBusSearchDetails({super.key});

  @override
  State<NewBusSearchDetails> createState() => _NewBusSearchDetailsState();
}

class _NewBusSearchDetailsState extends State<NewBusSearchDetails> {
  Buses data = Get.arguments;
  NewBusSearchListParameters? parameters;

  @override
  Widget build(BuildContext context) {
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
                operatorName: data.operatorName.toString(),
                from: cubit.parameters.from.toString(),
                to: cubit.parameters.to.toString(),
                date: cubit.parameters.departureDate,
                shift: cubit.parameters.shift.toString(),
              ),
              NewBusSeatsAndOthers(
                buses: data,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 65,
        width: MediaQuery.of(context).size.width,
        color: MyTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Row(
              children: [
                const Text(
                  'Selected Seats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 82,
                ),
                Center(
                  child: Column(
                    children: const [
                      Text(
                        'Total Price',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Rs.000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {},
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
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
