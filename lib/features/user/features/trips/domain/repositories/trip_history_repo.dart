import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

abstract class TripHistoryRepo {
  Stream<Either<Failure, List<TripEntity>>> getTripsHistory();
  Future<Either<Failure, List<TripEntity>>> searchTrips({
    required String query,
  });
}
