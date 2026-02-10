import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/route_repository.dart';
import 'route_event.dart';
import 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final RouteRepository repository;

  RouteBloc({required this.repository}) : super(const RouteInitial()) {
    on<LoadAllRoutes>(_onLoadAllRoutes);
    on<LoadAllStations>(_onLoadAllStations);
    on<LoadNearbyStations>(_onLoadNearbyStations);
  }

  Future<void> _onLoadAllRoutes(
    LoadAllRoutes event,
    Emitter<RouteState> emit,
  ) async {
    emit(const RouteLoading());
    try {
      final routes = await repository.getAllRoutes();
      emit(RoutesLoaded(routes));
    } catch (e) {
      emit(RouteError('Failed to load routes: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAllStations(
    LoadAllStations event,
    Emitter<RouteState> emit,
  ) async {
    emit(const RouteLoading());
    try {
      final stations = await repository.getAllStations();
      emit(StationsLoaded(stations));
    } catch (e) {
      emit(RouteError('Failed to load stations: ${e.toString()}'));
    }
  }

  Future<void> _onLoadNearbyStations(
    LoadNearbyStations event,
    Emitter<RouteState> emit,
  ) async {
    emit(const RouteLoading());
    try {
      final stations = await repository.getNearbyStations(
        lat: event.lat,
        lng: event.lng,
        limit: event.limit,
      );
      emit(NearbyStationsLoaded(stations));
    } catch (e) {
      emit(RouteError('Failed to load nearby stations: ${e.toString()}'));
    }
  }
}
