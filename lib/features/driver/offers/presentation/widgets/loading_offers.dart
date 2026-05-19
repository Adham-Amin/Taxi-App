import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/driver/offers/presentation/widgets/offer_card.dart';

class LoadingOffers extends StatelessWidget {
  const LoadingOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        itemCount: 2,
        separatorBuilder: (_, _) => 16.hs,
        itemBuilder: (context, index) {
          return OfferCard(offer: OfferEntity.empty(), onAccept: () {});
        },
      ),
    );
  }
}
