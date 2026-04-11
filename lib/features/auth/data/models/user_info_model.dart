class UserInfoModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserInfoModel({
    required this.name,
    required this.email,
    required this.role,
    required this.id,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
  };

  factory UserInfoModel.fromMap(Map<String, dynamic> map) => UserInfoModel(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    role: map['role'] ?? '',
  );
}
