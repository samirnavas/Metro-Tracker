import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_state.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kochi Coordinates
    const LatLng initialCenter = LatLng(9.9312, 76.2673);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KMRL Live Tracking'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005696), Color(0xFF00A8E8)],
            ),
          ),
        ),
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          List<Marker> markers = [];

          if (state is MapLoaded) {
            markers = state.buses.map((bus) {
              return Marker(
                point: LatLng(bus.latitude, bus.longitude),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.directions_bus,
                  color: Color(0xFF005696),
                  size: 30,
                ),
              );
            }).toList();
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.metro_tracker_app',
              ),
              MarkerLayer(
                markers: markers,
              ),
              // Optional: Add a credit for OpenStreetMap
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
