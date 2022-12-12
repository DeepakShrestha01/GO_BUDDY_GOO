import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/common/services/get_it.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/services/cubit/new_bus_search_result/bus_search_list_cubit.dart';

class NewBusSearchList extends StatelessWidget {
  const NewBusSearchList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BusSearchListCubit>(
      create: (context) {
        return BusSearchListCubit();
      },
      child: const NewBusSearchListBody(),
    );
  }
}

class NewBusSearchListBody extends StatefulWidget {
  const NewBusSearchListBody({super.key});

  @override
  State<NewBusSearchListBody> createState() => _NewBusSearchListBodyState();
}

class _NewBusSearchListBodyState extends State<NewBusSearchListBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bus List",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            NewBusSearchListParameters parameters =
                locator<NewBusSearchListParameters>();
            parameters.clearAllField();
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: () {
                  Get.offNamedUntil("/", (route) => false);
                },
                child: const Icon(CupertinoIcons.multiply_circle_fill)),
          ),
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
