import 'package:equatable/equatable.dart';

enum VehicleType { bus, metro, unknown }

class Vehicle extends Equatable {
  final String id;
  final VehicleType type;
  final String routeId;
  final double latitude;
  final double longitude;
  final double bearing;
  final double speed;
  final DateTime lastUpdate;

  const Vehicle({
    required this.id,
    required this.type,
    required this.routeId,
    required this.latitude,
    required this.longitude,
    required this.bearing,
    required this.speed,
    required this.lastUpdate,
  });

  @override
  List<Object?> get props =>
      [id, type, routeId, latitude, longitude, bearing, speed, lastUpdate];
}
