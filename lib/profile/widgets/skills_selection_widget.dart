import 'package:flutter/material.dart';
import 'package:skill_swap/app_theme.dart';

class SkillsSelectionWidget extends StatefulWidget {
  final String title;
  final List<String> filteredSkills;
  final List<String> selectedSkills;
  final void Function(String) onFilter;
  final void Function(String) onSelect;

  const SkillsSelectionWidget({
    super.key,
    required this.title,
    required this.filteredSkills,
    required this.selectedSkills,
    required this.onFilter,
    required this.onSelect,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SkillsSelectionWidgetState createState() => _SkillsSelectionWidgetState();
}

class _SkillsSelectionWidgetState extends State<SkillsSelectionWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          widget.title.contains('Offer')
              ? 'Select skills you can teach or share with others'
              : 'Select skills you\'re interested in learning',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Apptheme.gray),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          onChanged: widget.onFilter,
          decoration: InputDecoration(
            hintText: 'Search skills',
            hintStyle: const TextStyle(color: Apptheme.hintTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Apptheme.darkGray,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            prefixIcon: const Icon(Icons.search, color: Apptheme.gray),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Apptheme.gray),
                    onPressed: () {
                      _controller.clear();
                      widget.onFilter('');
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        if (widget.selectedSkills.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Apptheme.darkGray,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Apptheme.gray.withOpacity(0.3)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Apptheme.primaryColor.withOpacity(0.2),
                  deleteIconColor: Apptheme.primaryColor,
                  onDeleted: () => widget.onSelect(skill),
                  labelStyle: const TextStyle(color: Apptheme.primaryColor),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.filteredSkills.length,
            itemBuilder: (context, index) {
              final skill = widget.filteredSkills[index];
              final isSelected = widget.selectedSkills.contains(skill);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () => widget.onSelect(skill),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Apptheme.primaryColor : Apptheme.white,
                          border: Border.all(
                            color: isSelected ? Apptheme.primaryColor : Apptheme.gray,
                            width: 1,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 16, color: Apptheme.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(skill, style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}