import 'package:bloc/bloc.dart';
import 'package:fitness/features/auth/domian/entites/user_entity.dart';
import 'package:fitness/features/auth/domian/repo/auth_repo.dart';

import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepo authRepo;
  SignInCubit(this.authRepo) : super(SignInInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(SignInLoadingState());
    final result = await authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    result.fold(
      (faileur) {
        emit(SignInFailState(faileur.message));
      },
      (user) {
        emit(SignInSuccessState(user));
      },
    );
  }

  // Future<void> signInWithGoogle() async {
  //   emit(SignInLoadingState());
  //   final result = await authRepo.signInWithGoogle();
  //   result.fold(
  //     (error) {
  //       emit(SignInFailState(error.message));
  //     },
  //     (user) {
  //       emit(SignInSuccessState(user));
  //     },
  //   );
  // }

  Future<void> signInWithFacebook() async {
    emit(SignInLoadingState());
    final result = await authRepo.signInWithFacebook();
    result.fold(
      (error) {
        emit(SignInFailState(error.message));
      },
      (user) {
        emit(SignInSuccessState(user));
      },
    );
  }
}
