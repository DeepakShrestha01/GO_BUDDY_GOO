part of 'int_check_cubit.dart';

@immutable
abstract class IntCheckState {}

class IntCheckInitial extends IntCheckState {}
class IntCheckGainedState extends IntCheckState {}
class IntCheckLostState extends IntCheckState {}
