import '../../domain/entities/route.dart';
import '../../domain/entities/station.dart';

abstract class RouteRepository {
  Future<List<MetroRoute>> getAllRoutes();
  Future<MetroRoute> getRouteById(String id);
  Future<List<Station>> getAllStations();
  Future<List<Station>> getNearbyStations({
    required double lat,
    required double lng,
    int limit = 5,
  });
}
