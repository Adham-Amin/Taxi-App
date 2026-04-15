class DriverModel {
  final String? id;
  final String image;
  final String name;
  final String email;
  final String phone;
  final String carModel;
  final String carColor;
  final String carPlateNumber;
  final double? lat;
  final double? lng;
  final String role;
  bool? isAvailable;

  DriverModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.carModel,
    required this.carColor,
    required this.carPlateNumber,
    required this.image,
    this.lat,
    this.lng,
    required this.role,
    this.isAvailable = true,
  });

  factory DriverModel.empty() => DriverModel(
    name: '',
    email: '',
    phone: '',
    carModel: '',
    carColor: '',
    carPlateNumber: '',
    image: '',
    role: '',
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'carModel': carModel,
      'carColor': carColor,
      'carPlateNumber': carPlateNumber,
      'image': image,
      'lat': lat,
      'lng': lng,
      'role': role,
      'isAvailable': isAvailable,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      carModel: map['carModel'] ?? '',
      carColor: map['carColor'] ?? '',
      carPlateNumber: map['carPlateNumber'] ?? '',
      image: map['image'] ?? '',
      role: map['role'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      lat: (map['lat'] as num?)?.toDouble(),
      lng: (map['lng'] as num?)?.toDouble(),
    );
  }
}
