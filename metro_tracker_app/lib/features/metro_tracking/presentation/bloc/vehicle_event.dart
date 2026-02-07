import 'package:equatable/equatable.dart';
import '../../domain/entities/vehicle.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object> get props => [];
}

class StartTracking extends VehicleEvent {}

class UpdateVehicles extends VehicleEvent {
  final List<Vehicle> vehicles;

  const UpdateVehicles(this.vehicles);

  @override
  List<Object> get props => [vehicles];
}
