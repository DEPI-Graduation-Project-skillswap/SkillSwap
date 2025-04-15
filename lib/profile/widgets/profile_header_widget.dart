// ignore: unused_import
import 'dart:io'; // Make sure this import is present
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/profile/cubits/profile_cubit.dart'; // Correct Cubit dependency

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to react to ProfileCubit state changes
    return BlocBuilder<ProfileCubit, ProfileState>(
      // Optional but good practice: only rebuild if name or image changes
      buildWhen: (previous, current) =>
          previous.fullName != current.fullName ||
          previous.profileImage?.path != current.profileImage?.path, // Compare paths for safety
      builder: (context, state) {
        // 'state' now holds the ProfileState managed by ProfileCubit
        print("ProfileHeaderWidget rebuilding. Image path: ${state.profileImage?.path}"); // Debug print

        return Column(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Background color for when image is null or loading
                  color: Apptheme.gray.withOpacity(0.3),
                  image: state.profileImage != null
                      ? DecorationImage(
                          // Use FileImage for loading image from a File object
                          image: FileImage(state.profileImage!),
                          fit: BoxFit.cover,
                          // Optional: Add error handling for image loading
                          onError: (exception, stackTrace) {
                             print("Error loading profile image: $exception");
                             // You could potentially update state here or show a fallback
                          },
                        )
                      : null, // No image if state.profileImage is null
                  border: Border.all(
                    color: Apptheme.primaryColor.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                // Show placeholder icon ONLY if profileImage is null
                child: state.profileImage == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Apptheme.gray, // Use a theme color
                      )
                    : null, // Otherwise, show nothing (image is the background)
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                // Display fullName from the state. Add fallback if empty.
                state.fullName.isNotEmpty ? state.fullName : "Your Name",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Apptheme.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            // This "Verified User" badge seems static for now.
            // If verification status comes from the state later, update this part.
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Apptheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Apptheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user,
                          size: 16,
                          color: Apptheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified User', // Keep static for now
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Apptheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add other potential badges or info here if needed
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}