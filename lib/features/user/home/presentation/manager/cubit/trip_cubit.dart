import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/data/models/trip_status_enum.dart';
import 'package:taxi_app/features/user/home/domain/repositories/trip_repo.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepo tripRepo;

  TripCubit({required this.tripRepo}) : super(TripInitial());

  StreamSubscription? _tripSubscription;
  String? currentTripId;

  Future<void> requestRide({required TripModel trip}) async {
    emit(TripLoading());

    final result = await tripRepo.requestRide(trip: trip);

    result.fold((failure) => emit(TripError(failure.message)), (tripId) {
      currentTripId = tripId;
      emit(TripSearching());
      listenToTrip(tripId: tripId);
    });
  }

  void listenToTrip({required String tripId}) {
    _tripSubscription?.cancel();

    _tripSubscription = tripRepo.listenToTrip(tripId: tripId).listen((event) {
      event.fold(
        (failure) => emit(TripError(failure.message)),
        (trip) => _handleTripState(trip: trip),
      );
    });
  }

  void _handleTripState({required TripModel trip}) {
    switch (trip.status) {
      case TripStatus.searching:
        emit(TripSearching());
        break;

      case TripStatus.accepted:
        emit(TripAccepted(trip));
        break;

      case TripStatus.arrived:
        emit(TripArrived(trip));
        break;

      case TripStatus.onTrip:
        emit(TripOnGoing(trip));
        break;

      case TripStatus.done:
        emit(TripDone());
        break;

      case TripStatus.completed:
        emit(TripCompleted(trip));
        break;

      case TripStatus.canceled:
        emit(TripCanceled());
        break;
    }
  }

  Future<void> cancelRide() async {
    if (currentTripId == null) return;
    await tripRepo.cancelRide(tripId: currentTripId!);
    emit(TripCanceled());
    close();
  }

  Future<void> doneRide() async {
    if (currentTripId == null) return;
    await tripRepo.doneRide(tripId: currentTripId!);
    emit(TripDone());
    close();
  }

  @override
  Future<void> close() {
    _tripSubscription?.cancel();
    return super.close();
  }
}
