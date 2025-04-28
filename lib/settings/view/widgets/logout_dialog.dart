import 'package:flutter/material.dart';
import 'package:skill_swap/shared/app_theme.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key, required this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Confirem Logout",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text(
        'Are you sure you want to logout from SKillSwap?',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Apptheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
