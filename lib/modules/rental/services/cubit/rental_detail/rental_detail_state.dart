part of 'rental_detail_cubit.dart';

@immutable
abstract class RentalDetailState {}

class RentalDetailInitial extends RentalDetailState {}

class RentalDetailLoading extends RentalDetailState {}

class RentalDetailLoaded extends RentalDetailState {}

class RentalDetailError extends RentalDetailState {}
