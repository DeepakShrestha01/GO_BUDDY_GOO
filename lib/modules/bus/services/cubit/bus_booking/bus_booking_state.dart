part of 'bus_booking_cubit.dart';

@immutable
abstract class BusBookingState {}

class BusBookingInitial extends BusBookingState {}

class BusBookingLoading extends BusBookingState {}

class BusBookingError extends BusBookingState {}

class BusBookingSuccess extends BusBookingState {}

class BusBookingPaymentInitial extends BusBookingState {}

class BusBookingPaymentLoading extends BusBookingState {}

class BusBookingPaymentError extends BusBookingState {}

class BusBookingPaymentSuccess extends BusBookingState {}
