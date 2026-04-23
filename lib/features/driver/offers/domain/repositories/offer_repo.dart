import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';

abstract class OfferRepo {
  Stream<Either<Failure, List<OfferEntity>>> listenToOffers();

  Future<Either<Failure, void>> acceptOffer({
    required String offerId,
    required DriverModel driver,
  });
}
