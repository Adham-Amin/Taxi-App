import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/user/features/home/data/models/trip_status_enum.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

class TripModel {
  final String id;
  final TripStatus status;
  final LocationModel pickup;
  final LocationModel destination;
  final double price;
  final String userId;
  final String driverId;
  final DriverModel driver;
  final UserInfoModel user;
  final String createdAt;

  TripModel({
    required this.userId,
    required this.driverId,
    required this.id,
    required this.status,
    required this.pickup,
    required this.destination,
    required this.price,
    required this.driver,
    required this.user,
    required this.createdAt,
  });
  factory TripModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TripModel(
      userId: data['user_id'] ?? '',
      driverId: data['driver_id'] ?? '',
      id: doc.id,
      status: TripStatusExtension.fromString(data['status'] ?? 'searching'),
      pickup: LocationModel.fromJson(
        Map<String, dynamic>.from(data['pickup'] ?? {}),
      ),
      destination: LocationModel.fromJson(
        Map<String, dynamic>.from(data['destination'] ?? {}),
      ),
      price: (data['price'] ?? 0).toDouble(),
      driver: data['driver'] != null
          ? DriverModel.fromMap(Map<String, dynamic>.from(data['driver']))
          : DriverModel.empty(),

      user: data['user'] != null
          ? UserInfoModel.fromMap(Map<String, dynamic>.from(data['user']))
          : UserInfoModel.empty(),

      createdAt: data['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'pickup': pickup.toJson(),
      'destination': destination.toJson(),
      'price': price,
      'driver': driver.toMap(),
      'user': user.toMap(),
      'created_at': createdAt,
      'user_id': userId,
      'driver_id': driverId,
    };
  }

  TripModel copyWith({String? id}) => TripModel(
    id: id ?? this.id,
    status: status,
    pickup: pickup,
    destination: destination,
    price: price,
    driver: driver,
    user: user,
    createdAt: createdAt,
    userId: userId,
    driverId: driverId,
  );

  TripEntity toEntity() => TripEntity(
    driverName: driver.name,
    price: price,
    status: status.name,
    originAddress: pickup.fullAddress,
    destinationAddress: destination.fullAddress,
    date: createdAt,
  );

  OfferEntity toOfferEntity() => OfferEntity(
    createdAt: createdAt,
    price: price,
    destination: destination,
    id: id,
    pickup: pickup,
    image: user.image ?? '',
    name: user.name ?? '',
  );
}
