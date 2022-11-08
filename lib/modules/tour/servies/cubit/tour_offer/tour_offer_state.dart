part of 'tour_offer_cubit.dart';

@immutable
abstract class TourOfferState {}

class TourOfferInitial extends TourOfferState {}

class TourOfferError extends TourOfferState {}

class TourOfferLoading extends TourOfferState {}

class TourOfferLoaded extends TourOfferState {}
