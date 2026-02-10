import 'package:equatable/equatable.dart';
import 'station.dart';

class MetroRoute extends Equatable {
  final String id;
  final String name;
  final String code;
  final String type;
  final String? description;
  final List<Station> stations;

  const MetroRoute({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.description,
    required this.stations,
  });

  @override
  List<Object?> get props => [id, name, code, type, description, stations];
}
