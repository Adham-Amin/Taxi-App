import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/home/domain/entities/place_entity.dart';

abstract class MapRepo {
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({required String query});
  Future<Either<Failure, List<LatLng>>> getPolylinePoints({
    required LatLng origin,
    required LatLng destination,
  });
}
