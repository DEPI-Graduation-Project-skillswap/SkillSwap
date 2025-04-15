import 'dart:convert';
import 'dart:io'; // <-- Import for File type
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:equatable/equatable.dart'; // Import equatable
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/profile/models/skill_category.dart'; // Assuming exists
import 'package:skill_swap/profile/cubits/profile_cubit.dart'; // Import ProfileState

// Make state equatable for potentially better BlocBuilder comparisons
class ProfileSetupState extends Equatable {
  final List<SkillCategory> skillCategories;
  final List<String> skillOptions;
  final List<String> filteredOfferedSkills;
  final List<String> filteredDesiredSkills;
  final List<String> selectedOfferedSkills;
  final List<String> selectedDesiredSkills;
  final File? profileImage;
  final String fullName;
  final String bio;
  final bool isLoading;
  final String errorMessage;

  const ProfileSetupState({
    // Use const constructor
    this.skillCategories = const [], // Default to empty lists
    this.skillOptions = const [],
    this.filteredOfferedSkills = const [],
    this.filteredDesiredSkills = const [],
    this.selectedOfferedSkills = const [],
    this.selectedDesiredSkills = const [],
    this.profileImage,
    this.fullName = '', // Default to empty strings
    this.bio = '',
    this.isLoading = false, // Default isLoading to false initially
    this.errorMessage = '',
  });

