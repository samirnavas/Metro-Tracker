import '../entities/bus_entity.dart';

abstract class BusRepository {
  Stream<List<BusEntity>> getBusUpdates();
  Future<void> disconnect();
}
