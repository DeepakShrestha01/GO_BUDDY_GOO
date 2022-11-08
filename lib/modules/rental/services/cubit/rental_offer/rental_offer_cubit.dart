import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../model/rental_offer.dart';

part 'rental_offer_state.dart';

class RentalOfferCubit extends Cubit<RentalOfferState> {
  RentalOfferCubit() : super(RentalOfferInitial());

  List<RentalOffer> rentalOffers = [];

  getRentalOffers() async {
    emit(RentalOfferLoading());

    FormData formData = FormData.fromMap({"page": 1, "page_limit": 10});

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/discount_offer/rental/list/",
      data: formData,
    );

    if (response.statusCode == 200) {
      if (response.data["status"] == "fail") {
        emit(RentalOfferNone());
      }

      if (response.data["discount_offer_rental_list"] != null) {
        for (var x in response.data["discount_offer_rental_list"]) {
          rentalOffers.add(RentalOffer.fromJson(x));
        }
      }

      if (rentalOffers.isEmpty) {
        emit(RentalOfferNone());
      } else {
        emit(RentalOfferLoaded());
      }
    } else {
      emit(RentalOfferError());
    }
  }

  getAllRentalOffers() async {
    emit(RentalOfferLoading());

    FormData formData = FormData.fromMap({"page": 1, "page_limit": 100});

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/discount_offer/rental/list/",
      data: formData,
    );

    if (response.statusCode == 200) {
      for (var x in response.data["discount_offer_rental_list"]) {
        rentalOffers.add(RentalOffer.fromJson(x));
      }

      if (rentalOffers.isEmpty) {
        emit(RentalOfferNone());
      } else {
        emit(RentalOfferLoaded());
      }
    } else {
      emit(RentalOfferError());
    }
  }
}
