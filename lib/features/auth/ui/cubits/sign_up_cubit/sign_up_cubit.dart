import 'package:fitness/features/auth/domian/repo/auth_repo.dart';
import 'package:fitness/features/auth/ui/cubits/sign_up_cubit/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignupState> {
  final AuthRepo authRepo;
  SignUpCubit(this.authRepo) : super(SignupInitialState());
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignupLoadingState());
    final user = await authRepo.createUserWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    user.fold(
      (error) {
        emit(SignupFailState(error: error.message));
      },
      (user) {
        emit(SignupSuccessState(user: user));
      },
    );
  }
}
