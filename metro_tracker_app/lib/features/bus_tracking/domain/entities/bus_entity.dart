class BusEntity {
  final String id;
  final String routeId;
  final double latitude;
  final double longitude;
  final double bearing;
  final double speed;
  final String label;

  const BusEntity({
    required this.id,
    required this.routeId,
    required this.latitude,
    required this.longitude,
    required this.bearing,
    required this.speed,
    required this.label,
  });
}
