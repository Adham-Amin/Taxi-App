import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/user/features/home/data/datasources/google_map_data_source.dart';
import 'package:taxi_app/features/user/features/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/features/home/domain/repositories/google_map_repo.dart';

class GoogleMapRepoImpl extends GoogleMapRepo {
  final GoogleMapDataSource googleMapDataSource;
  GoogleMapRepoImpl({required this.googleMapDataSource});

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    required String query,
  }) async {
    try {
      var data = await googleMapDataSource.getPlaces(query: query);
      return Right(data.map((e) => e.toEntity()).toList());
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<LatLng>>> getPolylinePoints({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      var data = await googleMapDataSource.getPolylinePoints(
        origin: origin,
        destination: destination,
      );
      return Right(data);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