  ProfileSetupState copyWith({
    List<SkillCategory>? skillCategories,
    List<String>? skillOptions,
    List<String>? filteredOfferedSkills,
    List<String>? filteredDesiredSkills,
    List<String>? selectedOfferedSkills,
    List<String>? selectedDesiredSkills,
    File? profileImage, // Keep File? as nullable
    bool clearProfileImage =
        false, // Add flag to explicitly clear image if needed
    String? fullName,
    String? bio,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileSetupState(
      skillCategories: skillCategories ?? this.skillCategories,
      skillOptions: skillOptions ?? this.skillOptions,
      filteredOfferedSkills:
          filteredOfferedSkills ?? this.filteredOfferedSkills,
      filteredDesiredSkills:
          filteredDesiredSkills ?? this.filteredDesiredSkills,
      selectedOfferedSkills:
          selectedOfferedSkills ?? this.selectedOfferedSkills,
      selectedDesiredSkills:
          selectedDesiredSkills ?? this.selectedDesiredSkills,
      // Handle profile image update/clearing
      profileImage:
          clearProfileImage ? null : (profileImage ?? this.profileImage),
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Implement Equatable props
  @override
  List<Object?> get props => [
    skillCategories,
    skillOptions,
    filteredOfferedSkills,
    filteredDesiredSkills,
    selectedOfferedSkills,
    selectedDesiredSkills,
    profileImage
        ?.path, // Compare file path for simplicity, or use file content hash if needed
    fullName,
    bio,
    isLoading,
    errorMessage,
  ];
}

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  // Modify constructor to accept optional EXISTING profile data
  ProfileSetupCubit({ProfileState? existingProfile})
    : super(const ProfileSetupState(isLoading: true)) {
    // Start with loading true
    _initialize(existingProfile: existingProfile);
  }

  // Separate async initialization logic
  Future<void> _initialize({ProfileState? existingProfile}) async {
    // Always load skills data first
    List<SkillCategory> loadedCategories = [];
    List<String> loadedSkillOptions = [];
    String? errorLoadingSkills;

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/skills_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> categoriesJson = jsonData['categories'];
      loadedCategories =
          categoriesJson
              .map((category) => SkillCategory.fromJson(category))
              .toList();
      loadedSkillOptions =
          loadedCategories
              .expand((category) => category.skills)
              .toSet()
              .toList();
      loadedSkillOptions.sort();
    } catch (e) {
      debugPrint('Error loading skills data: $e');
      errorLoadingSkills = 'Failed to load skills. Using defaults. Error: $e';
      // Provide fallback skills if loading fails
      loadedSkillOptions = [
        "Programming",
        "Product Design",
        "Project Management",
        "Data Analysis",
        "UX Research",
        "Content Writing",
        "Digital Marketing",
        "Graphic Design",
        "Photography",
        "Video Editing",
      ];
    }

    // Now, determine the initial state based on whether existingProfile was passed
    if (existingProfile != null) {
      // Editing existing profile: Use data from existingProfile + loaded skills
      debugPrint("ProfileSetupCubit: Initializing for EDIT mode.");
      emit(
        state.copyWith(
          skillCategories: loadedCategories,
          skillOptions: loadedSkillOptions,
          // Pre-fill fields from the existing profile
          fullName: existingProfile.fullName,
          bio: existingProfile.bio,
          profileImage:
              existingProfile.profileImage, // Pass the existing File object
          selectedOfferedSkills: List.from(
            existingProfile.offeredSkills,
          ), // Copy lists
          selectedDesiredSkills: List.from(existingProfile.desiredSkills),
          // Initialize filters based on loaded options initially
          filteredOfferedSkills: List.from(loadedSkillOptions),
          filteredDesiredSkills: List.from(loadedSkillOptions),
          isLoading: false, // Loading complete
          errorMessage:
              errorLoadingSkills ?? '', // Show skill loading error if any
        ),
      );
    } else {
      // First-time setup: Use loaded skills, but fields are empty/default
      debugPrint("ProfileSetupCubit: Initializing for NEW setup mode.");
      emit(
        state.copyWith(
          skillCategories: loadedCategories,
          skillOptions: loadedSkillOptions,
          filteredOfferedSkills: List.from(loadedSkillOptions),
          filteredDesiredSkills: List.from(loadedSkillOptions),
          isLoading: false, // Loading complete
          errorMessage:
              errorLoadingSkills ?? '', // Show skill loading error if any
          // Fields remain default/empty for new setup
        ),
      );
    }
  }

  void filterOfferedSkills(String query) {
    final lowerCaseQuery = query.toLowerCase();
    if (query.isEmpty) {
      // Reset to all available options if query is empty
      emit(
        state.copyWith(filteredOfferedSkills: List.from(state.skillOptions)),
      );
    } else {
      final filtered =
          state.skillOptions
              .where((skill) => skill.toLowerCase().contains(lowerCaseQuery))
              .toList();
      emit(state.copyWith(filteredOfferedSkills: filtered));
    }
  }

  void filterDesiredSkills(String query) {
    final lowerCaseQuery = query.toLowerCase();
    if (query.isEmpty) {
      emit(
        state.copyWith(filteredDesiredSkills: List.from(state.skillOptions)),
      );
    } else {
      final filtered =
          state.skillOptions
              .where((skill) => skill.toLowerCase().contains(lowerCaseQuery))
              .toList();
      emit(state.copyWith(filteredDesiredSkills: filtered));
    }
  }

  void selectOfferedSkill(String skill) {
    // Create a mutable copy of the current selected skills
    final selected = List<String>.from(state.selectedOfferedSkills);
    if (selected.contains(skill)) {
      selected.remove(skill);
    } else {
      // Optional: Limit the number of selected skills if needed
      // if (selected.length < MAX_SKILLS) {
      selected.add(skill);
      // } else { Show message "Max skills reached" }
    }
    // Emit a new state with the updated list
    emit(state.copyWith(selectedOfferedSkills: selected));
  }

  void selectDesiredSkill(String skill) {
    final selected = List<String>.from(state.selectedDesiredSkills);
    if (selected.contains(skill)) {
      selected.remove(skill);
    } else {
      selected.add(skill);
    }
    emit(state.copyWith(selectedDesiredSkills: selected));
  }

  // Method to update the profile image file in the state
  void setProfileImage(File image) {
    debugPrint('CUBIT: Setting profile image to: ${image.path}');
    emit(
      state.copyWith(profileImage: image, errorMessage: ''),
    ); // Clear error on successful update
  }

  // Method to update the full name in the state
  void setFullName(String name) {
    emit(state.copyWith(fullName: name));
  }

  // Method to update the bio in the state
  void setBio(String bio) {
    emit(state.copyWith(bio: bio));
  }

  // Method to filter skills based on a selected category
  void filterByCategory(String categoryName) {
    if (categoryName == 'All') {
      // Handle an "All" category case
      emit(
        state.copyWith(
          filteredOfferedSkills: List.from(state.skillOptions),
          filteredDesiredSkills: List.from(state.skillOptions),
        ),
      );
      return;
    }

    final category = state.skillCategories.firstWhere(
      (cat) => cat.name == categoryName,
      orElse:
          () =>
              SkillCategory(name: '', skills: []), // Return empty if not found
    );

    if (category.skills.isNotEmpty) {
      // Filter both offered and desired lists based on the category's skills
      emit(
        state.copyWith(
          filteredOfferedSkills: List.from(category.skills), // Create copies
          filteredDesiredSkills: List.from(category.skills), // Create copies
        ),
      );
    } else {
      // If category not found or empty, maybe reset to all skills?
      // Or emit an empty list if that's the desired behavior?
      emit(
        state.copyWith(
          filteredOfferedSkills: List.from(state.skillOptions), // Reset to all
          filteredDesiredSkills: List.from(state.skillOptions), // Reset to all
        ),
      );
      debugPrint(
        "Category '$categoryName' not found or has no skills. Resetting filters.",
      );
    }
  }

  // Placeholder for save logic (replace with your actual implementation)
  Future<void> saveProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
      // 1. Validate required fields (e.g., name, at least one skill?)
      if (state.fullName.trim().isEmpty) {
        throw Exception("Full Name cannot be empty.");
      }
      if (state.selectedOfferedSkills.isEmpty &&
          state.selectedDesiredSkills.isEmpty) {
        throw Exception(
          "Please select at least one skill you offer or want to learn.",
        );
      }
      // Add more validation as needed

      // 2. Prepare data payload
      final profileData = {
        'fullName': state.fullName,
        'bio': state.bio,
        'offeredSkills': state.selectedOfferedSkills,
        'desiredSkills': state.selectedDesiredSkills,
        // Profile image needs special handling (uploading)
      };

      // 3. Upload profile image (if selected) to backend/storage
      String? imageUrl;
      if (state.profileImage != null) {
        // Replace with your actual image upload logic
        // imageUrl = await uploadImageToFirebaseStorage(state.profileImage!);
        // imageUrl = await uploadImageToApi(state.profileImage!);
        debugPrint("Simulating image upload for: ${state.profileImage!.path}");
        await Future.delayed(
          const Duration(seconds: 1),
        ); // Simulate network delay
        imageUrl =
            "https://example.com/path/to/uploaded/image.jpg"; // Placeholder URL
      }

      // 4. Send profile data (including image URL) to your backend API
      debugPrint(
        "Simulating saving profile data: $profileData, Image URL: $imageUrl",
      );
      // await yourApiService.saveUserProfile(profileData, imageUrl);
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // 5. Emit success state (or navigate away)
      emit(
        state.copyWith(isLoading: false, errorMessage: ''),
      ); // Clear loading and error
      // Optionally emit a success flag/message state if needed by the UI
      // emit(state.copyWith(isSaveSuccessful: true));
    } catch (e) {
      debugPrint("Error saving profile: $e");
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to save profile: $e",
        ),
      );
    }
  }
}
