import 'package:equatable/equatable.dart';

class Station extends Equatable {
  final String id;
  final String name;
  final String code;
  final int orderIndex;
  final Coordinates? coordinates;
  final double? distance; // Optional, for nearby stations

  const Station({
    required this.id,
    required this.name,
    required this.code,
    required this.orderIndex,
    this.coordinates,
    this.distance,
  });

  @override
  List<Object?> get props =>
      [id, name, code, orderIndex, coordinates, distance];
}

class Coordinates extends Equatable {
  final double lat;
  final double lng;

  const Coordinates({
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [lat, lng];
}
