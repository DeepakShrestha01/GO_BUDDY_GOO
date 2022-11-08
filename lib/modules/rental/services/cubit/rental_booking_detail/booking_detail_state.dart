part of 'booking_detail_cubit.dart';

@immutable
abstract class RentalBookingDetailState {}

class BookingDetailInitial extends RentalBookingDetailState {}

class BookingDetailLoading extends RentalBookingDetailState {}

class BookingDetailError extends RentalBookingDetailState {}

class BookingDetailLoaded extends RentalBookingDetailState {}

class BookingDetailBooking extends RentalBookingDetailState {}
