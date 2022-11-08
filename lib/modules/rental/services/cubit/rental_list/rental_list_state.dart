part of 'rental_list_cubit.dart';

@immutable
abstract class RentalListState {}

class RentalListInitial extends RentalListState {}

class RentalListLoading extends RentalListState {}

class RentalListLoaded extends RentalListState {}

class RentalListError extends RentalListState {}
