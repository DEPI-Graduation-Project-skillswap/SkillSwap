class UserProfileModel {
  String? name;
  String? bio;
  List<String>? offeredSkills;
  List<String>? wantedSkills;
  UserProfileModel({
    required this.name,

    required this.bio,
    required this.offeredSkills,
    required this.wantedSkills,
  });
}
