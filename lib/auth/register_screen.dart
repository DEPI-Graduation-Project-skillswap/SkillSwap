import 'package:flutter/material.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/auth/login_screen.dart';

import 'package:skill_swap/auth/verfication_screen.dart';
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
                      DefaultTextFormFieled(
                        hintText: 'Enter your username',
                        icon: Icons.person_2,
                        label: "Username",
                        isPassword: false,
                        controller: nameController,
                        validator: (value) {
                          nameController.text = value ?? '';
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DefaultTextFormFieled(
                        hintText: 'Enter your email or number',
                        icon: Icons.email,
                        label: "Email or Phone number",
                        isPassword: false,
                        controller: emailController,
                        validator: (value) {
                          emailController.text = value ?? '';
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email or number';
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
                          passwordController.text = value ?? '';
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
                          repasswordController.text = value ?? '';
                          if (value != passwordController.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),
                      DefaultElevetedBotton(
                        onPressed: register,
                        text: "Register",
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
      Navigator.of(
        context,
      ).pushNamed(VerficationScreen.routeName, arguments: emailController.text);
    }
  }
}
