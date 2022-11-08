part of 'bus_offer_cubit.dart';

@immutable
abstract class BusOfferState {}

class BusOfferInitial extends BusOfferState {}

class BusOfferError extends BusOfferState {}

class BusOfferLoading extends BusOfferState {}

class BusOfferLoaded extends BusOfferState {}

class BusOfferNone extends BusOfferState {}
