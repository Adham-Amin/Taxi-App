import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/driver/driver_trips/domain/repositories/driver_trips_repo.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

part 'driver_trips_state.dart';

class DriverTripsCubit extends Cubit<DriverTripsState> {
  DriverTripsCubit({required this.driverTripsRepo})
    : super(DriverTripsInitial());

  final DriverTripsRepo driverTripsRepo;
  StreamSubscription? _tripsSub;

  void listenToTrips() {
    emit(DriverTripsLoading());

    _tripsSub?.cancel();

    _tripsSub = driverTripsRepo.getTripsHistory().listen((result) {
      result.fold(
        (failure) => emit(DriverTripsError(message: failure.message)),
        (trips) => emit(DriverTripsLoaded(trips: trips)),
      );
    });
  }

  @override
  Future<void> close() {
    _tripsSub?.cancel();
    return super.close();
  }
}
