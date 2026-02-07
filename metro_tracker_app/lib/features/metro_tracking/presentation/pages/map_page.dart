import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_state.dart';
import '../../domain/entities/vehicle.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kochi Coordinates
    const LatLng initialCenter = LatLng(10.0264, 76.3086); // Kaloor center

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Metro Tracker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.4),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          BlocBuilder<VehicleBloc, VehicleState>(
            builder: (context, state) {
              List<Marker> markers = [];
              if (state is VehicleLoaded) {
                markers = state.vehicles
                    .map((vehicle) => _buildMarker(vehicle))
                    .toList();
              }

              return FlutterMap(
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: 13.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
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

          // Bottom Info Panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomPanel(context),
          ),
        ],
      ),
    );
  }

  Marker _buildMarker(Vehicle vehicle) {
    final bool isMetro = vehicle.type == VehicleType.metro;
    final Color color = isMetro ? Colors.purple : Colors.blue;
    final IconData icon = isMetro ? Icons.train : Icons.directions_bus;

    return Marker(
      point: LatLng(vehicle.latitude, vehicle.longitude),
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Transit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              BlocBuilder<VehicleBloc, VehicleState>(
                builder: (context, state) {
                  if (state is VehicleLoaded) {
                    return Text(
                      '${state.vehicles.length} Active',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w500),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VehicleLoaded) {
                  if (state.vehicles.isEmpty) {
                    return const Center(child: Text('No vehicles active'));
                  }

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.vehicles.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final vehicle = state.vehicles[index];
                      final isMetro = vehicle.type == VehicleType.metro;

                      return Container(
                        width: 140,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMetro
                              ? Colors.purple.shade50
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMetro
                                ? Colors.purple.shade100
                                : Colors.blue.shade100,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isMetro ? Icons.train : Icons.directions_bus,
                                  size: 16,
                                  color: isMetro ? Colors.purple : Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isMetro ? 'Metro' : 'Bus',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isMetro ? Colors.purple : Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              vehicle.routeId,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${vehicle.speed.toStringAsFixed(0)} km/h',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is VehicleError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
