import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/widgets/custom_error.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/driver/offers/presentation/cubit/offers_cubit.dart';
import 'package:taxi_app/features/driver/offers/presentation/widgets/loading_offers.dart';
import 'package:taxi_app/features/driver/offers/presentation/widgets/offer_card.dart';
import 'package:taxi_app/features/driver/offers/presentation/widgets/offers_header.dart';

class OffersViewBody extends StatelessWidget {
  const OffersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OffersHeader(),
          SizedBox(height: 24.h),
          Expanded(
            child: BlocConsumer<OffersCubit, OffersState>(
              listener: (context, state) {
                if (state is OffersAcceptLoaded) {
                  context.push(AppRoutes.driverMap, extra: state.offer);
                }
              },
              builder: (context, state) {
                if (state is OffersLoading) {
                  return LoadingOffers();
                }
                if (state is OffersError) {
                  return CustomError(message: state.message);
                }
                if (state is OffersLoaded) {
                  if (state.offers.isEmpty) {
                    return CustomError(
                      message: LocaleKeys.no_requests.tr(),
                    );
                  }
                  return ListView.separated(
                    itemCount: state.offers.length,
                    separatorBuilder: (_, _) => 16.hs,
                    itemBuilder: (context, index) {
                      final offer = state.offers[index];
                      return OfferCard(
                        offer: offer,
                        onAccept: () {
                          final user = Prefs.getUser()!;
                          context.read<OffersCubit>().acceptOffer(
                            offerId: offer.id,
                            offer: offer,
                            driver: DriverModel(
                              lat: user.lat,
                              lng: user.lng,
                              id: user.id,
                              name: user.name ?? '',
                              email: user.email ?? '',
                              phone: user.phone ?? '',
                              image: user.image ?? '',
                              carModel: user.carModel ?? '',
                              carColor: user.carColor ?? '',
                              carPlateNumber: user.carPlateNumber ?? '',
                              role: user.role ?? 'driver',
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
