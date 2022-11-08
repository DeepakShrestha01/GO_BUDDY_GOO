part of 'bus_detail_cubit.dart';

@immutable
abstract class BusDetailState {}

class BusDetailInitial extends BusDetailState {}

class BusDetailLoading extends BusDetailState {}

class BusDetailLoaded extends BusDetailState {}

class BusDetailError extends BusDetailState {}
