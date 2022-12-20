import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo/modules/rental/ui/widgets/rentalOfferCarousel.dart';

import '../../../../common/widgets/dotIndicators.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/rental_offer/rental_offer_cubit.dart';

class RentalOffer extends StatefulWidget {
  final RentalOfferCubit? rentalOfferCubit;

  const RentalOffer({Key? key, this.rentalOfferCubit}) : super(key: key);

  @override
  _RentalOfferState createState() => _RentalOfferState();
}

class _RentalOfferState extends State<RentalOffer> {
  ValueNotifier<int>? currentIndexRentalOffers;

  @override
  void initState() {
    super.initState();
    currentIndexRentalOffers = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Rental with discounts",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed("/rentalOffers");
              },
              child: const Text(
                "View all >>",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        RentalOfferCarousel(
          currentIndex: currentIndexRentalOffers!,
          offers: widget.rentalOfferCubit!.rentalOffers,
        ),
        const SizedBox(height: 10),
        Center(
          child: DotIndicatorWidget(
            dotCount: widget.rentalOfferCubit!.rentalOffers.length,
            currentIndex: currentIndexRentalOffers!,
            activeColor: MyTheme.primaryColor,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
