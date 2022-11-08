import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../hotel/model/hotel_offer.dart';

part 'hotel_offer_state.dart';

class HotelOfferCubit extends Cubit<HotelOffersState> {
  HotelOfferCubit() : super(HotelOffersInitial());
  List<HotelOffer> hotelOffers = [];

  getHotelOffers() async {
    emit(HotelOffersLoading());

    var response = await DioHttpService()
        .handleGetRequest("booking/api_v_1/hotel_offer/?page=1&limit=10");

    if (response.statusCode == 200) {
      for (var x in response.data["data"]["data"]) {
        hotelOffers.add(HotelOffer.fromJson(x));
      }

      if (hotelOffers.isEmpty) {
        emit(HotelOffersNone());
      } else {
        emit(HotelOffersLoaded());
      }
    } else {
      emit(HotelOffersError());
    }
  }

  getAllHotelOffers() async {
    emit(HotelOffersLoading());

    var response = await DioHttpService()
        .handleGetRequest("booking/api_v_1/hotel_offer/?page=1&limit=100");

    if (response.statusCode == 200) {
      for (var x in response.data["data"]["data"]) {
        hotelOffers.add(HotelOffer.fromJson(x));
      }

      if (hotelOffers.isEmpty) {
        emit(HotelOffersNone());
      } else {
        emit(HotelOffersLoaded());
      }
    } else {
      emit(HotelOffersError());
    }
  }
}
