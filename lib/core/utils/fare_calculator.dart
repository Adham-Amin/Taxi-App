import 'dart:math' as math;

/// Pure fare math for the ride-negotiation flow. No Flutter / no I/O so it is
/// cheap, deterministic and unit-testable.
///
/// Pricing rules (EGP):
/// - Minimum fare = 40.
/// - First 1.5 km is covered by the 40 base.
/// - Every kilometre after 1.5 km adds 35 (charged proportionally for
///   fractional distance).
/// - The fare is never below the minimum.
abstract class FareCalculator {
  FareCalculator._();

  static const double minFare = 40;
  static const double baseDistanceKm = 1.5;
  static const double perKm = 35;

  /// Suggested fare for a trip of [distanceKm] kilometres.
  static double suggestedFare(double distanceKm) {
    if (distanceKm <= baseDistanceKm) return minFare;
    final extraKm = distanceKm - baseDistanceKm;
    final fare = minFare + extraKm * perKm;
    return math.max(minFare, fare);
  }

  /// The lowest fare a user is allowed to offer for [distanceKm] — never below
  /// the global minimum and never below the suggested fare's base.
  static double minOfferFor(double distanceKm) =>
      math.max(minFare, suggestedFare(distanceKm));
}
