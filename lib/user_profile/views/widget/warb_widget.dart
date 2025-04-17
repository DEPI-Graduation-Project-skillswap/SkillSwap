import 'package:flutter/material.dart';

class WarbWidget extends StatelessWidget {
  const WarbWidget({
    super.key,
    required this.skills,
    required this.onSelectionChanged,
  });
  final List<String> skills;
  final Function onSelectionChanged;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          skills
              .map(
                (skill) => Chip(
                  label: Text(skill),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    final updated = skills;
                    updated.remove(skill);
                    onSelectionChanged(updated);
                  },
                ),
              )
              .toList(),
    );
  }
}
