import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/driver/offers/domain/repositories/offer_repo.dart';

part 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  OffersCubit({required this.offerRepo}) : super(OffersInitial());

  final OfferRepo offerRepo;
  StreamSubscription? _tripsSub;

  void listenToOffers() {
    emit(OffersLoading());
    _tripsSub?.cancel();

    _tripsSub = offerRepo.listenToOffers().listen((result) {
      result.fold(
        (failure) => emit(OffersError(message: failure.message)),
        (offers) => emit(OffersLoaded(offers: offers)),
      );
    });
  }

  @override
  Future<void> close() {
    _tripsSub?.cancel();
    return super.close();
  }

  Future<void> acceptOffer({
    required String offerId,
    required DriverModel driver,
  }) async {
    emit(OffersLoading());
    var result = await offerRepo.acceptOffer(offerId: offerId, driver: driver);
    result.fold(
      (failure) => emit(OffersError(message: failure.message)),
      (_) => emit(OffersAcceptLoaded()),
    );
  }
}
