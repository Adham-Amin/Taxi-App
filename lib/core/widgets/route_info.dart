import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/widgets/address_section.dart';
import 'package:taxi_app/core/widgets/route_indicator.dart';

class RouteInfo extends StatelessWidget {
  const RouteInfo({
    super.key,
    required this.pickupAddress,
    required this.destinationAddress,
  });

  final String pickupAddress;
  final String destinationAddress;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RouteIndicator(),
          12.ws,
          Expanded(
            child: AddressSection(
              pickupAddress: pickupAddress,
              destinationAddress: destinationAddress,
            ),
          ),
        ],
      ),
    );
  }
}
