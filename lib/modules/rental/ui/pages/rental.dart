import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/dotIndicators.dart';
import '../../../../configs/theme.dart';
import '../../model/rental_booking_detail_parameters.dart';
import '../../services/cubit/rental/rental_cubit.dart';
import '../../services/cubit/rental_list/rental_list_cubit.dart';
import '../../services/cubit/rental_offer/rental_offer_cubit.dart';
import '../widgets/rentalOffer.dart';
import '../widgets/rentalOfferShimmer.dart';
import '../widgets/rentalPageShimmer.dart';
import '../widgets/rentalShimmer.dart';
import '../widgets/rentalW.dart';
import '../widgets/singleRental.dart';

class RentalPage extends StatelessWidget {
  const RentalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => RentalCubit()..getInitialData()),
        BlocProvider(
            create: (BuildContext context) =>
                RentalListCubit()..getRentalList()),
        BlocProvider(
            create: (BuildContext context) =>
                RentalOfferCubit()..getRentalOffers())
      ],
      child: const RentalBody(),
    );
  }
}

class RentalBody extends StatefulWidget {
  const RentalBody({super.key});

  @override
  _RentalBodyState createState() => _RentalBodyState();
}

class _RentalBodyState extends State<RentalBody> {
  final searchTextController = TextEditingController();

  ValueNotifier<int>? currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    final RentalCubit rentalCubit = BlocProvider.of<RentalCubit>(context);
    final RentalListCubit rentalListCubit =
        BlocProvider.of<RentalListCubit>(context);
    final RentalOfferCubit rentalOfferCubit =
        BlocProvider.of<RentalOfferCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Rent Vehicles",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            RentalBookingDetailParameters parameters =
                locator<RentalBookingDetailParameters>();
            parameters.clearAllField();

            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<RentalCubit, RentalState>(
                  builder: (context, state) {
                    if (state is RentalLoaded) {
                      return RentalW(rentalCubit: rentalCubit);
                    }
                    return RentalPageShimmer();
                  },
                ),
                BlocBuilder<RentalOfferCubit, RentalOfferState>(
                  builder: (context, state) {
                    if (state is RentalOfferLoaded) {
                      return RentalOffer(rentalOfferCubit: rentalOfferCubit);
                    } else if (state is RentalOfferNone) {
                      return const SizedBox();
                    }
                    return RentalOffersShimmer();
                  },
                ),
                BlocBuilder<RentalListCubit, RentalListState>(
                  builder: (context, state) {
                    if (state is RentalListLoaded) {
                      if (rentalListCubit.rentalList.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Rent Vehicles",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: const BoxDecoration(),
                            clipBehavior: Clip.antiAlias,
                            child: CarouselSlider(
                              items: List<Widget>.generate(
                                rentalListCubit.rentalList.length,
                                (int i) => SingleRental(
                                    rental: rentalListCubit.rentalList[i]),
                              ),
                              options: CarouselOptions(
                                autoPlay: true,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                viewportFraction: 1,
                                enlargeCenterPage: false,
                                onPageChanged: (i, reason) {
                                  currentIndex?.value = i;
                                },
                              ),
                            ),
                          ),
                          DotIndicatorWidget(
                            dotCount: rentalListCubit.rentalList.length,
                            currentIndex: currentIndex!,
                            activeColor: MyTheme.primaryColor,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }

                    return Column(
                      children: const [
                        RentalShimmer(),
                        SizedBox(height: 30),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
