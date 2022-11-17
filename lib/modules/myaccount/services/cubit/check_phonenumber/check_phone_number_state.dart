part of 'check_phone_number_cubit.dart';

@immutable
abstract class CheckPhoneNumberState {}

class CheckPhoneNumberInitial extends CheckPhoneNumberState {}

class CheckPhoneNumberLoadingState extends CheckPhoneNumberState {}

class CheckPhoneNumberVerifyingState extends CheckPhoneNumberState {
  final CheckPhoneNumber response;

  CheckPhoneNumberVerifyingState({required this.response});
}

class CheckPhoneNumberNotVerifyingState extends CheckPhoneNumberState {
 final CheckPhoneNumber response;

  CheckPhoneNumberNotVerifyingState({required this.response});
}

class CheckPhoneNumberErrorState extends CheckPhoneNumberState {
  final String error;

  CheckPhoneNumberErrorState({required this.error});
}
