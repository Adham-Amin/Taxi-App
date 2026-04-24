class UserInfoModel {
  final String? id;
  final String? image;
  final String? phone;
  final String? name;
  final String? email;
  final String? role;
  final String? carModel;
  final String? carColor;
  final String? carPlateNumber;
  final double? lat;
  final double? lng;

  UserInfoModel({
    this.lat,
    this.lng,
    this.name,
    this.email,
    this.role,
    this.id,
    this.image,
    this.phone,
    this.carModel,
    this.carColor,
    this.carPlateNumber,
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
    'carModel': carModel,
    'carColor': carColor,
    'carPlateNumber': carPlateNumber,
    'lat': lat,
    'lng': lng,
  };

  factory UserInfoModel.fromMap(Map<String, dynamic> map) => UserInfoModel(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    role: map['role'] ?? '',
    image: map['image'] ?? '',
    phone: map['phone'] ?? '',
    carModel: map['carModel'] ?? '',
    carColor: map['carColor'] ?? '',
    carPlateNumber: map['carPlateNumber'] ?? '',
    lat: map['lat'] ?? 0.0,
    lng: map['lng'] ?? 0.0,
  );

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (image != null) data['image'] = image;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (carModel != null) data['carModel'] = carModel;
    if (carColor != null) data['carColor'] = carColor;
    if (carPlateNumber != null) data['carPlateNumber'] = carPlateNumber;
    return data;
  }
}
