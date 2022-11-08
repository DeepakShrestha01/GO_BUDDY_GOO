part of 'tour_inquiry_cubit.dart';

@immutable
abstract class TourInquiryState {}

class TourInquiryInitial extends TourInquiryState {}

class TourInquiryError extends TourInquiryState {}

class TourInquiryLoading extends TourInquiryState {}

class TourInquiryLoaded extends TourInquiryState {}
