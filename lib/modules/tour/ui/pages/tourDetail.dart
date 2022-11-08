import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../servies/cubit/tour_detail/tour_detail_cubit.dart';
import '../widgets/tourDetail.dart';

class TourDetailPage extends StatelessWidget {
  const TourDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TourDetailCubit()..getTourDetail(Get.arguments),
      child: const TourDetailBody(),
    );
  }
}

class TourDetailBody extends StatefulWidget {
  const TourDetailBody({super.key});

  @override
  _TourDetailBodyState createState() => _TourDetailBodyState();
}

class _TourDetailBodyState extends State<TourDetailBody> {
  @override
  Widget build(BuildContext context) {
    final TourDetailCubit tourDetailCubit =
        BlocProvider.of<TourDetailCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tour Detail",
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
      body: BlocBuilder<TourDetailCubit, TourDetailState>(
        builder: (context, state) {
          if (state is TourDetailLoaded) {
            return TourDetail(tourDetailCubit.tour);
          } else if (state is TourDetailError) {
            return const Center(child: Text("Error loading details"));
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
