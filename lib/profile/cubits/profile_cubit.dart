// profile/cubits/profile_cubit.dart
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/profile/models/skill_category.dart';
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart'; // Import setup state

// ProfileState definition remains the same

class ProfileCubit extends Cubit<ProfileState> {
  // Modify constructor to accept optional initial data
  ProfileCubit({ProfileSetupState? initialData})
    : super(const ProfileState(isLoading: true)) {
    if (initialData != null) {
      // If initial data is provided, initialize the state directly
      print("ProfileCubit: Initializing with data from setup.");
      emit(
        ProfileState(
          fullName: initialData.fullName,
          bio: initialData.bio,
          profileImage:
              initialData.profileImage, // Use the File object directly
          offeredSkills: List.from(
            initialData.selectedOfferedSkills,
          ), // Create copies
          desiredSkills: List.from(
            initialData.selectedDesiredSkills,
          ), // Create copies
          skillCategories:
              const [], // Categories aren't part of setup state, load separately if needed
          isLoading: false, // Data is already loaded
          errorMessage: '',
        ),
      );
      // Optionally load categories separately if needed on profile page
      // loadSkillCategories();
    } else {
      // If no initial data, load profile using the old method (simulated/API call)
      print("ProfileCubit: No initial data, calling loadProfile.");
      loadProfile();
    }
  }

  // Method to load profile data from storage/API (fallback)
  Future<void> loadProfile() async {
    // Only proceed if state is currently loading (avoids reloading if initialized with data)
    if (!state.isLoading) {
      print(
        "ProfileCubit: loadProfile called but not in loading state, skipping.",
      );
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
      print("ProfileCubit: Simulating profile load from storage/API...");
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Simulated data (used if no initialData was provided)
      final userData = {
        'fullName': 'Jane Smith (Default)', // Default data
        'bio': 'Passionate learner exploring new skills.',
        'profileImage': null,
        'offeredSkills': ['Placeholder Skill 1'],
        'desiredSkills': ['Placeholder Skill 2'],
      };

      final List<SkillCategory> skillCategories = [
        SkillCategory(
          name: 'Default Category',
          skills: ['Placeholder Skill 1', 'Placeholder Skill 2'],
        ),
      ]; // Load categories if needed

      emit(
        state.copyWith(
          fullName: userData['fullName'] as String,
          bio: userData['bio'] as String,
          profileImage: null,
          offeredSkills: List<String>.from(userData['offeredSkills'] as List),
          desiredSkills: List<String>.from(userData['desiredSkills'] as List),
          skillCategories: skillCategories,
          isLoading: false,
        ),
      );
    } catch (e) {
      print("ProfileCubit: Error loading profile: $e");
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load profile: $e',
        ),
      );
    }
  }

  // Optional: Separate method to load categories if needed regardless of init method
  // Future<void> loadSkillCategories() async { ... }

  // Update methods remain the same
  void updateFullName(String name) {
    /* ... */
  }
  void updateBio(String bio) {
    /* ... */
  }
  void updateProfileImage(File image) {
    /* ... */
  }
  void updateOfferedSkills(List<String> skills) {
    /* ... */
  }
  void updateDesiredSkills(List<String> skills) {
    /* ... */
  }
}

// Ensure ProfileState is defined correctly (as you provided)
class ProfileState extends Equatable {
  final String fullName;
  final String bio;
  final File? profileImage; // Keep as File?
  final List<String> offeredSkills;
  final List<String> desiredSkills;
  final List<SkillCategory> skillCategories;
  final bool isLoading;
  final String errorMessage;

  const ProfileState({
    this.fullName = '',
    this.bio = '',
    this.profileImage,
    this.offeredSkills = const [],
    this.desiredSkills = const [],
    this.skillCategories = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  ProfileState copyWith({
    String? fullName,
    String? bio,
    File? profileImage,
    bool clearProfileImage = false,
    List<String>? offeredSkills,
    List<String>? desiredSkills,
    List<SkillCategory>? skillCategories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      profileImage:
          clearProfileImage ? null : (profileImage ?? this.profileImage),
      offeredSkills: offeredSkills ?? this.offeredSkills,
      desiredSkills: desiredSkills ?? this.desiredSkills,
      skillCategories: skillCategories ?? this.skillCategories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    bio,
    profileImage?.path, // Compare path for Equatable
    offeredSkills,
    desiredSkills,
    skillCategories,
    isLoading,
    errorMessage,
  ];
}
