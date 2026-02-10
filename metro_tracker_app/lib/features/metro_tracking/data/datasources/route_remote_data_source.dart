import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';
import '../models/station_model.dart';

abstract class RouteRemoteDataSource {
  Future<List<RouteModel>> getAllRoutes();
  Future<RouteModel> getRouteById(String id);
  Future<List<StationModel>> getAllStations();
  Future<List<StationModel>> getNearbyStations({
    required double lat,
    required double lng,
    int limit = 5,
  });
}

class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  RouteRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<RouteModel>> getAllRoutes() async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/routes'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> routesJson = jsonData['data'];
      return routesJson.map((json) => RouteModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load routes');
    }
  }

  @override
  Future<RouteModel> getRouteById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/routes/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return RouteModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load route');
    }
  }

  @override
  Future<List<StationModel>> getAllStations() async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/stations'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> stationsJson = jsonData['data'];
      return stationsJson.map((json) => StationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

  @override
  Future<List<StationModel>> getNearbyStations({
    required double lat,
    required double lng,
    int limit = 5,
  }) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/stations/nearby?lat=$lat&lng=$lng&limit=$limit'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> stationsJson = jsonData['data'];
      return stationsJson.map((json) => StationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load nearby stations');
    }
  }
}
