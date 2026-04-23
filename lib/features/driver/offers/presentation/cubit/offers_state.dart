part of 'offers_cubit.dart';

abstract class OffersState {}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersLoaded extends OffersState {
  final List<OfferEntity> offers;
  OffersLoaded({required this.offers});
}

class OffersAcceptLoaded extends OffersState {}

class OffersError extends OffersState {
  final String message;
  OffersError({required this.message});
}
