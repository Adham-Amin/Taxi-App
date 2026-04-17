import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/features/trips/data/datasources/trip_history_remote_data_source.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/domain/repositories/trip_history_repo.dart';

class TripHistoryRepoImpl extends TripHistoryRepo {
  final TripHistpryRemoteDataSource tripRemoteDataSource;
  TripHistoryRepoImpl({required this.tripRemoteDataSource});

  @override
  Future<Either<Failure, List<TripEntity>>> getTripsHistory() async {
    try {
      final trips = await tripRemoteDataSource.getTripsHistory();
      return Right(trips.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
