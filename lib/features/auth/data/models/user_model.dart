import 'package:taxi_app/features/auth/data/models/user_info_model.dart';

class UserModel {
  final String id;
  final String image;
  final String name;
  final String email;
  final String phone;
  final String role;

  UserModel({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }

  UserInfoModel toUserInfoModel() => UserInfoModel(
    name: name,
    email: email,
    role: role,
    id: id,
    image: image,
    phone: phone,
  );
}
