import 'package:flutter/material.dart';
import 'package:skill_swap/shared/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  const DefaultElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backGroundColor,
    this.icon,
    this.width,
  });
  final VoidCallback onPressed;
  final String text;
  final Color? backGroundColor;
  final IconData? icon;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backGroundColor ?? Apptheme.primaryColor,
        fixedSize: Size(width ?? MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            icon == null
                ? [
                  Text(
                    text,
                    style: TextTheme.of(
                      context,
                    ).titleMedium!.copyWith(color: Apptheme.white),
                  ),
                ]
                : [
                  Icon(icon, color: Apptheme.white),
                  SizedBox(width: 5),
                  Text(
                    text,
                    style: TextTheme.of(
                      context,
                    ).titleMedium!.copyWith(color: Apptheme.white),
                  ),
                ],
      ),
    );
  }
}
