import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_app/features/user/features/home/data/models/ride_model.dart';

abstract class TripHistpryRemoteDataSource {
  Stream<List<TripModel>> getTripsHistoryStream();
  Future<List<TripModel>> searchTrips({required String query});
}

class TripHistoryRemoteDataSourceImpl implements TripHistpryRemoteDataSource {
  @override
  Stream<List<TripModel>> getTripsHistoryStream() {
    return FirebaseFirestore.instance
        .collection('trips')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((e) => TripModel.fromDoc(e)).toList();
        });
  }

  @override
  Future<List<TripModel>> searchTrips({required String query}) async {
    final data = await FirebaseFirestore.instance
        .collection('trips')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('destination.fullAddress')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .get();
    return data.docs.map((e) => TripModel.fromDoc(e)).toList();
  }
}
