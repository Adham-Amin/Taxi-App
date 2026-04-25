import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/features/user/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/home/domain/repositories/google_map_repo.dart';
part 'google_map_state.dart';

class MapCubit extends Cubit<GoogleMapState> {
  MapCubit({required this.googleMapRepo}) : super(GoogleMapInitial());

  final MapRepo googleMapRepo;

  List<PlaceEntity> pickUpPlaces = [];
  List<PlaceEntity> distinationplaces = [];
  List<LatLng> polylinePoints = [];

  Future<void> getPickUpPlaces({required String query}) async {
    emit(PlacesLoading());
    var result = await googleMapRepo.getPlaces(query: query);
    result.fold((l) => emit(GoogleMapError(failure: l.message)), (r) {
      pickUpPlaces = r;
      emit(PlacesLoaded());
    });
  }

  Future<void> getDistinationPlaces({required String query}) async {
    emit(PlacesLoading());
    var result = await googleMapRepo.getPlaces(query: query);
    result.fold((l) => emit(GoogleMapError(failure: l.message)), (r) {
      distinationplaces = r;
      emit(PlacesLoaded());
    });
  }

  void clearPlaces() {
    pickUpPlaces = [];
    distinationplaces = [];
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
