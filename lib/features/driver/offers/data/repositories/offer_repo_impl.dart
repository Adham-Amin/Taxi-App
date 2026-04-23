import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/driver/offers/data/datasources/offer_data_source.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/driver/offers/domain/repositories/offer_repo.dart';

class OfferRepoImpl extends OfferRepo {
  final OfferDataSource offerDataSource;
  OfferRepoImpl({required this.offerDataSource});
  @override
  Future<Either<Failure, void>> acceptOffer({
    required String offerId,
    required DriverModel driver,
  }) async {
    try {
      await offerDataSource.acceptOffer(offerId: offerId, driver: driver);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<OfferEntity>>> listenToOffers() {
    try {
      var offers = offerDataSource.listenToOffers();
      return offers.map((event) => Right(event));
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }
}
