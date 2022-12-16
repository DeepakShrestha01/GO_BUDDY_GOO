import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
        title: const Text("Bus Details"),
      ),
      body: SingleChildScrollView(
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
    );
  }
}
