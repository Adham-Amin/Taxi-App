import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_app/features/user/features/home/data/models/ride_model.dart';

abstract class TripHistpryRemoteDataSource {
  Future<List<TripModel>> getTripsHistory();
}

class TripHistoryRemoteDataSourceImpl implements TripHistpryRemoteDataSource {
  @override
  Future<List<TripModel>> getTripsHistory() async {
    var data = await FirebaseFirestore.instance
        .collection('trips')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('created_at', descending: true)
        .get();

    return data.docs.map((e) => TripModel.fromDoc(e)).toList();
  }
}
