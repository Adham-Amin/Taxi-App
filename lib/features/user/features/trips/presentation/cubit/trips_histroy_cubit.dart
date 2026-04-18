import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/domain/repositories/trip_history_repo.dart';

part 'trips_histroy_state.dart';

class TripsHistoryCubit extends Cubit<TripsHistoryState> {
  TripsHistoryCubit({required this.tripHistoryRepo}) : super(TripsInitial());

  final TripHistoryRepo tripHistoryRepo;

  StreamSubscription? _tripsSub;

  List<TripEntity> _allTrips = [];

  void listenToTrips() {
    emit(TripsHistoryLoading());

    _tripsSub?.cancel();

    _tripsSub = tripHistoryRepo.getTripsHistory().listen((result) {
      result.fold(
        (failure) => emit(TripsHistoryError(message: failure.message)),
        (trips) {
          _allTrips = trips;
          emit(TripsHistoryLoaded(trips: trips));
        },
      );
    });
  }

  void searchTrips(String query) {
    if (query.trim().isEmpty) {
      emit(TripsHistoryLoaded(trips: _allTrips));
      return;
    }

    final filtered = _allTrips.where((trip) {
      return trip.destinationAddress.toLowerCase().contains(
        query.toLowerCase(),
      );
    }).toList();

    emit(TripsHistoryLoaded(trips: filtered));
  }

  @override
  Future<void> close() {
    _tripsSub?.cancel();
    return super.close();
  }
}
