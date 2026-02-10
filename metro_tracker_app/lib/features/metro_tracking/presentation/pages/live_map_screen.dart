import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_state.dart';
import '../../domain/entities/vehicle.dart';
import 'dart:math' as math;

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  // Kochi Coordinates - Center
  static const LatLng _initialCenter = LatLng(10.0264, 76.3086);
  final MapController _mapController = MapController();

  Vehicle? _selectedVehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          BlocBuilder<VehicleBloc, VehicleState>(
            builder: (context, state) {
              List<Marker> markers = [];
              if (state is VehicleLoaded) {
                markers = state.vehicles
                    .map((vehicle) => _buildMarker(vehicle))
                    .toList();
              }

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialCenter,
                  initialZoom: 13.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                  onTap: (_, __) {
                    if (_selectedVehicle != null) {
                      setState(() {
                        _selectedVehicle = null;
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.metro_tracker_app',
                  ),
                  MarkerLayer(markers: markers),
                ],
              );
            },
          ),

          // Floating Action Buttons (Recenter)
          Positioned(
            right: 16,
            bottom: _selectedVehicle != null
                ? 220
                : 16, // Adjust based on panel height
            child: FloatingActionButton(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              mini: true,
              onPressed: () {
                _mapController.move(_initialCenter, 13.0);
              },
              child: const Icon(Icons.my_location),
            ),
          ),

          // Vehicle Details Panel
          if (_selectedVehicle != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildVehicleDetailsPanel(_selectedVehicle!),
            ),
        ],
      ),
    );
  }

  Marker _buildMarker(Vehicle vehicle) {
    final bool isMetro = vehicle.type == VehicleType.metro;
    final Color color = isMetro ? Colors.purple : AppColors.primary;

    return Marker(
      point: LatLng(vehicle.latitude, vehicle.longitude),
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedVehicle = vehicle;
          });
          _mapController.move(
              LatLng(vehicle.latitude, vehicle.longitude), 15.0);
        },
        child: Transform.rotate(
          angle: (vehicle.bearing * (math.pi / 180)), // Convert deg to rad
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: color, width: 2),
            ),
            padding: const EdgeInsets.all(4),
            child: Icon(
              isMetro ? Icons.train : Icons.directions_bus,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsPanel(Vehicle vehicle) {
    final bool isMetro = vehicle.type == VehicleType.metro;
    final Color color = isMetro ? Colors.purple : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(isMetro ? Icons.train : Icons.directions_bus,
                    color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.routeId,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  Text(
                    isMetro ? "Metro Train" : "Feeder Bus",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "On Time",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(Icons.speed,
                  "${vehicle.speed.toStringAsFixed(0)} km/h", "Speed"),
              _buildInfoItem(
                  Icons.people, "Moderate", "Crowd"), // Static data for now
              _buildInfoItem(
                  Icons.schedule, "5 min", "ETA"), // Static data for now
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textMain,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
