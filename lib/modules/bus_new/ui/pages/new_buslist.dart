import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/common/services/get_it.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/services/cubit/new_bus_search_result/bus_search_list_cubit.dart';
import 'package:go_buddy_goo_mobile/modules/hotel/ui/widgets/no_result_widget.dart';

import '../../../../configs/theme.dart';
import '../widgets/bus_search_list_widget.dart';
import '../widgets/buslist_toppart.dart';

class NewBusSearchListBody extends StatefulWidget {
  const NewBusSearchListBody({super.key});

  @override
  State<NewBusSearchListBody> createState() => _NewBusSearchListBodyState();
}

class _NewBusSearchListBodyState extends State<NewBusSearchListBody> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<BusSearchListCubit>(context).getNewBusSearchResult();
    BlocProvider.of<BusSearchListCubit>(context).buses;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final BusSearchListCubit cubit =
        BlocProvider.of<BusSearchListCubit>(context);

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            BusListTopPart(
              from: cubit.parameters.from.toString(),
              to: cubit.parameters.to.toString(),
              date: cubit.parameters.departureDate!,
              shift: cubit.parameters.shift.toString(),
              noOfBuses: cubit.parameters.buses,
            ),
            const SizedBox(height: 20),
            BlocBuilder<BusSearchListCubit, BusSearchListState>(
              builder: (context, state) {
                if (state is BusSearchListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is BusSearchListErrorState) {
                  return const NoResultWidget();
                }

                if (state is BusSearchListSuccessState) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/newbusSearchDetail', arguments: [
                            state.response.buses?[index],
                            state.response.sessionId
                          ]);
                        },
                        child: BusSeachlistWidget(
                          sessionId: state.response.sessionId!,
                          data: state.response.buses![index],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: state.response.buses!.length,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Container(
          height: 45,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: MyTheme.primaryColor,
          ),
          child: FloatingActionButton(
            backgroundColor: MyTheme.primaryColor,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                isScrollControlled: false,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black12.withOpacity(0.75),
                builder: (BuildContext context) {
                  return const Text('data');
                },
              );
            },
            child: Container(
              height: 45,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: MyTheme.primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Filter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
