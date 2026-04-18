class UserInfoModel {
  final String id;
  final String? image;
  final String? phone;
  final String? name;
  final String? email;
  final String role;

  UserInfoModel({
    this.name,
    this.email,
    required this.role,
    required this.id,
    this.image,
    this.phone,
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

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (image != null) data['image'] = image;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    return data;
  }
}
