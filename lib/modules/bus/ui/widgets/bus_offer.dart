import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo_mobile/modules/bus/ui/widgets/bus_offer_carousel.dart';

import '../../../../common/widgets/dotIndicators.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/bus_offer/bus_offer_cubit.dart';

class BusOffer extends StatefulWidget {
  final BusOfferCubit busOfferCubit;

  const BusOffer({Key? key, required this.busOfferCubit}) : super(key: key);

  @override
  _BusOfferState createState() => _BusOfferState();
}

class _BusOfferState extends State<BusOffer> {
  ValueNotifier<int>? currentIndexBusOffers;

  @override
  void initState() {
    super.initState();
    currentIndexBusOffers = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Bus with Discounts",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed("/busOffers");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3.5,
                ),
                child: const Text(
                  "View All >>",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        widget.busOfferCubit.busOffers.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Center(child: Text("No offers found!")))
            : Column(
                children: [
                  BusOfferCarousel(
                    currentIndex: currentIndexBusOffers!,
                    offers: widget.busOfferCubit.busOffers,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: DotIndicatorWidget(
                      dotCount: widget.busOfferCubit.busOffers.length,
                      currentIndex: currentIndexBusOffers!,
                      activeColor: MyTheme.primaryColor,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
