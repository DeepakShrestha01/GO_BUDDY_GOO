import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../model/bus_booking_detail_parameters.dart';
import '../../services/cubit/bus_detail/bus_detail_cubit.dart';
import '../widgets/bus_detail_loaded.dart';
import '../widgets/bus_parameters_display.dart';

class BusDetailPage extends StatelessWidget {
  const BusDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BusDetailCubit(),
      child: BusDetailBody(),
    );
  }
}

class BusDetailBody extends StatefulWidget {
  const BusDetailBody({super.key});

  @override
  _BusDetailBodyState createState() => _BusDetailBodyState();
}

class _BusDetailBodyState extends State<BusDetailBody> {
  BusBookingDetailParameters? parameters;

  @override
  void initState() {
    super.initState();

    parameters = locator<BusBookingDetailParameters>();

    BlocProvider.of<BusDetailCubit>(context).getBusDetail(
      busId: parameters?.selectedBusId,
      bookingDate:
          DateTimeFormatter.formatDateServer(parameters?.departureDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BusDetailCubit cubit = BlocProvider.of<BusDetailCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bus Detail",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            parameters?.selectedBus = null;
            parameters?.selectedSeats = [];
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
      body: BlocBuilder<BusDetailCubit, BusDetailState>(
        builder: (context, state) {
          if (state is BusDetailLoaded) {
            parameters?.selectedBus = cubit.busDetail;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BusDetailTopPart(
                  date:
                      DateTimeFormatter.formatDate(parameters!.departureDate!),
                  busTag: cubit.busDetail!.busTag.toString(),
                  from: cubit.busDetail!.busFrom!.name.toString(),
                  to: cubit.busDetail!.busTo!.name.toString(),
                  shift: cubit.busDetail!.busShift.toString(),
                  reviews: cubit.busDetail!.vehicleInventory!.review!,
                ),
                const SizedBox(height: 5),
                Expanded(child: BusDetailLoadedW(busDetail: cubit.busDetail)),
              ],
            );
          } else if (state is BusDetailError) {
            return const Center(child: Text("Error loading details"));
          }

          return const Center(child: LoadingWidget());
        },
      ),
    );
  }
}
