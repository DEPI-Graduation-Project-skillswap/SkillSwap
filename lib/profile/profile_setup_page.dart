import 'package:flutter/material.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert'; // For JSON parsing
import 'package:flutter/services.dart'; // For loading assets

class ProfileSetupPage extends StatefulWidget {
  static const String routeName = '/profile-setup';

  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  // Selected skills
  final List<String> _selectedOfferedSkills = [];
  final List<String> _selectedDesiredSkills = [];

  // All skill options
  List<String> _skillOptions = [];

  // Skill categories from JSON
  List<Map<String, dynamic>> _skillCategories = [];

  // For skills search filtering
  List<String> _filteredOfferedSkills = [];
  List<String> _filteredDesiredSkills = [];

  // Controllers for search fields
  final TextEditingController _offeredSkillsController =
      TextEditingController();
  final TextEditingController _desiredSkillsController =
      TextEditingController();

  // Image picker
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadSkillsData();
  }

  @override
  void dispose() {
    _offeredSkillsController.dispose();
    _desiredSkillsController.dispose();
    super.dispose();
  }

  // Load skills from JSON file
  Future<void> loadSkillsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load the JSON file from assets
      // Note: Make sure to add the file to your pubspec.yaml under assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/skills_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Extract categories
      final List<dynamic> categoriesJson = jsonData['categories'];

      // Convert to proper Map format
      _skillCategories =
          categoriesJson.map<Map<String, dynamic>>((category) {
            return {
              'name': category['name'],
              'skills': List<String>.from(category['skills']),
            };
          }).toList();

      // Create a flattened list of all skills for the main options
      final List<String> allSkills = [];
      for (var category in _skillCategories) {
        allSkills.addAll(List<String>.from(category['skills']));
      }

      // Sort alphabetically
      allSkills.sort();

      setState(() {
        _skillOptions = allSkills;
        _filteredOfferedSkills = List.from(allSkills);
        _filteredDesiredSkills = List.from(allSkills);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading skills data: $e';
        _isLoading = false;

        // Fallback if loading fails
        _skillOptions = [
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
        _filteredOfferedSkills = List.from(_skillOptions);
        _filteredDesiredSkills = List.from(_skillOptions);
      });
    }
  }

  // Filter skills based on search query
  void filterOfferedSkills(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOfferedSkills = List.from(_skillOptions);
      } else {
        _filteredOfferedSkills =
            _skillOptions
                .where(
                  (skill) => skill.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void filterDesiredSkills(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDesiredSkills = List.from(_skillOptions);
      } else {
        _filteredDesiredSkills =
            _skillOptions
                .where(
                  (skill) => skill.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  // Filter skills by category (when user taps a category chip)
  void filterByCategory(String categoryName) {
    // Find the selected category in our loaded data
    final category = _skillCategories.firstWhere(
      (category) => category['name'] == categoryName,
      orElse: () => {'name': '', 'skills': []},
    );

    // Clear search fields
    setState(() {
      _offeredSkillsController.clear();
      _desiredSkillsController.clear();

      if (category['skills'].isNotEmpty) {
        _filteredOfferedSkills = List<String>.from(category['skills']);
        _filteredDesiredSkills = List<String>.from(category['skills']);
      } else {
        _filteredOfferedSkills = List.from(_skillOptions);
        _filteredDesiredSkills = List.from(_skillOptions);
      }
    });

    // Show a message to the user about the filter
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing $categoryName skills'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Clear Filter',
          onPressed: () {
            setState(() {
              _filteredOfferedSkills = List.from(_skillOptions);
              _filteredDesiredSkills = List.from(_skillOptions);
            });
          },
        ),
      ),
    );
  }

  // Build category filter chip widget
  Widget _buildCategoryChip(String category, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        backgroundColor: Apptheme.darkGray,
        labelStyle: TextStyle(color: Apptheme.primaryColor),
        side: BorderSide(color: Apptheme.primaryColor.withOpacity(0.3)),
        label: Text(category),
        onPressed: () => filterByCategory(category),
      ),
    );
  }

  // Pick image from gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle any exceptions
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Apptheme.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile Setup',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Apptheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Apptheme.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.waving_hand,
                                  color: Apptheme.primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Welcome to Skill Swap!',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: Apptheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'First, let\'s set up your profile. This will help connect you with people who match your skill interests.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Profile Picture Upload
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Show image picker dialog
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Icons.photo_library,
                                            ),
                                            title: const Text(
                                              'Choose from Gallery',
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              _pickImage(ImageSource.gallery);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                            ),
                                            title: const Text('Take a Photo'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              _pickImage(ImageSource.camera);
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
                                      image:
                                          _profileImage != null
                                              ? DecorationImage(
                                                image: FileImage(
                                                  _profileImage!,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                              : null,
                                    ),
                                    child:
                                        _profileImage == null
                                            ? const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Apptheme.gray,
                                            )
                                            : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Apptheme.primaryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Apptheme.white,
                                          width: 2,
                                        ),
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
                            Text(
                              'Upload Profile Picture',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Full Name
                      Text(
                        'Full Name',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(color: Apptheme.hintTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Apptheme.darkGray,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bio
                      Text(
                        'Bio',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Brief description about yourself',
                          hintStyle: TextStyle(color: Apptheme.hintTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Apptheme.darkGray,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Skills You Offer
                      Text(
                        'Skills You Offer',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select skills you can teach or share with others',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Apptheme.gray),
                      ),
                      const SizedBox(height: 16),

                      // Skills Search for Offered Skills
                      TextField(
                        controller: _offeredSkillsController,
                        onChanged: filterOfferedSkills,
                        decoration: InputDecoration(
                          hintText: 'Search skills to offer',
                          hintStyle: TextStyle(color: Apptheme.hintTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Apptheme.darkGray,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Apptheme.gray,
                          ),
                          suffixIcon:
                              _offeredSkillsController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Apptheme.gray,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _offeredSkillsController.clear();
                                        _filteredOfferedSkills = List.from(
                                          _skillOptions,
                                        );
                                      });
                                    },
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Selected Offered Skills chips
                      if (_selectedOfferedSkills.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Apptheme.darkGray,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Apptheme.gray.withOpacity(0.3),
                            ),
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                _selectedOfferedSkills.map((skill) {
                                  return Chip(
                                    label: Text(skill),
                                    backgroundColor: Apptheme.primaryColor
                                        .withOpacity(0.2),
                                    deleteIconColor: Apptheme.primaryColor,
                                    onDeleted: () {
                                      setState(() {
                                        _selectedOfferedSkills.remove(skill);
                                      });
                                    },
                                    labelStyle: TextStyle(
                                      color: Apptheme.primaryColor,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Offered Skills checkboxes
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredOfferedSkills.length,
                          itemBuilder: (context, index) {
                            final skill = _filteredOfferedSkills[index];
                            final isSelected = _selectedOfferedSkills.contains(
                              skill,
                            );

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedOfferedSkills.remove(skill);
                                    } else {
                                      _selectedOfferedSkills.add(skill);
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isSelected
                                                ? Apptheme.primaryColor
                                                : Apptheme.white,
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Apptheme.primaryColor
                                                  : Apptheme.gray,
                                          width: 1,
                                        ),
                                      ),
                                      child:
                                          isSelected
                                              ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Apptheme.white,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      skill,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Skills You Want to Learn
                      Text(
                        'Skills You Want to Learn',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select skills you\'re interested in learning',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Apptheme.gray),
                      ),
                      const SizedBox(height: 16),

                      // Skills to Learn Search
                      TextField(
                        controller: _desiredSkillsController,
                        onChanged: filterDesiredSkills,
                        decoration: InputDecoration(
                          hintText: 'Search skills to learn',
                          hintStyle: TextStyle(color: Apptheme.hintTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Apptheme.darkGray,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Apptheme.gray,
                          ),
                          suffixIcon:
                              _desiredSkillsController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Apptheme.gray,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _desiredSkillsController.clear();
                                        _filteredDesiredSkills = List.from(
                                          _skillOptions,
                                        );
                                      });
                                    },
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Selected Desired Skills chips
                      if (_selectedDesiredSkills.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Apptheme.darkGray,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Apptheme.gray.withOpacity(0.3),
                            ),
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                _selectedDesiredSkills.map((skill) {
                                  return Chip(
                                    label: Text(skill),
                                    backgroundColor: Apptheme.primaryColor
                                        .withOpacity(0.2),
                                    deleteIconColor: Apptheme.primaryColor,
                                    onDeleted: () {
                                      setState(() {
                                        _selectedDesiredSkills.remove(skill);
                                      });
                                    },
                                    labelStyle: TextStyle(
                                      color: Apptheme.primaryColor,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Desired Skills checkboxes
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredDesiredSkills.length,
                          itemBuilder: (context, index) {
                            final skill = _filteredDesiredSkills[index];
                            final isSelected = _selectedDesiredSkills.contains(
                              skill,
                            );

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedDesiredSkills.remove(skill);
                                    } else {
                                      _selectedDesiredSkills.add(skill);
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isSelected
                                                ? Apptheme.primaryColor
                                                : Apptheme.white,
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Apptheme.primaryColor
                                                  : Apptheme.gray,
                                          width: 1,
                                        ),
                                      ),
                                      child:
                                          isSelected
                                              ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Apptheme.white,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      skill,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Error message if data loading fails
                      if (_errorMessage.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                      // Skill categories chips
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Popular Categories',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    _skillCategories
                                        .map(
                                          (category) => _buildCategoryChip(
                                            category['name'],
                                            context,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Save & Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate that at least some fields are filled
                            if (_selectedOfferedSkills.isEmpty &&
                                _selectedDesiredSkills.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select at least one skill to offer or learn',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            // Here you would normally save user data to your backend
                            // For now, we'll just show a success message and navigate

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile saved successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Navigate to home screen after saving
                            Future.delayed(
                              const Duration(milliseconds: 800),
                              () {
                                Navigator.pushNamed(context, '/home');
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Apptheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save & Continue',
                            style: TextStyle(
                              color: Apptheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
