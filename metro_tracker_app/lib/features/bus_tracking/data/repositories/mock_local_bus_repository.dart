import 'dart:async';
import 'dart:math';
import '../../domain/entities/bus_entity.dart';
import '../../domain/repositories/bus_repository.dart';

class MockLocalBusRepository implements BusRepository {
  final Random _random = Random();

  // Initial API-like data
  List<BusEntity> _buses = [
    const BusEntity(
        id: 'bus-1',
        routeId: 'route-1',
        latitude: 9.9312,
        longitude: 76.2673,
        bearing: 0,
        speed: 15,
        label: 'KMRL Feeder 1'),
    const BusEntity(
        id: 'bus-2',
        routeId: 'route-2',
        latitude: 9.9350,
        longitude: 76.2600,
        bearing: 45,
        speed: 20,
        label: 'KMRL Feeder 2'),
    const BusEntity(
        id: 'bus-3',
        routeId: 'route-1',
        latitude: 9.9400,
        longitude: 76.2700,
        bearing: 90,
        speed: 12,
        label: 'KMRL Feeder 3'),
    const BusEntity(
        id: 'bus-4',
        routeId: 'route-3',
        latitude: 9.9250,
        longitude: 76.2650,
        bearing: 180,
        speed: 18,
        label: 'KMRL Feeder 4'),
    const BusEntity(
        id: 'bus-5',
        routeId: 'route-2',
        latitude: 9.9300,
        longitude: 76.2750,
        bearing: 270,
        speed: 25,
        label: 'KMRL Feeder 5'),
  ];

  @override
  Stream<List<BusEntity>> getBusUpdates() {
    // Emit updates every 3 seconds
    return Stream.periodic(const Duration(seconds: 3), (_) {
      _buses = _buses.map((bus) => _moveBus(bus)).toList();
      return _buses;
    }); // Emit immediately roughly? periodic waits for first duration.
    // To emit immediately we might need a startWith, but standard Stream.periodic is fine for a mock.
  }

  @override
  Future<void> disconnect() async {
    // No specific cleanup needed for this simple mock
  }

  BusEntity _moveBus(BusEntity bus) {
    // Simulate slight movement (jitter)
    final double latDelta = (_random.nextDouble() - 0.5) * 0.001;
    final double lngDelta = (_random.nextDouble() - 0.5) * 0.001;

    // Update bearing and speed randomly
    final double newBearing = _random.nextDouble() * 360;
    final double newSpeed = 10 + _random.nextDouble() * 20;

    return BusEntity(
      id: bus.id,
      routeId: bus.routeId,
      latitude: bus.latitude + latDelta,
      longitude: bus.longitude + lngDelta,
      bearing: newBearing,
      speed: newSpeed,
      label: bus.label,
    );
  }
}
