import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:recase/recase.dart';

import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/ui/widgets/no_result_widget.dart';
import '../../model/rental.dart';
import '../../model/rental_booking_detail_parameters.dart';
import '../../model/value_notifier.dart';
import '../../services/cubit/rental_search_result/rental_search_result_cubit.dart';
import '../widgets/singleRental.dart';

class RentalSearchListPage extends StatelessWidget {
  const RentalSearchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RentalSearchResultCubit(),
      child: RentalSearchResultBody(pickUpLocation: Get.arguments),
    );
  }
}

class RentalSearchResultBody extends StatefulWidget {
  final String? pickUpLocation;

  const RentalSearchResultBody({Key? key, this.pickUpLocation})
      : super(key: key);
  @override
  _RentalSearchResultBodyState createState() => _RentalSearchResultBodyState();
}

class _RentalSearchResultBodyState extends State<RentalSearchResultBody> {
  @override
  void dispose() {
    rentalSearchResultNumber.value = 0;

    RentalBookingDetailParameters parameters =
        locator<RentalBookingDetailParameters>();
    parameters.clearAllField();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RentalSearchResultCubit>(context).getSearchResult(false);
  }

  @override
  Widget build(BuildContext context) {
    final RentalSearchResultCubit vehicleSearchResultCubit =
        BlocProvider.of<RentalSearchResultCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Vehicle List",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
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
          TopPartWidget(),
          const SizedBox(height: 10),
          Expanded(
            child:
                BlocBuilder<RentalSearchResultCubit, RentalSearchResultState>(
              builder: (context, state) {
                if (state is RentalSearchLoaded ||
                    state is RentalSearchMoreLoading) {
                  return RentalListWidget(cubit: vehicleSearchResultCubit);
                }

                return const LoadingWidget();
              },
            ),
          )
        ],
      ),
    );
  }
}

class RentalListWidget extends StatefulWidget {
  final RentalSearchResultCubit? cubit;

  const RentalListWidget({Key? key, this.cubit}) : super(key: key);

  @override
  _RentalListWidgetState createState() => _RentalListWidgetState();
}

class _RentalListWidgetState extends State<RentalListWidget> {
  showFilterModalSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black12.withOpacity(0.75),
      builder: (BuildContext context) {
        return RentalFilterWidget(vehicleSearchResultCubit!);
      },
    );
  }

  List<Rental>? vehicles;
  RentalSearchResultCubit? vehicleSearchResultCubit;

  @override
  void initState() {
    super.initState();
    vehicleSearchResultCubit = widget.cubit;
    vehicles = vehicleSearchResultCubit?.vehicleLists;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        vehicles!.isEmpty
            ? const NoResultWidget()
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      scrollInfo is ScrollEndNotification) {
                    if (!vehicleSearchResultCubit!.allDataLoaded) {
                      if (vehicleSearchResultCubit!.filterApplied) {
                        vehicleSearchResultCubit?.applyFilters(true);
                      } else {
                        vehicleSearchResultCubit?.getSearchResult(true);
                      }
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vehicles!.length + 1,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (BuildContext context, int i) {
                    if (i == vehicles?.length) {
                      if (vehicleSearchResultCubit!.allDataLoaded) {
                        return Container();
                      }

                      return const LoadingWidget();
                    }
                    return SingleRentalSearch(rental: vehicles?[i]);
                  },
                ),
              ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              showFilterModalSheet();
            },
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
        ),
      ],
    );
  }
}

class TopPartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RentalBookingDetailParameters parameters =
        locator<RentalBookingDetailParameters>();

    if (parameters.rentalItem != null) {
      rentalVehicleTyle.value = parameters.rentalItem.toString();
    } else {
      rentalVehicleTyle.value = "All vehicles";
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: MyTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                'Keyword: ${rentalVehicleTyle.value.titleCase} ${parameters.city?.titleCase}',

                // "${"Keyword: " + rentalVehicleTyle.value.titleCase} | " +
                //     parameters.city?.titleCase,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              );
            },
            valueListenable: rentalVehicleTyle,
          ),
          const SizedBox(height: 5),
          ValueListenableBuilder(
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                "${rentalSearchResultNumber.value} Vehicles",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              );
            },
            valueListenable: rentalSearchResultNumber,
          ),
        ],
      ),
    );
  }
}

class RentalFilterWidget extends StatefulWidget {
  final RentalSearchResultCubit cubit;

  const RentalFilterWidget(this.cubit);
  @override
  _RentalFilterWidgetState createState() => _RentalFilterWidgetState();
}

class _RentalFilterWidgetState extends State<RentalFilterWidget> {
  RentalSearchResultCubit? cubit;

  @override
  void initState() {
    super.initState();
    cubit = widget.cubit;
    subTitleTextStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
    titleTextStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
    selectedVehicleText = cubit?.selectedVehicleindex == null
        ? "Select"
        : cubit!.rentalItems[cubit!.selectedVehicleindex!].name.toString();
  }

  applyReset() {
    selectedVehicleText = "Select";
    cubit?.selectedVehicleindex = null;
    setState(() {});
  }

  applyFilter(bool isLoadMore) {
    Get.back();
    cubit?.applyFilters(isLoadMore);
  }

  TextStyle? subTitleTextStyle, titleTextStyle;

  String? selectedVehicleText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: applyReset,
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: MyTheme.primaryColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    applyFilter(false);
                  },
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: MyTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Filter By (Vehicle Type)", style: titleTextStyle),
                    DropdownButton(
                      hint: Text(selectedVehicleText!),
                      items: List<DropdownMenuItem>.generate(
                          cubit!.rentalItems.length, (i) {
                        return DropdownMenuItem(
                          value: i,
                          child: Text(cubit!.rentalItems[i].name!.sentenceCase),
                        );
                      }),
                      onChanged: (value) {
                        cubit?.selectedVehicleindex = value;
                        selectedVehicleText = cubit!
                            .rentalItems[cubit!.selectedVehicleindex!].name
                            .toString();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
