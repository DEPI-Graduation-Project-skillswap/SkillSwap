import 'package:flutter/material.dart';
import 'package:skill_swap/app_theme.dart';

class SkillsSelectionWidget extends StatelessWidget {
  final String title;
  final List<String> filteredSkills;
  final List<String> selectedSkills;
  final Function(String) onFilter;
  final Function(String) onSelect;

  const SkillsSelectionWidget({
    super.key,
    required this.title,
    required this.filteredSkills,
    required this.selectedSkills,
    required this.onFilter,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _controller = TextEditingController();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          title.contains('Offer')
              ? 'Select skills you can teach or share with others'
              : 'Select skills you\'re interested in learning',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Apptheme.gray),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          onChanged: onFilter,
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
                      onFilter('');
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        if (selectedSkills.isNotEmpty)
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
              children: selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Apptheme.primaryColor.withOpacity(0.2),
                  deleteIconColor: Apptheme.primaryColor,
                  onDeleted: () => onSelect(skill),
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
            itemCount: filteredSkills.length,
            itemBuilder: (context, index) {
              final skill = filteredSkills[index];
              final isSelected = selectedSkills.contains(skill);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () => onSelect(skill),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Apptheme.primaryColor : Colors.transparent,
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