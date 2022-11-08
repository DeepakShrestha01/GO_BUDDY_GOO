part of 'tour_booking_detail_cubit.dart';

@immutable
abstract class TourBookingDetailState {}

class TourBookingDetailInitial extends TourBookingDetailState {}

class BookingDetailLoading extends TourBookingDetailState {}

class BookingDetailError extends TourBookingDetailState {}

class BookingDetailLoaded extends TourBookingDetailState {}

class TourPaymentInitial extends TourBookingDetailState {}

class TourPaymentSuccess extends TourBookingDetailState {}

class TourPaymentLoading extends TourBookingDetailState {}

class TourPaymentError extends TourBookingDetailState {}
