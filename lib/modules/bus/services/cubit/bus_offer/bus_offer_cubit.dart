import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../model/bus_offer.dart';

part 'bus_offer_state.dart';

class BusOfferCubit extends Cubit<BusOfferState> {
  BusOfferCubit() : super(BusOfferInitial());

  List<BusOffer> busOffers = [];

  getBusOffers() async {
    emit(BusOfferLoading());

    FormData formData = FormData.fromMap({"page": 1, "page_limit": 10});

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/discount_offer/bus/list/",
      data: formData,
    );

    if (response.statusCode == 200) {
      if (response.data["status"] != "fail") {
        for (var x in response.data["discount_offer_bus_list"]) {
          busOffers.add(BusOffer.fromJson(x));
        }

        emit(BusOfferLoaded());
      } else {
        emit(BusOfferNone());
      }
    } else {
      emit(BusOfferError());
    }
  }

  getAllBusOffers() async {
    emit(BusOfferLoading());

    FormData formData = FormData.fromMap({"page": 1, "page_limit": 100});

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/discount_offer/bus/list/",
      data: formData,
    );

    if (response.statusCode == 200) {
      for (var x in response.data["discount_offer_bus_list"]) {
        busOffers.add(BusOffer.fromJson(x));
      }

      if (busOffers.isEmpty) {
        emit(BusOfferNone());
      } else {
        emit(BusOfferLoaded());
      }
    } else {
      emit(BusOfferError());
    }
  }
}
