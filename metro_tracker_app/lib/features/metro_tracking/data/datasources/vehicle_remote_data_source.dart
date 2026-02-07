import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../data/models/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Stream<List<VehicleModel>> getVehicleStream();
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final WebSocketChannel channel;

  VehicleRemoteDataSourceImpl({required this.channel});

  @override
  Stream<List<VehicleModel>> getVehicleStream() {
    return channel.stream.map((data) {
      final decoded = json.decode(data);
      final List<dynamic> vehicles = decoded['vehicles'];

      return vehicles.map((json) => VehicleModel.fromJson(json)).toList();
    });
  }
}
