import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Kochi Coordinates
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(9.9312, 76.2673),
    zoom: 14.0,
  );

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KMRL Live Tracking'),
        backgroundColor: Colors.transparent, // Glassmorphism aesthetic
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005696), Color(0xFF00A8E8)],
            ),
          ),
        ),
      ),
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapLoaded) {
            _updateMarkers(state);
          }
        },
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MapError) {
              return Center(child: Text(state.message));
            }
            
            return GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            );
          },
        ),
      ),
    );
  }

  void _updateMarkers(MapLoaded state) {
    // Convert BusEntities to Google Map Markers
    final newMarkers = state.buses.map((bus) {
      return Marker(
        markerId: MarkerId(bus.id),
        position: LatLng(bus.latitude, bus.longitude),
        infoWindow: InfoWindow(
          title: bus.label,
          snippet: 'Speed: ${bus.speed.toStringAsFixed(1)} km/h',
        ),
        rotation: bus.bearing,
        // Using default hue for now, add custom bitmap in production
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    }).toSet();

    setState(() {
      _markers = newMarkers;
    });
  }
}
