import 'package:flutter/material.dart';
import 'package:skill_swap/auth/loading_indecator.dart';
import 'package:skill_swap/shared/app_theme.dart';

class UiUtils {
  static void showLoading(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingIndecator(),
                  const SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
  );
  static void hideLoading(BuildContext context) => Navigator.of(context).pop();
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color color = Apptheme.red,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }
}
