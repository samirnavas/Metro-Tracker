import 'package:equatable/equatable.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllRoutes extends RouteEvent {
  const LoadAllRoutes();
}

class LoadAllStations extends RouteEvent {
  const LoadAllStations();
}

class LoadNearbyStations extends RouteEvent {
  final double lat;
  final double lng;
  final int limit;

  const LoadNearbyStations({
    required this.lat,
    required this.lng,
    this.limit = 5,
  });

  @override
  List<Object?> get props => [lat, lng, limit];
}
