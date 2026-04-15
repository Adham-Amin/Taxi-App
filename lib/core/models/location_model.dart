class LocationModel {
  final double lat;
  final double lng;
  final String fullAddress;

  LocationModel({
    required this.lat,
    required this.lng,
    required this.fullAddress,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    lat: json['lat'] as double,
    lng: json['lng'] as double,
    fullAddress: json['fullAddress'] as String,
  );

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'fullAddress': fullAddress,
  };
}
