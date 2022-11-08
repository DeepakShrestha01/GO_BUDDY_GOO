import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../configs/theme.dart';

part 'tour_inquiry_state.dart';

class TourInquiryCubit extends Cubit<TourInquiryState> {
  TourInquiryCubit() : super(TourInquiryInitial());

  List<String>? hotelTypes = [];
  List<String>? mealTypes = [];

  int? selectedHotelTypesIndex;
  int? selectedMealTypesIndex;

  ValueNotifier<int>? noOfGuests;
  ValueNotifier<int>? noOfDays;

  getHotelTypes() {
    noOfGuests = ValueNotifier(1);
    noOfDays = ValueNotifier(1);

    hotelTypes = ["3-Star", "5-star", "Normal", "Home stay"];
    emit(TourInquiryLoaded());
  }

  getMealTypes() {
    mealTypes = ["Bed & Breakfast", "European", "American", "Chinese"];
    emit(TourInquiryLoaded());
  }

  increaseGuests() {
    noOfGuests?.value++;
    emit(TourInquiryLoaded());
  }

  decreaseGuests() {
    if (noOfGuests!.value > 1) {
      noOfGuests?.value--;
      emit(TourInquiryLoaded());
    }
  }

  increaseDays() {
    noOfDays?.value++;
    emit(TourInquiryLoaded());
  }

  decreaseDays() {
    if (noOfDays!.value > 1) {
      noOfDays?.value--;
      emit(TourInquiryLoaded());
    }
  }

  showGuestCounterDialog(BuildContext context) {
    showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Guests"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: increaseGuests,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(noOfGuests!.value.toString()),
                            ),
                          );
                        },
                        valueListenable: noOfGuests as ValueNotifier,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: decreaseGuests,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: MyTheme.secondaryColor,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      context: context,
      barrierDismissible: true,
    );
  }

  showDaysCounterDialog(BuildContext context) {
    showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Days"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: increaseDays,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(noOfDays!.value.toString()),
                            ),
                          );
                        },
                        valueListenable: noOfDays as ValueNotifier,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: decreaseDays,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: MyTheme.secondaryColor,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      context: context,
      barrierDismissible: true,
    );
  }
}
