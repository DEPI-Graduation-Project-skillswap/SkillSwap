import 'package:flutter/material.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/auth/register_screen.dart';
import 'package:skill_swap/landing/landing_page1.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';
import 'package:skill_swap/widgets/default_text_form_fieled.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                  hintText: 'Enter your email or number',
                  icon: Icons.email,
                  label: 'Email or Phone number',
                  isPassword: false,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Enter a valid email';
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
                DefaultElevetedBotton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(LandingPage1.routeName);
                    }
                  },
                  text: 'Login',
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
}
