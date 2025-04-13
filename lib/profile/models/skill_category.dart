
class SkillCategory {
  final String name;
  final List<String> skills;

  SkillCategory({required this.name, required this.skills});

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      name: json['name'],
      skills: List<String>.from(json['skills']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'skills': skills,
    };
  }
}