import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.type,
    required super.routeId,
    required super.latitude,
    required super.longitude,
    required super.bearing,
    required super.speed,
    required super.lastUpdate,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      type: _parseType(json['type'] as String?),
      routeId: json['routeId'] as String? ?? 'UNKNOWN',
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      bearing: (json['bearing'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(
          (json['timestamp'] as int) * 1000),
    );
  }

  static VehicleType _parseType(String? typeStr) {
    switch (typeStr?.toUpperCase()) {
      case 'BUS':
        return VehicleType.bus;
      case 'METRO':
        return VehicleType.metro;
      default:
        return VehicleType.unknown;
    }
  }
}
