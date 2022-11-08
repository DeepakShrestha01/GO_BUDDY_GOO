import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../services/cubit/rental_detail/rental_detail_cubit.dart';
import '../widgets/rentalDetail.dart';
import '../widgets/rentalTopPart.dart';

class RentalDetailPage extends StatelessWidget {
  const RentalDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RentalDetailCubit(),
      child: const RentalDetailBody(),
    );
  }
}

class RentalDetailBody extends StatefulWidget {
  const RentalDetailBody({super.key});

  @override
  _RentalDetailBodyState createState() => _RentalDetailBodyState();
}

class _RentalDetailBodyState extends State<RentalDetailBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RentalDetailCubit>(context).getVehicleDetail(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    final RentalDetailCubit vehicleDetailCubit =
        BlocProvider.of<RentalDetailCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Vehicle Detail",
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
      body: BlocBuilder<RentalDetailCubit, RentalDetailState>(
        builder: (context, state) {
          if (state is RentalDetailLoaded) {
            return Column(
              children: [
                RentalDetailTopPart(
                  rentalName:
                      "${vehicleDetailCubit.vehicle.vehicleModel?.vehicleBrand?.name} ${vehicleDetailCubit.vehicle.vehicleModel?.model}",
                  reviews: vehicleDetailCubit.vehicle.review,
                ),
                Expanded(
                    child: RentalDetailW(rental: vehicleDetailCubit.vehicle)),
              ],
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
