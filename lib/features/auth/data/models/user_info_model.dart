class UserInfoModel {
  final String id;
  final String image;
  final String phone;
  final String name;
  final String email;
  final String role;

  UserInfoModel({
    required this.name,
    required this.email,
    required this.role,
    required this.id,
    required this.image,
    required this.phone,
  });

  factory UserInfoModel.empty() => UserInfoModel(
    name: '',
    email: '',
    role: '',
    id: '',
    image: '',
    phone: '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'image': image,
    'phone': phone,
  };

  factory UserInfoModel.fromMap(Map<String, dynamic> map) => UserInfoModel(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    role: map['role'] ?? '',
    image: map['image'] ?? '',
    phone: map['phone'] ?? '',
  );
}
