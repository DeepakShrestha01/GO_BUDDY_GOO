part of 'flight_reserve_cubit.dart';

@immutable
abstract class FlightReserveState {}

class FlightReserveInitial extends FlightReserveState {}

class FlightReserveLoading extends FlightReserveState {}

class FlightReserveError extends FlightReserveState {}

class FlightReserveSuccess extends FlightReserveState {}

class FlightReservePayment extends FlightReserveState {}

class FlightReservePaymentProcessing extends FlightReserveState {}
