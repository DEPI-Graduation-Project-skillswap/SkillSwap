import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/auth/view_model/auth_state.dart';
import 'package:skill_swap/auth/view_model/auth_view_model.dart';
import 'package:skill_swap/landing/landing_page1.dart';
import 'package:skill_swap/shared/app_theme.dart';
import 'package:skill_swap/auth/view/screens/login_screen.dart';

import 'package:skill_swap/shared/app_validator.dart';
import 'package:skill_swap/shared/ui_utils.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';
import 'package:skill_swap/widgets/default_text_form_fieled.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextTheme.of(context).titleLarge),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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

                      SizedBox(height: 20),
                      DefaultTextFormFieled(
                        hintText: 'Enter your email',
                        icon: Icons.email,
                        label: "Email",
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
                        hintText: 'Enter your Password',
                        icon: Icons.lock,
                        label: "Password",
                        isPassword: true,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password can not be less than 6 charactar';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DefaultTextFormFieled(
                        hintText: 'Rewrite your Password',
                        icon: Icons.lock,
                        label: "Confirm Password",
                        isPassword: true,
                        controller: repasswordController,
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),
                      BlocListener<AuthViewModel, AuthState>(
                        listener: (_, state) {
                          if (state is RegisterLoading) {
                            UiUtils.showLoading(context);
                          } else if (state is RegisterError) {
                            UiUtils.hideLoading(context);
                            UiUtils.showSnackBar(context, state.message);
                          } else if (state is RegisterSuccess) {
                            UiUtils.hideLoading(context);
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(LandingPage1.routeName);
                          }
                        },
                        child: DefaultElevetedBotton(
                          onPressed: register,
                          text: "Register",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(LoginScreen.routeName);
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: TextTheme.of(
                            context,
                          ).titleSmall!.copyWith(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthViewModel>(context).register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }
}
