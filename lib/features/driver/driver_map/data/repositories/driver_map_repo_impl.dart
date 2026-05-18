import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/driver/driver_map/data/datasources/driver_map_data_source.dart';
import 'package:taxi_app/features/driver/driver_map/domain/repositories/driver_map_repo.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/data/models/trip_status_enum.dart';

class DriverMapRepoImpl extends DriverMapRepo {
  final DriverMapDataSource dataSource;

  DriverMapRepoImpl({required this.dataSource});

  @override
  Stream<Either<Failure, TripModel>> listenToTrip({required String tripId}) {
    try {
      return dataSource
          .listenToTrip(tripId: tripId)
          .map((trip) => Right<Failure, TripModel>(trip));
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> updateTripStatus({
    required String tripId,
    required TripStatus newStatus,
  }) async {
    try {
      await dataSource.updateTripStatus(tripId: tripId, newStatus: newStatus);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDriverLocation({
    required String tripId,
    required double lat,
    required double lng,
  }) async {
    try {
      await dataSource.updateDriverLocation(tripId: tripId, lat: lat, lng: lng);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
