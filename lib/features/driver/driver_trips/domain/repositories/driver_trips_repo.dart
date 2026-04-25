import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

abstract class DriverTripsRepo {
  Stream<Either<Failure, List<TripEntity>>> getTripsHistory();
}
