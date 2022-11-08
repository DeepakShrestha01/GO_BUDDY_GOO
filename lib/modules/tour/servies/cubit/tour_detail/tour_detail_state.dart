part of 'tour_detail_cubit.dart';

@immutable
abstract class TourDetailState {}

class TourDetailInitial extends TourDetailState {}

class TourDetailLoading extends TourDetailState {}

class TourDetailLoaded extends TourDetailState {}

class TourDetailError extends TourDetailState {}
