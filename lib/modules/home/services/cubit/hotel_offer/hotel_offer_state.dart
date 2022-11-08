part of 'hotel_offer_cubit.dart';

@immutable
abstract class HotelOffersState {}

class HotelOffersInitial extends HotelOffersState {}

class HotelOffersLoading extends HotelOffersState {}

class HotelOffersNone extends HotelOffersState {}

class HotelOffersLoaded extends HotelOffersState {}

class HotelOffersError extends HotelOffersState {}
