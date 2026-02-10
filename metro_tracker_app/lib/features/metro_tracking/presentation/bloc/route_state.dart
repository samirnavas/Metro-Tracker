import 'package:equatable/equatable.dart';
import '../../domain/entities/route.dart';
import '../../domain/entities/station.dart';

abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object?> get props => [];
}

class RouteInitial extends RouteState {
  const RouteInitial();
}

class RouteLoading extends RouteState {
  const RouteLoading();
}

class RoutesLoaded extends RouteState {
  final List<MetroRoute> routes;

  const RoutesLoaded(this.routes);

  @override
  List<Object?> get props => [routes];
}

class StationsLoaded extends RouteState {
  final List<Station> stations;

  const StationsLoaded(this.stations);

  @override
  List<Object?> get props => [stations];
}

class NearbyStationsLoaded extends RouteState {
  final List<Station> stations;

  const NearbyStationsLoaded(this.stations);

  @override
  List<Object?> get props => [stations];
}

class RouteError extends RouteState {
  final String message;

  const RouteError(this.message);

  @override
  List<Object?> get props => [message];
}
