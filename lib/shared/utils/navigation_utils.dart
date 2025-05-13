import 'package:flutter/material.dart';
import 'package:skill_swap/home_screen.dart';

/// Utility class for navigation-related functions
class NavigationUtils {
  /// Navigate to a specific tab in the home screen
  static void navigateToHomeTab(BuildContext context, int tabIndex) {
    // Navigate to home screen if not already there
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeScreen.routeName,
      (route) => false, // Remove all routes
      arguments: tabIndex, // Pass the tab index as argument
    );
  }
}
