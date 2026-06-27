import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/utils/egypt_geo.dart';

void main() {
  group('EgyptGeo.isInside', () {
    test('returns true for points inside Egypt', () {
      expect(EgyptGeo.isInside(30.0444, 31.2357), isTrue); // Cairo
      expect(EgyptGeo.isInside(24.0889, 32.8998), isTrue); // Aswan
      expect(EgyptGeo.isInside(31.2001, 29.9187), isTrue); // Alexandria
    });

    test('returns false for points outside Egypt', () {
      expect(EgyptGeo.isInside(24.7136, 46.6753), isFalse); // Riyadh
      expect(EgyptGeo.isInside(51.5072, -0.1276), isFalse); // London
      expect(EgyptGeo.isInside(27.0, 24.0), isFalse); // just west of the border
    });

    test('treats the box edges as inside', () {
      expect(EgyptGeo.isInside(EgyptGeo.minLat, EgyptGeo.minLng), isTrue);
      expect(EgyptGeo.isInside(EgyptGeo.maxLat, EgyptGeo.maxLng), isTrue);
    });
  });

  group('EgyptGeo.bounds', () {
    test('corners match the rectangle', () {
      expect(EgyptGeo.bounds.southwest, const LatLng(22.0, 24.7));
      expect(EgyptGeo.bounds.northeast, const LatLng(31.9, 37.0));
    });
  });

  group('EgyptGeo.nominatimQuerySuffix', () {
    test('restricts to Egypt with a bounded viewbox', () {
      expect(EgyptGeo.nominatimQuerySuffix, contains('countrycodes=eg'));
      expect(EgyptGeo.nominatimQuerySuffix, contains('bounded=1'));
      expect(
        EgyptGeo.nominatimQuerySuffix,
        contains('viewbox=24.7,31.9,37.0,22.0'),
      );
    });
  });
}
