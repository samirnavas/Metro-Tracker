import '../../domain/entities/station.dart';

class StationModel extends Station {
  const StationModel({
    required super.id,
    required super.name,
    required super.code,
    required super.orderIndex,
    super.coordinates,
    super.distance,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      orderIndex: json['orderIndex'] as int,
      coordinates: json['coordinates'] != null
          ? CoordinatesModel.fromJson(json['coordinates'])
          : null,
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'orderIndex': orderIndex,
      if (coordinates != null)
        'coordinates': {
          'lat': coordinates!.lat,
          'lng': coordinates!.lng,
        },
      if (distance != null) 'distance': distance,
    };
  }
}

class CoordinatesModel extends Coordinates {
  const CoordinatesModel({
    required super.lat,
    required super.lng,
  });

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}
