import 'package:fitness/core/services/get_it_service.dart';
import 'package:fitness/features/auth/domian/repo/auth_repo.dart';
import 'package:fitness/features/auth/ui/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:fitness/features/auth/ui/view/widgets/sign_up_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const String routeName = '/signUp';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(getIt<AuthRepo>()),
      child: Scaffold(appBar: AppBar(), body: SignUpViewBodyBlocConsumer()),
    );
  }
}
