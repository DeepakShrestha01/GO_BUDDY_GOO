part of 'check_phone_number_cubit.dart';

@immutable
abstract class CheckPhoneNumberState {}

class CheckPhoneNumberInitial extends CheckPhoneNumberState {}

class CheckPhoneNumberLoadingState extends CheckPhoneNumberState {}

class CheckPhoneNumberVerifyingState extends CheckPhoneNumberState {}

class CheckPhoneNumberNotVerifyingState extends CheckPhoneNumberState {}

class CheckPhoneNumberErrorState extends CheckPhoneNumberState {}
