import 'package:flutter/material.dart';

class ProfileInitials extends StatelessWidget {
  final String name;
  final double radius;
  final double fontSize;
  final Color? backgroundColor;
  final Color textColor;
  final BoxBorder? border;

  // Constructor
  const ProfileInitials({
    Key? key,
    required this.name,
    this.radius = 40,
    this.fontSize = 24,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.border,
  }) : super(key: key);

  // Generate a color based on the first character of the name
  Color getColorFromName() {
    if (backgroundColor != null) return backgroundColor!;

    if (name.isEmpty) return Colors.grey;

    // List of vibrant colors for background
    final List<Color> colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.indigoAccent,
      Colors.deepOrangeAccent,
      Colors.lightBlueAccent,
    ];

    // Use the character code of the first letter to pick a color
    final int charCode = name.toLowerCase().codeUnitAt(0);
    return colors[charCode % colors.length];
  }

  // Get the initials from the name (up to 2 characters)
  String getInitials() {
    if (name.isEmpty) return "?";

    final nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      // Get first letter of first and last name
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    } else {
      // Just get first letter for single name
      return nameParts.first[0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: getColorFromName(),
        child: Text(
          getInitials(),
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
