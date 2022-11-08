part of 'tour_theme_cubit.dart';

@immutable
abstract class TourThemeState {}

class TourThemeInitial extends TourThemeState {}

class TourThemeLoading extends TourThemeState {}

class TourThemeLoaded extends TourThemeState {}

class TourThemeError extends TourThemeState {}
