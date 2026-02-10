import '../../domain/entities/route.dart';
import '../../domain/entities/station.dart';
import '../../domain/repositories/route_repository.dart';
import '../datasources/route_remote_data_source.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDataSource remoteDataSource;

  RouteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MetroRoute>> getAllRoutes() async {
    try {
      return await remoteDataSource.getAllRoutes();
    } catch (e) {
      throw Exception('Failed to fetch routes: $e');
    }
  }

  @override
  Future<MetroRoute> getRouteById(String id) async {
    try {
      return await remoteDataSource.getRouteById(id);
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    }
  }

  @override
  Future<List<Station>> getAllStations() async {
    try {
      return await remoteDataSource.getAllStations();
    } catch (e) {
      throw Exception('Failed to fetch stations: $e');
    }
  }

  @override
  Future<List<Station>> getNearbyStations({
    required double lat,
    required double lng,
    int limit = 5,
  }) async {
    try {
      return await remoteDataSource.getNearbyStations(
        lat: lat,
        lng: lng,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to fetch nearby stations: $e');
    }
  }
}
