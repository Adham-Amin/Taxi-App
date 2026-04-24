import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/driver/offers/data/datasources/offer_data_source.dart';
import 'package:taxi_app/features/driver/offers/data/repositories/offer_repo_impl.dart';
import 'package:taxi_app/features/driver/offers/presentation/cubit/offers_cubit.dart';
import 'package:taxi_app/features/driver/offers/presentation/widgets/offers_view_body.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OffersCubit(
        offerRepo: OfferRepoImpl(offerDataSource: OfferDataSourceImpl()),
      )..listenToOffers(),
      child: const Scaffold(body: SafeArea(child: OffersViewBody())),
    );
  }
}
