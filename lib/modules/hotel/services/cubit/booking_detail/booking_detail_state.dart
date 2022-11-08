part of 'booking_detail_cubit.dart';

@immutable
abstract class HotelBookingDetailState {}

class HotelBookingDetailInitial extends HotelBookingDetailState {}

class HotelBookingDetailLoading extends HotelBookingDetailState {}

class HotelBookingDetailError extends HotelBookingDetailState {
  final String error;

  HotelBookingDetailError(this.error);
}

class HotelBookingDetailLoaded extends HotelBookingDetailState {}

class HotelBookingDetailCheckingAvailability extends HotelBookingDetailState {}
