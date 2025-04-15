import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_swap/app_theme.dart'; // Assuming Apptheme is defined here
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    // Use context.read safely within the async gap if context might become invalid
    // Store the Cubit instance before the async operation
    final cubit = context.read<ProfileSetupCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context); // Store ScaffoldMessenger too

    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        debugPrint('Image picked, path: ${pickedFile.path}');
        final imageFile = File(pickedFile.path);

        // Update state in the cubit using the stored instance
        cubit.setProfileImage(imageFile);

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      // Only rebuild when the profileImage changes
      buildWhen: (previous, current) => previous.profileImage != current.profileImage,
      builder: (context, state) {
        debugPrint('ProfilePictureWidget BUILDER: Image path: ${state.profileImage?.path ?? "none"}');

        return Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bottomSheetContext) { // Use a different context name
                      return SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Choose from Gallery'),
                              onTap: () {
                                Navigator.pop(bottomSheetContext);
                                // Pass the main build context to _pickImage
                                _pickImage(context, ImageSource.gallery);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Take a Photo'),
                              onTap: () {
                                Navigator.pop(bottomSheetContext);
                                // Pass the main build context to _pickImage
                                _pickImage(context, ImageSource.camera);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Apptheme.gray.withOpacity(0.3),
                        image: state.profileImage != null
                            ? DecorationImage(
                                // Use FileImage and add error handling
                                image: FileImage(state.profileImage!),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {
                                  // Log error if image fails to load
                                  debugPrint("Error loading profile image file: $exception");
                                  // Optionally show an error icon or fallback
                                  // Consider showing a snackbar here too via context.read
                                },
                              )
                            : null, // No image if profileImage is null
                      ),
                      // Show icon only if profileImage is null
                      child: state.profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Apptheme.gray,
                            )
                          : null, // Important: child should be null when image is shown
                    ),
                    // Edit Icon Overlay
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Apptheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Apptheme.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Apptheme.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Text and Checkmark Row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Upload Profile Picture',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  // Show checkmark if image is selected
                  if (state.profileImage != null)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.check_circle, color: Colors.green, size: 16),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}