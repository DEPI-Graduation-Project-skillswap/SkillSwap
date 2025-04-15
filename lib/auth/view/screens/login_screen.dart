import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/auth/view_model/auth_state.dart';
import 'package:skill_swap/auth/view_model/auth_view_model.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/auth/view/screens/register_screen.dart';
import 'package:skill_swap/landing/landing_page1.dart';
import 'package:skill_swap/shared/app_validator.dart';
import 'package:skill_swap/shared/ui_utils.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';
import 'package:skill_swap/widgets/default_text_form_fieled.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextTheme.of(context).titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/logo 1.png'),
                Text(
                  'Welcome to SkillSwap',
                  style: TextTheme.of(
                    context,
                  ).titleLarge!.copyWith(color: Apptheme.textColor),
                ),
                Text('Connect, learn, and grow together '),
                SizedBox(height: 20),
                DefaultTextFormFieled(
                  hintText: 'Enter your email',
                  icon: Icons.email,
                  label: 'Email ',
                  isPassword: false,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email can not be empty';
                    } else if (!AppValidator.isEmailValid(value)) {
                      return "Invalid Email format";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DefaultTextFormFieled(
                  hintText: 'Enter password',
                  icon: Icons.lock,
                  label: 'Password',
                  isPassword: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'PassWord Must be atleast 6 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                BlocListener<AuthViewModel, AuthState>(
                  listener: (_, state) {
                    if (state is LoginLoading) {
                      UiUtils.showLoading(context);
                    } else if (state is LoginError) {
                      UiUtils.hideLoading(context);
                      UiUtils.showSnackBar(context, state.message);
                    } else if (state is LoginSuccess) {
                      UiUtils.hideLoading(context);
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(LandingPage1.routeName);
                    }
                  },
                  child: DefaultElevetedBotton(onPressed: login, text: 'Login'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot password ?',
                    style: TextTheme.of(context).titleSmall,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(RegisterScreen.routeName);
                  },
                  child: Text(
                    'Don\'t have an account? Create an account',
                    style: TextTheme.of(context).titleSmall,
                  ),
                ),

                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextTheme.of(
                    context,
                  ).titleSmall!.copyWith(color: Apptheme.hintTextColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    FocusScope.of(context).unfocus();
    print('email: "${emailController.text}"');
    print('zzzzzzzzzzzzzzzzzzzzzzzzz');
    print('password: "${passwordController.text}"');
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthViewModel>(
        context,
      ).login(email: emailController.text, password: passwordController.text);
    }
  }
}
