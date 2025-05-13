import 'package:flutter/material.dart';
import 'package:skill_swap/shared/app_theme.dart';

class LoadingIndecator extends StatelessWidget {
  const LoadingIndecator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Apptheme.primaryColor),
    );
  }
}
