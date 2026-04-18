import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/domain/repositories/trip_history_repo.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit({required this.tripHistoryRepo}) : super(TripsInitial());

  final TripHistoryRepo tripHistoryRepo;

  Future<void> getTripsHistory() async {
    emit(TripsLoading());
    final result = await tripHistoryRepo.getTripsHistory();
    result.fold(
      (failure) => emit(TripsError(message: failure.message)),
      (trips) => emit(TripsLoaded(trips: trips)),
    );
  }
}
