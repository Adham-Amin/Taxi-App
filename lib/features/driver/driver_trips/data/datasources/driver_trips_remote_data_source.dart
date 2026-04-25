import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';

abstract class DriverTripsRemoteDataSource {
  Stream<List<TripModel>> getTripsHistoryStream();
}

class DriverTripsRemoteDataSourceImpl implements DriverTripsRemoteDataSource {
  @override
  Stream<List<TripModel>> getTripsHistoryStream() {
    return FirebaseFirestore.instance
        .collection('trips')
        .where('driver_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((e) => TripModel.fromDoc(e)).toList();
        });
  }
}
