import 'package:equatable/equatable.dart';
import '../../domain/entities/bus_entity.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class LoadMapEvent extends MapEvent {}

class UpdateBusLocationsEvent extends MapEvent {
  final List<BusEntity> buses;

  const UpdateBusLocationsEvent(this.buses);

  @override
  List<Object> get props => [buses];
}

class SelectBusEvent extends MapEvent {
  final BusEntity bus;

  const SelectBusEvent(this.bus);

  @override
  List<Object> get props => [bus];
}
