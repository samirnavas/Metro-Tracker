import 'package:equatable/equatable.dart';
import '../../domain/entities/bus_entity.dart';

abstract class MapState extends Equatable {
  const MapState();
  
  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<BusEntity> buses;
  final BusEntity? selectedBus;

  const MapLoaded({
    this.buses = const [],
    this.selectedBus,
  });

  MapLoaded copyWith({
    List<BusEntity>? buses,
    BusEntity? selectedBus,
  }) {
    return MapLoaded(
      buses: buses ?? this.buses,
      selectedBus: selectedBus ?? this.selectedBus,
    );
  }

  @override
  List<Object?> get props => [buses, selectedBus];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}
