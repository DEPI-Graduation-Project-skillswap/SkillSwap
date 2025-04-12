import 'package:flutter/material.dart';
import 'package:skill_swap/app_theme.dart';

class DefaultElevetedBotton extends StatelessWidget {
  const DefaultElevetedBotton({
    super.key,
    required this.onPressed,
    required this.text,
  });
  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Apptheme.primaryColor,
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextTheme.of(
          context,
        ).titleMedium!.copyWith(color: Apptheme.white),
      ),
    );
  }
}
