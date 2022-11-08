part of 'hotel_detail_cubit.dart';

@immutable
abstract class HotelDetailState {}

class HotelDetailInitial extends HotelDetailState {}

class HotelDetailLoading extends HotelDetailState {}

class HotelDetailLoaded extends HotelDetailState {}

class HotelDetailError extends HotelDetailState {
  final String errorMessage;

  HotelDetailError(this.errorMessage);
}
