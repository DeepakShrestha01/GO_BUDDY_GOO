part of 'rental_offer_cubit.dart';

@immutable
abstract class RentalOfferState {}

class RentalOfferInitial extends RentalOfferState {}

class RentalOfferError extends RentalOfferState {}

class RentalOfferNone extends RentalOfferState {}

class RentalOfferLoading extends RentalOfferState {}

class RentalOfferLoaded extends RentalOfferState {}
