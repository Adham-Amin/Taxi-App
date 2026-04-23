import 'package:taxi_app/core/models/location_model.dart';

class OfferEntity {
  final String id;
  final String image;
  final String name;
  final double price;
  final LocationModel pickup;
  final LocationModel destination;
  final String createdAt;

  OfferEntity({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.pickup,
    required this.destination,
    required this.createdAt,
  });
}
