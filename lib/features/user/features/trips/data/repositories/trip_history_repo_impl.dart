import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/features/trips/data/datasources/trip_history_remote_data_source.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/domain/repositories/trip_history_repo.dart';

class TripHistoryRepoImpl extends TripHistoryRepo {
  final TripHistpryRemoteDataSource tripRemoteDataSource;
  TripHistoryRepoImpl({required this.tripRemoteDataSource});

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

  @override
  Future<Either<Failure, List<TripEntity>>> searchTrips({
    required String query,
  }) async {
    try {
      final trips = await tripRemoteDataSource.searchTrips(query: query);
      return Right(trips.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
