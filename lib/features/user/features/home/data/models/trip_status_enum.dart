enum TripStatus {
  searching,
  accepted,
  arrived,
  onTrip,
  done,
  canceled,
  completed,
}

extension TripStatusExtension on TripStatus {
  String get value => name;

  static TripStatus fromString(String status) {
    return TripStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TripStatus.searching,
    );
  }
}
