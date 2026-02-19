import 'package:fitness/features/auth/domian/entites/user_entity.dart';

abstract class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {
  final UserEntity user;

  SignupSuccessState({required this.user});
}

class SignupFailState extends SignupState {
  final String error;

  SignupFailState({required this.error});
}
