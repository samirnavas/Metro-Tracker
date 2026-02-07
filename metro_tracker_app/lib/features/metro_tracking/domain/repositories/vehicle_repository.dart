import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Stream<List<Vehicle>> getVehicleStream();
}
