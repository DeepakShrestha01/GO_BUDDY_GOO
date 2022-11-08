part of 'rental_cubit.dart';

@immutable
abstract class RentalState {}

class RentalInitial extends RentalState {}

class RentalLoading extends RentalState {}

class RentalLoaded extends RentalState {}

class RentalError extends RentalState {}
