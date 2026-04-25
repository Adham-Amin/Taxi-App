import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/home/data/datasources/trip_data_source.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/domain/repositories/trip_repo.dart';

class TripRepoImpl extends TripRepo {
  final TripDataSource tripDataSource;

  TripRepoImpl({required this.tripDataSource});
  @override
  Future<Either<Failure, String>> requestRide({required TripModel trip}) async {
    try {
      final tripId = await tripDataSource.requestRide(tripModel: trip);
      return Right(tripId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelRide({required String tripId}) async {
    try {
      await tripDataSource.cancelRide(tripId: tripId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, TripModel>> listenToTrip({
    required String tripId,
  }) async* {
    try {
      await for (final trip in tripDataSource.listenToTrip(tripId: tripId)) {
        yield Right<Failure, TripModel>(trip);
      }
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> doneRide({required String tripId}) async {
    try {
      await tripDataSource.doneRide(tripId: tripId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
