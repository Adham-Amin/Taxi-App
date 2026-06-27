import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_app/core/utils/fare_calculator.dart';

void main() {
  group('FareCalculator.suggestedFare', () {
    test('returns the minimum fare for the base distance and below', () {
      expect(FareCalculator.suggestedFare(0), FareCalculator.minFare);
      expect(FareCalculator.suggestedFare(1.0), 40);
      expect(FareCalculator.suggestedFare(1.5), 40);
    });

    test('adds 35 per km after the first 1.5 km', () {
      expect(FareCalculator.suggestedFare(2.5), 75); // 40 + 1*35
      expect(FareCalculator.suggestedFare(3.5), 110); // 40 + 2*35
    });

    test('charges fractional distance proportionally', () {
      expect(FareCalculator.suggestedFare(2.0), 40 + 0.5 * 35); // 57.5
      expect(FareCalculator.suggestedFare(10.0), 40 + 8.5 * 35); // 337.5
    });

    test('never returns below the minimum fare', () {
      expect(FareCalculator.suggestedFare(-5), FareCalculator.minFare);
      expect(
        FareCalculator.suggestedFare(0.1),
        greaterThanOrEqualTo(FareCalculator.minFare),
      );
    });
  });

  group('FareCalculator.minOfferFor', () {
    test('equals the suggested fare (the floor a user may offer)', () {
      expect(FareCalculator.minOfferFor(1.0), 40);
      expect(FareCalculator.minOfferFor(2.5), 75);
    });

    test('is never below the global minimum', () {
      expect(
        FareCalculator.minOfferFor(0),
        greaterThanOrEqualTo(FareCalculator.minFare),
      );
    });
  });
}
