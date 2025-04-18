import 'package:flutter/material.dart';
import 'package:skill_swap/shared/app_theme.dart';

class AccountCartElevetedBottom extends StatelessWidget {
  const AccountCartElevetedBottom({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.child,
  });

  final VoidCallback? onPressed; // Nullable for disabled state
  final String text;
  final IconData? icon;
  final Widget? child; // Allows showing loading spinners

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
      color: Apptheme.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Apptheme.primaryColor,
        fixedSize: Size(MediaQuery.of(context).size.width * .3, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child:
          child ??
          (icon != null
              ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Apptheme.white),
                  const SizedBox(width: 4),
                  Text(text, style: textStyle),
                ],
              )
              : Text(text, style: textStyle)),
    );
  }
}
