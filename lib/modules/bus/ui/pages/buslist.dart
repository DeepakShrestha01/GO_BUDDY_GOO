import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../hotel/ui/widgets/no_result_widget.dart';
import '../../model/bus_booking_detail_parameters.dart';
import '../../services/cubit/bus_search_result/bus_search_result_cubit.dart';
import '../widgets/bus_parameters_display.dart';
import '../widgets/bus_widget.dart';
import '../widgets/bus_widget_shimmer.dart';

class BusSearchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BusSearchResultCubit(),
      child: BusSearchListBody(),
    );
  }
}

class BusSearchListBody extends StatefulWidget {
  @override
  _BusSearchListBodyState createState() => _BusSearchListBodyState();
}

class _BusSearchListBodyState extends State<BusSearchListBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BusSearchResultCubit>(context).getBusSearchResult(false);
  }

  @override
  Widget build(BuildContext context) {
    final BusSearchResultCubit cubit =
        BlocProvider.of<BusSearchResultCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bus List",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            BusBookingDetailParameters parameters =
                locator<BusBookingDetailParameters>();
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
        children: [
          BusSearchParameterDisplay(
            from: cubit.parameters?.from,
            to: cubit.parameters?.to,
            noOfBuses: cubit.noOfBuses,
            date:
                DateTimeFormatter.formatDate(cubit.parameters!.departureDate!),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: BlocBuilder<BusSearchResultCubit, BusSearchResultState>(
              builder: (context, state) {
                if (state is BusSearchResultLoading) {
                  return ListView.separated(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return BusWidgetShimmer();
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 1);
                    },
                  );
                } else if (state is BusSearchResultLoaded) {
                  if (cubit.buses.isEmpty) {
                    return const NoResultWidget();
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          scrollInfo is ScrollEndNotification) {
                        if (!cubit.allDataLoaded) {
                          cubit.getBusSearchResult(true);
                        }
                      }
                      return false;
                    },
                    child: ListView.separated(
                      itemCount: cubit.buses.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == cubit.buses.length) {
                          if (cubit.allDataLoaded) return Container();

                          return const LoadingWidget();
                        }
                        return BusWidget(bus: cubit.buses[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 1);
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
