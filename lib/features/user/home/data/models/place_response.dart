import 'package:taxi_app/features/user/home/domain/entities/place_entity.dart';

class PlaceResponse {
  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  String? lat;
  String? lon;
  String? placeResponseClass;
  String? type;
  int? placeRank;
  double? importance;
  String? addresstype;
  String? name;
  String? displayName;
  List<dynamic>? boundingbox;

  PlaceResponse({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.placeResponseClass,
    this.type,
    this.placeRank,
    this.importance,
    this.addresstype,
    this.name,
    this.displayName,
    this.boundingbox,
  });

  factory PlaceResponse.fromJson(Map<String, dynamic> json) => PlaceResponse(
    placeId: json['place_id'] as int?,
    licence: json['licence'] as String?,
    osmType: json['osm_type'] as String?,
    osmId: json['osm_id'] as int?,
    lat: json['lat'] as String?,
    lon: json['lon'] as String?,
    placeResponseClass: json['class'] as String?,
    type: json['type'] as String?,
    placeRank: json['place_rank'] as int?,
    importance: (json['importance'] as num?)?.toDouble(),
    addresstype: json['addresstype'] as String?,
    name: json['name'] as String?,
    displayName: json['display_name'] as String?,
    boundingbox: json['boundingbox'] as List<dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'place_id': placeId,
    'licence': licence,
    'osm_type': osmType,
    'osm_id': osmId,
    'lat': lat,
    'lon': lon,
    'class': placeResponseClass,
    'type': type,
    'place_rank': placeRank,
    'importance': importance,
    'addresstype': addresstype,
    'name': name,
    'display_name': displayName,
    'boundingbox': boundingbox,
  };

  PlaceEntity toEntity() => PlaceEntity(
    placeId: placeId ?? 0,
    lat: num.tryParse(lat ?? '') ?? 0.0,
    lon: num.tryParse(lon ?? '') ?? 0.0,
    name: name ?? '',
    displayName: displayName ?? '',
  );
}
