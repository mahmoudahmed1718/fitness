part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {
  final UserEntity user;

  SignInSuccessState(this.user);
}

class SignInFailState extends SignInState {
  final String error;

  SignInFailState(this.error);
}
