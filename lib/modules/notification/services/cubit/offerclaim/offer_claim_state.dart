part of 'offer_claim_cubit.dart';

@immutable
abstract class OfferClaimState {}

class OfferClaimInitial extends OfferClaimState {}

class OfferClaimLoading extends OfferClaimState {}

class OfferClaimSuccess extends OfferClaimState {}

class OfferClaimError extends OfferClaimState {}
