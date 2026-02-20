import 'package:fitness/constant.dart';
import 'package:fitness/core/utlis/app_colors.dart';
import 'package:fitness/core/utlis/app_text_styles.dart';
import 'package:fitness/core/utlis/assets.dart';
import 'package:fitness/core/widgets/custom_button.dart';
import 'package:fitness/core/widgets/custom_text_form_field.dart';
import 'package:fitness/features/auth/ui/cubits/sign_in_cubits/sign_in_cubit.dart';
import 'package:fitness/features/auth/ui/view/widgets/dont_have_an_account_widget.dart';
import 'package:fitness/features/auth/ui/view/widgets/or_divder.dart';
import 'package:fitness/features/auth/ui/view/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  bool isPasswordVisible = false;
  late String email, password;
  final GlobalKey<FormState> _formKey = GlobalKey();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: khorzintalPadding),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            children: [
              SizedBox(height: 24),
              CustomTextFormField(
                onSaved: (value) => email = value!,
                hintText: 'email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                isObscure: !isPasswordVisible,
                onSaved: (value) => password = value!,
                hintText: 'password',
                textInputType: TextInputType.visiblePassword,
                icon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Color(0XFFC9CFCF),
                  ),
                ),
              ),

              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'forget password?',
                      style: TextStyles.semiBold13.copyWith(
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),

              CustomButton(
                onpressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    context.read<SignInCubit>().signIn(
                      email: email,
                      password: password,
                    );
                  } else {
                    _autovalidateMode = AutovalidateMode.always;
                  }
                },
                text: 'login',
              ),
              const SizedBox(height: 32),
              DontHaveAnAccountWidget(),
              const SizedBox(height: 16),
              const OrDivider(),
              const SizedBox(height: 16),
              SocialLoginButton(
                title: 'login with facebook',
                image: Assets.assetsImagesFacebookIcon,
                onPressed: () {
                  context.read<SignInCubit>().signInWithFacebook();
                },
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                title: 'login with google',
                image: Assets.assetsImagesGoogleIcon,
                onPressed: () {
                  // context.read<SignInCubit>().signInWithGoogle();
                },
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                title: 'login with apple',
                image: Assets.assetsImagesApplIcon,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
