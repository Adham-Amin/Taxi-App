import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/data/models/trip_status_enum.dart';

abstract class DriverMapDataSource {
  Stream<TripModel> listenToTrip({required String tripId});
  Future<void> updateTripStatus({
    required String tripId,
    required TripStatus newStatus,
  });
  Future<void> updateDriverLocation({
    required String tripId,
    required double lat,
    required double lng,
  });
}

class DriverMapDataSourceImpl implements DriverMapDataSource {
  @override
  Stream<TripModel> listenToTrip({required String tripId}) {
    return FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .snapshots()
        .map((doc) => TripModel.fromDoc(doc));
  }

  @override
  Future<void> updateTripStatus({
    required String tripId,
    required TripStatus newStatus,
  }) async {
    await FirebaseFirestore.instance.collection('trips').doc(tripId).update({
      'status': newStatus.value,
    });
  }

  @override
  Future<void> updateDriverLocation({
    required String tripId,
    required double lat,
    required double lng,
  }) async {
    await FirebaseFirestore.instance.collection('trips').doc(tripId).update({
      'driver.lat': lat,
      'driver.lng': lng,
    });
  }
}
