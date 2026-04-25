import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/driver/driver_trips/data/datasources/driver_trips_remote_data_source.dart';
import 'package:taxi_app/features/driver/driver_trips/domain/repositories/driver_trips_repo.dart';
import 'package:taxi_app/features/user/trips/domain/entities/trip_entity.dart';

class DriverTripsRepoImpl extends DriverTripsRepo {
  final DriverTripsRemoteDataSource tripRemoteDataSource;
  DriverTripsRepoImpl({required this.tripRemoteDataSource});

  @override
  Stream<Either<Failure, List<TripEntity>>> getTripsHistory() {
    try {
      return tripRemoteDataSource.getTripsHistoryStream().map((trips) {
        return Right(trips.map((e) => e.toEntity()).toList());
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }
}
