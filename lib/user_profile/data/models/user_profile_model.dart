class UserProfileModel {
  String userDetailId;
  String? name;
  String? bio;
  List<String>? offeredSkills;
  List<String>? wantedSkills;
  UserProfileModel({
    this.userDetailId = '',
    required this.name,
    required this.bio,
    required this.offeredSkills,
    required this.wantedSkills,
  });
  UserProfileModel.fromJson(Map<String, dynamic> json)
    : userDetailId = json['userDetailId'] ?? '',
      name = json['name'],
      bio = json['bio'],
      offeredSkills = List<String>.from(json['offeredSkills'] ?? []),
      wantedSkills = List<String>.from(json['wantedSkills'] ?? []);

  Map<String, dynamic> toJson() {
    return {
      'userDetailId': userDetailId,
      'name': name,
      'bio': bio,
      'offeredSkills': offeredSkills,
      'wantedSkills': wantedSkills,
    };
  }
}
