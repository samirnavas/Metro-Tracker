import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';
import '../../domain/repositories/vehicle_repository.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repository;
  StreamSubscription? _vehicleSubscription;

  VehicleBloc({required this.repository}) : super(VehicleInitial()) {
    on<StartTracking>(_onStartTracking);
    on<UpdateVehicles>(_onUpdateVehicles);
  }

  void _onStartTracking(StartTracking event, Emitter<VehicleState> emit) {
    emit(VehicleLoading());
    _vehicleSubscription?.cancel();
    _vehicleSubscription = repository.getVehicleStream().listen(
          (vehicles) => add(UpdateVehicles(vehicles)),
          onError: (error) => emit(VehicleError(error.toString())),
        );
  }

  void _onUpdateVehicles(UpdateVehicles event, Emitter<VehicleState> emit) {
    emit(VehicleLoaded(event.vehicles));
  }

  @override
  Future<void> close() {
    _vehicleSubscription?.cancel();
    return super.close();
  }
}
