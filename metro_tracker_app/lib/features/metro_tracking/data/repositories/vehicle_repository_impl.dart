import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_data_source.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Vehicle>> getVehicleStream() {
    return remoteDataSource
        .getVehicleStream()
        .map((list) => List<Vehicle>.from(list));
  }
}
