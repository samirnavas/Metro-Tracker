import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../domain/entities/bus_entity.dart';
import '../../domain/repositories/bus_repository.dart';
import '../models/bus_model.dart';

class BusRepositoryImpl implements BusRepository {
  final WebSocketChannel channel;

  BusRepositoryImpl({required this.channel});

  @override
  Stream<List<BusEntity>> getBusUpdates() {
    return channel.stream.map((data) {
      try {
        final decoded = jsonDecode(data);
        final List<dynamic> entities = decoded['entity'] ?? [];
        
        return entities
            .map((e) => BusModel.fromJson(e))
            .toList();
      } catch (e) {
        print("Error parsing GTFS data: $e");
        return [];
      }
    });
  }

  @override
  Future<void> disconnect() async {
    await channel.sink.close();
  }
}
