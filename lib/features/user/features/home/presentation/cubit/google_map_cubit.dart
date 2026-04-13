import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/features/user/features/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/features/home/domain/repositories/google_map_repo.dart';
part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  GoogleMapCubit({required this.googleMapRepo}) : super(GoogleMapInitial());

  final GoogleMapRepo googleMapRepo;

  List<PlaceEntity> places = [];
  List<LatLng> polylinePoints = [];

  Future<void> getPlaces({required String query}) async {
    emit(PlacesLoading());
    var result = await googleMapRepo.getPlaces(query: query);
    result.fold((l) => emit(GoogleMapError(failure: l.message)), (r) {
      places = r;
      emit(PlacesLoaded());
    });
  }

  void clearPlaces() {
    places = [];
    emit(PlacesLoaded());
  }

  Future<void> getPolylinePoints({
    required LatLng origin,
    required LatLng destination,
  }) async {
    emit(PolylineLoading());
    var result = await googleMapRepo.getPolylinePoints(
      origin: origin,
      destination: destination,
    );
    result.fold((l) => emit(GoogleMapError(failure: l.message)), (r) {
      polylinePoints = r;
      emit(PolylineLoaded());
    });
  }
}
