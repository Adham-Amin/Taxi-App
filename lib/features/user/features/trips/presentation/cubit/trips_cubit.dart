import 'package:flutter_bloc/flutter_bloc.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit() : super(TripsInitial());
}
