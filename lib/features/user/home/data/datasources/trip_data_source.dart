import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';

abstract class TripDataSource {
  Stream<TripModel> listenToTrip({required String tripId});
  Future<String> requestRide({required TripModel tripModel});
  Future<void> cancelRide({required String tripId});
  Future<void> doneRide({required String tripId});
}

class TripDataSourceImpl implements TripDataSource {
  @override
  Future<void> cancelRide({required String tripId}) async {
    await FirebaseFirestore.instance.collection('trips').doc(tripId).update({
      'status': 'canceled',
    });
  }

  @override
  Stream<TripModel> listenToTrip({required String tripId}) {
    return FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .snapshots()
        .map((doc) {
          return TripModel.fromDoc(doc);
        });
  }

  @override
  Future<String> requestRide({required TripModel tripModel}) async {
    final docRef = FirebaseFirestore.instance.collection('trips').doc();
    final trip = tripModel.copyWith(id: docRef.id);
    await docRef.set(trip.toMap());
    return docRef.id;
  }

  @override
  Future<void> doneRide({required String tripId}) async {
    await FirebaseFirestore.instance.collection('trips').doc(tripId).update({
      'status': 'done',
    });
  }
}
