import 'package:flutter/material.dart';

class SkillSelector extends StatelessWidget {
  final List<String> skills;
  final List<String> selectedSkills;
  final Function(List<String>) onSelectionChanged;

  const SkillSelector({
    super.key,

    required this.skills,
    required this.selectedSkills,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children:
              skills.map((skill) {
                final isSelected = selectedSkills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: isSelected,
                  onSelected: (_) {
                    final updated = List<String>.from(selectedSkills);
                    isSelected ? updated.remove(skill) : updated.add(skill);
                    onSelectionChanged(updated);
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}
