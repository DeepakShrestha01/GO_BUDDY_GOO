part of 'hotel_booking_payment_cubit.dart';

@immutable
abstract class GuestDetailAndPaymentState {}

class HotelBookingPaymentInitial extends GuestDetailAndPaymentState {}

class GuestDetailLoading extends GuestDetailAndPaymentState {}

class GuestDetailSuccess extends GuestDetailAndPaymentState {}

class GuestDetailError extends GuestDetailAndPaymentState {}

class PaymentProcessing extends GuestDetailAndPaymentState {}
