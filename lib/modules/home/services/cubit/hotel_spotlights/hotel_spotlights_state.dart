part of 'hotel_spotlights_cubit.dart';

@immutable
abstract class HotelSpotlightState {}

class HotelSpotlightInitial extends HotelSpotlightState {}

class HotelSpotlightLoading extends HotelSpotlightState {}

class HotelSpotlightNone extends HotelSpotlightState {}

class HotelSpotlightLoaded extends HotelSpotlightState {}

class HotelSpotlightError extends HotelSpotlightState {}
