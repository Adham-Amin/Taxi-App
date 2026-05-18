import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/features/driver/driver_map/domain/repositories/driver_map_repo.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/data/models/trip_status_enum.dart';

part 'driver_map_state.dart';

class DriverMapCubit extends Cubit<DriverMapState> {
  DriverMapCubit({required this.driverMapRepo}) : super(DriverMapInitial());

  final DriverMapRepo driverMapRepo;
  final LocationServices _locationService = LocationServices();

  StreamSubscription? _tripSubscription;
  StreamSubscription? _locationSubscription;
  late String tripId;

  void startTrip({required String tripId}) {
    this.tripId = tripId;
    emit(DriverMapLoading());
    _listenToTrip();
    _startLocationUpdates();
  }

  void _listenToTrip() {
    _tripSubscription?.cancel();
    _tripSubscription = driverMapRepo.listenToTrip(tripId: tripId).listen(
      (result) {
        result.fold(
          (failure) => emit(DriverMapError(failure.message)),
          (trip) => _handleTripUpdate(trip),
        );
      },
    );
  }

  void _handleTripUpdate(TripModel trip) {
    switch (trip.status) {
      case TripStatus.accepted:
        emit(DriverMapGoingToPickup(trip));
        break;
      case TripStatus.arrived:
        emit(DriverMapArrivedAtPickup(trip));
        break;
      case TripStatus.onTrip:
        emit(DriverMapOnTrip(trip));
        break;
      case TripStatus.completed:
        emit(DriverMapTripCompleted(trip));
        break;
      case TripStatus.done:
        emit(DriverMapTripDone());
        break;
      case TripStatus.canceled:
        emit(DriverMapTripDone());
        break;
      default:
        break;
    }
  }

  void _startLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.getLocationStream().listen(
      (location) {
        if (location.latitude != null && location.longitude != null) {
          driverMapRepo.updateDriverLocation(
            tripId: tripId,
            lat: location.latitude!,
            lng: location.longitude!,
          );
        }
      },
    );
  }

  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void resumeLocationUpdates() {
    _startLocationUpdates();
  }

  Future<void> arrivedAtPickup() async {
    final result = await driverMapRepo.updateTripStatus(
      tripId: tripId,
      newStatus: TripStatus.arrived,
    );
    result.fold(
      (failure) => emit(DriverMapError(failure.message)),
      (_) {},
    );
  }

  Future<void> startRide() async {
    final result = await driverMapRepo.updateTripStatus(
      tripId: tripId,
      newStatus: TripStatus.onTrip,
    );
    result.fold(
      (failure) => emit(DriverMapError(failure.message)),
      (_) {},
    );
  }

  Future<void> endRide() async {
    final result = await driverMapRepo.updateTripStatus(
      tripId: tripId,
      newStatus: TripStatus.completed,
    );
    result.fold(
      (failure) => emit(DriverMapError(failure.message)),
      (_) {},
    );
  }

  Future<void> doneRide() async {
    final result = await driverMapRepo.updateTripStatus(
      tripId: tripId,
      newStatus: TripStatus.done,
    );
    result.fold(
      (failure) => emit(DriverMapError(failure.message)),
      (_) => emit(DriverMapTripDone()),
    );
  }

  @override
  Future<void> close() {
    _tripSubscription?.cancel();
    _locationSubscription?.cancel();
    return super.close();
  }
}
