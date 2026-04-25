class RouteResponse {
  RouteResponse({
    required this.legs,
    required this.weightName,
    required this.geometry,
    required this.weight,
    required this.duration,
    required this.distance,
  });

  final List<Leg> legs;
  final String? weightName;
  final Geometry? geometry;
  final num? weight;
  final num? duration;
  final num? distance;

  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    return RouteResponse(
      legs: json["legs"] == null
          ? []
          : List<Leg>.from(json["legs"]!.map((x) => Leg.fromJson(x))),
      weightName: json["weight_name"],
      geometry: json["geometry"] == null
          ? null
          : Geometry.fromJson(json["geometry"]),
      weight: json["weight"],
      duration: json["duration"],
      distance: json["distance"],
    );
  }
}

class Geometry {
  Geometry({required this.coordinates, required this.type});

  final List<List<num>> coordinates;
  final String? type;

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      coordinates: json["coordinates"] == null
          ? []
          : List<List<num>>.from(
              json["coordinates"]!.map(
                (x) => x == null ? [] : List<num>.from(x!.map((x) => x)),
              ),
            ),
      type: json["type"],
    );
  }
}

class Leg {
  Leg({
    required this.steps,
    required this.weight,
    required this.summary,
    required this.duration,
    required this.distance,
  });

  final List<dynamic> steps;
  final num? weight;
  final String? summary;
  final num? duration;
  final num? distance;

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      steps: json["steps"] == null
          ? []
          : List<dynamic>.from(json["steps"]!.map((x) => x)),
      weight: json["weight"],
      summary: json["summary"],
      duration: json["duration"],
      distance: json["distance"],
    );
  }
}
