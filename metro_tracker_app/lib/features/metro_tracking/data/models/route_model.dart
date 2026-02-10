import '../../domain/entities/route.dart';
import 'station_model.dart';

class RouteModel extends MetroRoute {
  const RouteModel({
    required super.id,
    required super.name,
    required super.code,
    required super.type,
    super.description,
    required super.stations,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      stations: (json['stations'] as List<dynamic>)
          .map((station) =>
              StationModel.fromJson(station as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      if (description != null) 'description': description,
      'stations': stations
          .map((station) => (station as StationModel).toJson())
          .toList(),
    };
  }
}
