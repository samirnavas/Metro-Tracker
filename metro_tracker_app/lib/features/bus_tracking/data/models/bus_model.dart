import '../../domain/entities/bus_entity.dart';

class BusModel extends BusEntity {
  const BusModel({
    required String id,
    required String routeId,
    required double latitude,
    required double longitude,
    required double bearing,
    required double speed,
    required String label,
  }) : super(
          id: id,
          routeId: routeId,
          latitude: latitude,
          longitude: longitude,
          bearing: bearing,
          speed: speed,
          label: label,
        );

  factory BusModel.fromJson(Map<String, dynamic> json) {
    // Navigate the complicated GTFS-Realtime structure (as mocked in backend)
    // Structure: entity -> vehicle -> position
    
    final vehicle = json['vehicle'];
    final position = vehicle['position'];
    
    return BusModel(
      id: vehicle['vehicle']['id'],
      routeId: vehicle['trip']['routeId'],
      latitude: (position['latitude'] as num).toDouble(),
      longitude: (position['longitude'] as num).toDouble(),
      bearing: (position['bearing'] as num).toDouble(),
      speed: (position['speed'] as num).toDouble(),
      label: vehicle['vehicle']['label'],
    );
  }
}
