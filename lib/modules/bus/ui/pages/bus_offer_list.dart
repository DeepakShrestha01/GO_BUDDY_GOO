import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../services/cubit/bus_offer/bus_offer_cubit.dart';
import '../widgets/singlebusoffer_widget.dart';

class BusOfferListPage extends StatelessWidget {
  const BusOfferListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BusOfferCubit()..getAllBusOffers(),
      child: const BusOfferListBody(),
    );
  }
}

class BusOfferListBody extends StatefulWidget {
  const BusOfferListBody({super.key});

  @override
  _BusOfferListBodyState createState() => _BusOfferListBodyState();
}

class _BusOfferListBodyState extends State<BusOfferListBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BusOfferCubit busOfferCubit = BlocProvider.of<BusOfferCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Bus with Discounts",
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
      ),
      body: BlocBuilder<BusOfferCubit, BusOfferState>(
        builder: (BuildContext context, state) {
          if (state is BusOfferLoaded) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: busOfferCubit.busOffers.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemBuilder: (BuildContext context, int i) {
                return Material(
                  elevation: 5,
                  child: SingleBusOfferWidget(
                      busoffer: busOfferCubit.busOffers[i]),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 25),
            );
          } else if (state is BusOfferNone) {
            return const Center(child: Text("No offers found!"));
          } else if (state is BusOfferError) {
            return const Center(
                child: Text("Error loading bus with discounts"));
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
