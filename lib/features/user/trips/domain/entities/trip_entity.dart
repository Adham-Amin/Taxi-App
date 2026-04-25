class TripEntity {
  final String userName;
  final String driverName;
  final String originAddress;
  final String destinationAddress;
  final String status;
  final double price;
  final String date;

  TripEntity({
    required this.userName,
    required this.driverName,
    required this.originAddress,
    required this.destinationAddress,
    required this.status,
    required this.price,
    required this.date,
  });
}
