import 'package:fitness/core/services/get_it_service.dart';
import 'package:fitness/features/auth/domian/repo/auth_repo.dart';
import 'package:fitness/features/auth/ui/cubits/sign_in_cubits/sign_in_cubit.dart';
import 'package:fitness/features/auth/ui/view/widgets/sign_in_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  static const String routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(getIt.get<AuthRepo>()),
      child: Scaffold(appBar: AppBar(), body: SignInViewBodyBlocConsumer()),
    );
  }
}
