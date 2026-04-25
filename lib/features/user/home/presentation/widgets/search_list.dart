import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';

class SearchList extends StatelessWidget {
  const SearchList({super.key, required this.onTap});

  final Function(PlaceEntity) onTap;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    var placeList = context.watch<MapCubit>().distinationplaces;
    return BlocBuilder<MapCubit, GoogleMapState>(
      builder: (context, state) {
        if (state is PlacesLoaded) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => 6.hs,
            itemCount: placeList.length > 3 ? 3 : placeList.length,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: isLight ? AppColors.white : AppColors.darkGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightGreen),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGreen.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                onTap: () => onTap(placeList[index]),
                leading: const Icon(Icons.location_on, color: AppColors.green),
                title: Text(placeList[index].displayName, maxLines: 2),
              ),
            ),
          );
        } else if (state is GoogleMapError) {
          return Center(child: Text(state.failure));
        }
        return Container();
      },
    );
  }
}
