import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/features/user/features/home/presentation/manager/map_cubit/google_map_cubit.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/search_list.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key, required this.destination});

  final Function(LocationModel) destination;

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  late TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          hintText: 'Where to?',
          controller: _searchController,
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 400), () {
              if (_searchController.text.isNotEmpty) {
                context.read<MapCubit>().getDistinationPlaces(query: value);
              } else {
                context.read<MapCubit>().clearPlaces();
              }
            });
          },
        ),
        const SizedBox(height: 12),
        SearchList(
          onTap: (place) {
            _searchController.text = place.displayName;
            context.read<MapCubit>().clearPlaces();
            var dest = LocationModel(
              lat: place.lat.toDouble(),
              lng: place.lon.toDouble(),
              fullAddress: place.displayName,
            );
            widget.destination(dest);
          },
        ),
      ],
    );
  }
}
