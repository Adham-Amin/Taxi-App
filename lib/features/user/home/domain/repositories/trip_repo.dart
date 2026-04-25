import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';

abstract class TripRepo {
  Future<Either<Failure, String>> requestRide({required TripModel trip});
  Future<Either<Failure, void>> cancelRide({required String tripId});
  Stream<Either<Failure, TripModel>> listenToTrip({required String tripId});
  Future<Either<Failure, void>> doneRide({required String tripId});
}
