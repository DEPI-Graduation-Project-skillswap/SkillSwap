class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({required this.id, required this.name, required this.email});

  UserModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
      );
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
