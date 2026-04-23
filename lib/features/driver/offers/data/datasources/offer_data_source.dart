import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/user/features/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/features/home/data/models/trip_status_enum.dart';

abstract class OfferDataSource {
  Future<void> acceptOffer({
    required String offerId,
    required DriverModel driver,
  });
  Stream<List<OfferEntity>> listenToOffers();
}

class OfferDataSourceImpl implements OfferDataSource {
  @override
  Future<void> acceptOffer({
    required String offerId,
    required DriverModel driver,
  }) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final docRef = FirebaseFirestore.instance
          .collection('trips')
          .doc(offerId);
      final snapshot = await transaction.get(docRef);

      if (snapshot['status'] == TripStatus.searching.value) {
        transaction.update(docRef, {
          'status': TripStatus.accepted.value,
          'driver': driver.toMap(),
          'driver_id': driver.id,
        });
      } else {
        throw Exception('Already accepted');
      }
    });
  }

  @override
  Stream<List<OfferEntity>> listenToOffers() {
    return FirebaseFirestore.instance
        .collection('trips')
        .where('status', isEqualTo: TripStatus.searching.value)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) {
          return event.docs
              .map((e) => TripModel.fromDoc(e).toOfferEntity())
              .toList();
        });
  }
}
