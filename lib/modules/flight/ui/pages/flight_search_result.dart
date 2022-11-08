import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/ui/widgets/no_result_widget.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../model/no_of_flightnotifier.dart';
import '../../model/selected_flights.dart';
import '../../services/cubit/flight_search_result/flight_search_result_cubit.dart';
import '../widgets/flight_filter.dart';
import '../widgets/flight_parameters_display.dart';
import '../widgets/flight_widget.dart';
import '../widgets/x_button.dart';

class FlightSearchResultPage extends StatelessWidget {
  const FlightSearchResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          FlightSearchResultCubit()..getFlightSearchResult(),
      child: const FlightSearchResultBody(),
    );
  }
}

class FlightSearchResultBody extends StatefulWidget {
  const FlightSearchResultBody({Key? key}) : super(key: key);

  @override
  _FlightSearchResultBodyState createState() => _FlightSearchResultBodyState();
}

class _FlightSearchResultBodyState extends State<FlightSearchResultBody> {
  bool departureSelected = true;
  FlightSearchResultCubit? cubit;

  ScrollController controller1 = ScrollController();
  ScrollController controller2 = ScrollController();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<FlightSearchResultCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Available Flights",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            noOfOutboundFlights.value = 0;
            noOfInboundFlights.value = 0;

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
          FlightParametersDisplay(parameter: cubit?.parameters),
          const SizedBox(height: 10),
          Expanded(
            child:
                BlocConsumer<FlightSearchResultCubit, FlightSearchResultState>(
              listener: (context, state) {},
              builder: (BuildContext context, state) {
                if (state is FlightSearchResultLoaded) {
                  List<Widget> children;

                  if (departureSelected) {
                    if (cubit!.outBoundData!.isEmpty) {
                      children = [const Center(child: NoResultWidget())];
                    } else {
                      children = List.generate(
                        cubit!.outBoundData!.length,
                        (i) => GestureDetector(
                          onTap: () {
                            cubit?.selectOutBound(cubit!.outBoundData![i]);
                            setState(() {});
                          },
                          child: FlightDetailWidget(
                            flight: cubit?.outBoundData?[i],
                            isSelected: cubit?.selectedOutbound == null
                                ? false
                                : cubit?.outBoundData?[i] ==
                                    cubit?.selectedOutbound,
                          ),
                        ),
                      );
                    }
                  } else {
                    if (cubit!.inBoundData!.isEmpty) {
                      children = [const Center(child: NoResultWidget())];
                    } else {
                      children = List.generate(
                        cubit!.inBoundData!.length,
                        (i) => GestureDetector(
                          onTap: () {
                            cubit?.selectInBound(cubit!.inBoundData![i]);
                            setState(() {});
                          },
                          child: FlightDetailWidget(
                            flight: cubit?.inBoundData?[i],
                            isSelected: cubit?.selectedInbound == null
                                ? false
                                : cubit?.inBoundData?[i] ==
                                    cubit?.selectedInbound,
                          ),
                        ),
                      );
                    }
                  }
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          if (cubit?.parameters.tripType == "R")
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: XButtonWidget(
                                      isSelected: departureSelected,
                                      text: "Outbound",
                                      onTap: () {
                                        departureSelected = true;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: XButtonWidget(
                                      isSelected: !departureSelected,
                                      text: "Inbound",
                                      onTap: () {
                                        departureSelected = false;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              controller:
                                  departureSelected ? controller1 : controller2,
                              child: Column(children: children),
                            ),
                          ),
                          if (cubit?.selectedOutbound != null)
                            const SizedBox(height: 50),
                        ],
                      ),
                      if (cubit?.parameters.tripType == "R" &&
                          cubit?.selectedOutbound != null &&
                          cubit?.selectedInbound != null)
                        Positioned(
                          bottom: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              getFilterWidget(),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  SelectedFlights selectedFlights =
                                      locator<SelectedFlights>();
                                  selectedFlights
                                      .selectInBound(cubit!.selectedInbound!);
                                  selectedFlights
                                      .selectOutBound(cubit!.selectedOutbound!);
                                  bool loggedIn = HiveUser.getLoggedIn();

                                  if (loggedIn) {
                                    Get.toNamed("/flightReserve")
                                        ?.then((value) {
                                      BlocProvider.of<FlightSearchResultCubit>(
                                              context)
                                          .getFlightSearchResult();
                                    });
                                  } else {
                                    Get.toNamed("/accountPage");
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  color: MyTheme.primaryColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Proceed".toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (cubit?.parameters.tripType == "O" &&
                          cubit?.selectedOutbound != null)
                        Positioned(
                          bottom: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              getFilterWidget(),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  SelectedFlights selectedFlights =
                                      locator<SelectedFlights>();
                                  selectedFlights
                                      .selectInBound(cubit!.selectedInbound!);
                                  selectedFlights
                                      .selectOutBound(cubit!.selectedOutbound!);

                                  bool loggedIn = HiveUser.getLoggedIn();

                                  if (loggedIn) {
                                    Get.toNamed("/flightReserve")
                                        ?.then((value) {
                                      BlocProvider.of<FlightSearchResultCubit>(
                                              context)
                                          .getFlightSearchResult();
                                    });
                                  } else {
                                    Get.toNamed("/accountPage");
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  color: MyTheme.primaryColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Proceed".toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Positioned(
                          bottom: 10.0,
                          right: 0.0,
                          child: getFilterWidget(),
                        ),
                    ],
                  );
                } else if (state is FlightSearchResultError) {
                  return const NoResultWidget();
                }
                return const LoadingWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  showFilterModalSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black12.withOpacity(0.75),
      builder: (BuildContext context) {
        return FlightFilter(cubit);
      },
    );
  }

  getFilterWidget() {
    return GestureDetector(
      onTap: () {
        showFilterModalSheet();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: MyTheme.primaryColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
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
      ),
    );
  }
}
