class DriverModel {
  final String id;
  final String image;
  final String name;
  final String email;
  final String phone;
  final String carModel;
  final String carColor;
  final String carPlateNumber;
  final double lat;
  final double lng;
  final String role;
  num? rating;
  bool? isAvailable;

  DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.carModel,
    required this.carColor,
    required this.carPlateNumber,
    required this.image,
    required this.lat,
    required this.lng,
    required this.role,
    this.isAvailable = true,
    this.rating = 4,
  });

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
      'rating': rating,
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
      lat: map['lat'] ?? '',
      lng: map['lng'] ?? '',
      role: map['role'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      rating: map['rating'] ?? 4,
    );
  }
}
