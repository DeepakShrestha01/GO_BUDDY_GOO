part of 'booking_cubit.dart';

@immutable
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingInitialLoading extends BookingState {}

class CompletedBookingLoaded extends BookingState {}

class UpcomingBookingLoaded extends BookingState {}

class CancelledBookingLoaded extends BookingState {}

class BookingError extends BookingState {}
