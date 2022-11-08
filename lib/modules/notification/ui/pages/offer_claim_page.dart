import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/modules/notification/model/notification.dart'
    as Notification;

import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/offerclaim/offer_claim_cubit.dart';

class OfferClaimPage extends StatelessWidget {
  const OfferClaimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OfferClaimCubit(),
      child: const OfferClaimBody(),
    );
  }
}

class OfferClaimBody extends StatefulWidget {
  const OfferClaimBody({super.key});

  @override
  _OfferClaimBodyState createState() => _OfferClaimBodyState();
}

class _OfferClaimBodyState extends State<OfferClaimBody> {
  Notification.Notification? notification;

  @override
  void initState() {
    super.initState();
    notification = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    final OfferClaimCubit cubit = BlocProvider.of<OfferClaimCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Offer for you",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    notification!.notificationHeader.toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                      height: 200,
                      child: showNetworkImage(
                        notification!.bannerImage.toString(),
                      )),
                  const SizedBox(height: 20.0),
                  Text(notification!.notificationDescription.toString()),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: BlocBuilder<OfferClaimCubit, OfferClaimState>(
              builder: (context, state) {
                if (state is OfferClaimSuccess) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      color: MyTheme.primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.5),
                    child: Center(
                      child: Text(
                        "Offer claimed",
                        style: MyTheme.mainTextTheme.headline4
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                } else if (state is OfferClaimLoading) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      color: MyTheme.primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.5),
                    child: const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    cubit.claimOffer(notification!.promotionId!.toInt(),
                        notification!.module.toString());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      color: MyTheme.primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.5),
                    child: Center(
                      child: Text(
                        "Claim this offer",
                        style: MyTheme.mainTextTheme.headline4
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
