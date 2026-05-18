import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/data/models/trip_status_enum.dart';

abstract class DriverMapRepo {
  Stream<Either<Failure, TripModel>> listenToTrip({required String tripId});

  Future<Either<Failure, void>> updateTripStatus({
    required String tripId,
    required TripStatus newStatus,
  });

  Future<Either<Failure, void>> updateDriverLocation({
    required String tripId,
    required double lat,
    required double lng,
  });
}
