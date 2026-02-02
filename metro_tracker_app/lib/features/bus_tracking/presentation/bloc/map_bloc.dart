import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/bus_entity.dart';
import '../../domain/repositories/bus_repository.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final BusRepository busRepository;
  StreamSubscription? _busSubscription;
  
  // Hardcoded user location for "Favorites" logic (as requested in mock mode)
  // Real app would use Geolocator.getCurrentPosition()
  final double userLat = 9.9312;
  final double userLng = 76.2673;

  MapBloc({required this.busRepository}) : super(MapInitial()) {
    on<LoadMapEvent>(_onLoadMap);
    on<UpdateBusLocationsEvent>(_onUpdateBusLocations);
    on<SelectBusEvent>(_onSelectBus);
  }

  Future<void> _onLoadMap(LoadMapEvent event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      // Subscribe to stream
      _busSubscription?.cancel();
      _busSubscription = busRepository.getBusUpdates().listen((buses) {
        add(UpdateBusLocationsEvent(buses)); // Bridge stream to BLoC event
      });
    } catch (e) {
      emit(MapError("Failed to connect to live tracking: $e"));
    }
  }

  Future<void> _onUpdateBusLocations(
      UpdateBusLocationsEvent event, Emitter<MapState> emit) async {
    
    // Check for Geofence Alerts (Notification Logic)
    for (var bus in event.buses) {
      _checkGeofence(bus);
    }
    
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(buses: event.buses));
    } else {
      emit(MapLoaded(buses: event.buses));
    }
  }

  Future<void> _onSelectBus(SelectBusEvent event, Emitter<MapState> emit) async {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(selectedBus: event.bus));
    }
  }

  void _checkGeofence(BusEntity bus) {
    // Simple 1km distance check
    // In production, use Geolocator.distanceBetween()
    final double distanceInMeters = Geolocator.distanceBetween(
      userLat, userLng, bus.latitude, bus.longitude
    );

    if (distanceInMeters < 1000) {
      // Trigger Notification (Console log for now as placeholder for LocalNotificationService)
      print("ALERT: Bus ${bus.label} is nearby (${distanceInMeters.toStringAsFixed(0)}m)!");
    }
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }
}
