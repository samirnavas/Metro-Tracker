# Flutter App Refactoring Guide: Linear Tracking UI

## 🎯 Objective
Transform the Metro Tracker app from a map-based view to a **linear timeline view** (similar to "Where Is My Train" app).

## 📋 Phase 1: Update Data Models

### 1.1 Create New Entities

#### Station Entity
**File:** `lib/features/metro_tracking/domain/entities/station.dart`

```dart
import 'package:equatable/equatable.dart';

class Station extends Equatable {
  final String id;
  final String name;
  final String code;
  final int orderIndex;
  final double? latitude;   // Optional for future map integration
  final double? longitude;

  const Station({
    required this.id,
    required this.name,
    required this.code,
    required this.orderIndex,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [id, name, code, orderIndex, latitude, longitude];
}
```

#### Route Entity
**File:** `lib/features/metro_tracking/domain/entities/route.dart`

```dart
import 'package:equatable/equatable.dart';
import 'station.dart';

enum RouteType { metro, bus }

class MetroRoute extends Equatable {
  final String id;
  final String name;
  final String code;
  final RouteType type;
  final String? description;
  final List<Station> stations;

  const MetroRoute({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.description,
    required this.stations,
  });

  @override
  List<Object?> get props => [id, name, code, type, description, stations];
}
```

#### Updated Vehicle Entity
**File:** `lib/features/metro_tracking/domain/entities/vehicle.dart` (REPLACE)

```dart
import 'package:equatable/equatable.dart';
import 'station.dart';

enum VehicleType { bus, metro, unknown }

class Vehicle extends Equatable {
  final String id;
  final VehicleType type;
  final String routeId;
  final String routeName;
  final String routeCode;
  final Station currentStation;
  final Station? nextStation;
  final double progress;  // 0.0 to 1.0
  final DateTime lastUpdate;

  const Vehicle({
    required this.id,
    required this.type,
    required this.routeId,
    required this.routeName,
    required this.routeCode,
    required this.currentStation,
    this.nextStation,
    required this.progress,
    required this.lastUpdate,
  });

  // Helper: Get interpolated position for timeline
  double get timelinePosition {
    if (nextStation == null) return currentStation.orderIndex.toDouble();
    return currentStation.orderIndex + progress;
  }

  @override
  List<Object?> get props => [
        id,
        type,
        routeId,
        routeName,
        routeCode,
        currentStation,
        nextStation,
        progress,
        lastUpdate,
      ];
}
```

### 1.2 Create Data Models

#### Station Model
**File:** `lib/features/metro_tracking/data/models/station_model.dart`

```dart
import '../../domain/entities/station.dart';

class StationModel extends Station {
  const StationModel({
    required super.id,
    required super.name,
    required super.code,
    required super.orderIndex,
    super.latitude,
    super.longitude,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      orderIndex: json['orderIndex'] as int,
      latitude: json['coordinates']?['lat'] as double?,
      longitude: json['coordinates']?['lng'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'orderIndex': orderIndex,
      if (latitude != null && longitude != null)
        'coordinates': {'lat': latitude, 'lng': longitude},
    };
  }
}
```

#### Route Model
**File:** `lib/features/metro_tracking/data/models/route_model.dart`

```dart
import '../../domain/entities/route.dart';
import 'station_model.dart';

class RouteModel extends MetroRoute {
  const RouteModel({
    required super.id,
    required super.name,
    required super.code,
    required super.type,
    super.description,
    required super.stations,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      type: _parseRouteType(json['type'] as String),
      description: json['description'] as String?,
      stations: (json['stations'] as List)
          .map((s) => StationModel.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  static RouteType _parseRouteType(String type) {
    return type.toUpperCase() == 'METRO' ? RouteType.metro : RouteType.bus;
  }
}
```

#### Updated Vehicle Model
**File:** `lib/features/metro_tracking/data/models/vehicle_model.dart` (REPLACE)

```dart
import '../../domain/entities/vehicle.dart';
import 'station_model.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.type,
    required super.routeId,
    required super.routeName,
    required super.routeCode,
    required super.currentStation,
    super.nextStation,
    required super.progress,
    required super.lastUpdate,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      type: _parseType(json['type'] as String?),
      routeId: json['routeId'] as String,
      routeName: json['routeName'] as String? ?? 'Unknown Route',
      routeCode: json['routeCode'] as String? ?? 'N/A',
      currentStation: StationModel.fromJson(
          json['currentStation'] as Map<String, dynamic>),
      nextStation: json['nextStation'] != null
          ? StationModel.fromJson(json['nextStation'] as Map<String, dynamic>)
          : null,
      progress: (json['progress'] as num).toDouble(),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(
          (json['timestamp'] as int) * 1000),
    );
  }

  static VehicleType _parseType(String? typeStr) {
    switch (typeStr?.toUpperCase()) {
      case 'BUS':
        return VehicleType.bus;
      case 'METRO':
        return VehicleType.metro;
      default:
        return VehicleType.unknown;
    }
  }
}
```

## 📋 Phase 2: Update WebSocket Data Source

### Update Remote Data Source
**File:** `lib/features/metro_tracking/data/datasources/vehicle_remote_data_source.dart`

Add route fetching capability:

```dart
abstract class VehicleRemoteDataSource {
  Stream<List<VehicleModel>> getVehicleUpdates();
  Future<List<RouteModel>> getRoutes();
  void dispose();
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final WebSocketChannel channel;
  final StreamController<List<VehicleModel>> _vehicleController;
  final Map<String, RouteModel> _routesCache = {};

  // ... existing implementation ...

  @override
  Future<List<RouteModel>> getRoutes() async {
    // Send request for routes
    channel.sink.add(jsonEncode({'type': 'GET_ROUTES'}));
    
    // Wait for response (implement proper response handling)
    // For now, return cached routes
    return _routesCache.values.toList();
  }

  void _handleMessage(dynamic message) {
    final data = jsonDecode(message);
    
    switch (data['type']) {
      case 'ROUTES':
        _handleRoutesMessage(data['data']);
        break;
      case 'VEHICLE_UPDATE':
        _handleVehicleUpdate(data);
        break;
    }
  }

  void _handleRoutesMessage(List<dynamic> routesData) {
    for (final routeJson in routesData) {
      final route = RouteModel.fromJson(routeJson);
      _routesCache[route.id] = route;
    }
  }
}
```

## 📋 Phase 3: Create Timeline UI

### 3.1 Timeline Screen
**File:** `lib/features/metro_tracking/presentation/pages/timeline_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_state.dart';
import '../widgets/route_timeline.dart';

class TimelineScreen extends StatelessWidget {
  final String routeId;

  const TimelineScreen({super.key, required this.routeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        backgroundColor: const Color(0xFF00A9A5), // Metro teal
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is VehicleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                ],
              ),
            );
          }
          
          if (state is VehicleLoaded) {
            // Filter vehicles for this route
            final routeVehicles = state.vehicles
                .where((v) => v.routeId == routeId)
                .toList();
            
            // Get route info (you'll need to add route to state)
            // For now, assume we have the route
            
            return RouteTimeline(
              route: state.currentRoute!, // Add this to VehicleState
              vehicles: routeVehicles,
            );
          }
          
          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
```

### 3.2 Route Timeline Widget
**File:** `lib/features/metro_tracking/presentation/widgets/route_timeline.dart`

```dart
import 'package:flutter/material.dart';
import '../../domain/entities/route.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/station.dart';
import 'station_marker.dart';
import 'vehicle_marker.dart';

class RouteTimeline extends StatelessWidget {
  final MetroRoute route;
  final List<Vehicle> vehicles;

  const RouteTimeline({
    super.key,
    required this.route,
    required this.vehicles,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stationCount = route.stations.length;
        final stationHeight = (constraints.maxHeight - 100) / stationCount;

        return Stack(
          children: [
            // Vertical timeline line
            Positioned(
              left: 40,
              top: 50,
              bottom: 50,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF00A9A5), // Metro teal
                      const Color(0xFF00A9A5).withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),

            // Stations
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 50),
              itemCount: route.stations.length,
              itemBuilder: (context, index) {
                final station = route.stations[index];
                return StationMarker(
                  station: station,
                  height: stationHeight,
                );
              },
            ),

            // Vehicles (animated)
            ...vehicles.map((vehicle) => _buildVehicleMarker(
                  vehicle,
                  stationHeight,
                )),
          ],
        );
      },
    );
  }

  Widget _buildVehicleMarker(Vehicle vehicle, double stationHeight) {
    final yPosition = 50 + (vehicle.timelinePosition * stationHeight);

    return AnimatedPositioned(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      left: vehicle.type == VehicleType.metro ? 20 : 15,
      top: yPosition - 20, // Center on position
      child: VehicleMarker(
        vehicle: vehicle,
      ),
    );
  }
}
```

### 3.3 Station Marker Widget
**File:** `lib/features/metro_tracking/presentation/widgets/station_marker.dart`

```dart
import 'package:flutter/material.dart';
import '../../domain/entities/station.dart';

class StationMarker extends StatelessWidget {
  final Station station;
  final double height;

  const StationMarker({
    super.key,
    required this.station,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Station dot
          Container(
            width: 80,
            alignment: Alignment.center,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFF00A9A5),
                  width: 3,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Station info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  station.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  station.code,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3.4 Vehicle Marker Widget
**File:** `lib/features/metro_tracking/presentation/widgets/vehicle_marker.dart`

```dart
import 'package:flutter/material.dart';
import '../../domain/entities/vehicle.dart';

class VehicleMarker extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleMarker({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isMetro = vehicle.type == VehicleType.metro;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMetro
            ? const Color(0xFF00A9A5) // Metro teal
            : const Color(0xFFFF6B35), // Bus orange
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isMetro
                    ? const Color(0xFF00A9A5)
                    : const Color(0xFFFF6B35))
                .withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMetro ? Icons.train : Icons.directions_bus,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            vehicle.id.split('-').last, // Show just the number
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
```

## 📋 Phase 4: Update Navigation

### Update Root Screen
**File:** `lib/features/metro_tracking/presentation/pages/root_screen.dart`

Replace the map navigation with timeline:

```dart
// Change from:
// Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));

// To:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TimelineScreen(routeId: selectedRoute.id),
  ),
);
```

## 📋 Phase 5: Remove Map Dependencies

### Update pubspec.yaml
Remove or comment out:

```yaml
# dependencies:
  # flutter_map: ^7.0.0  # REMOVE
  # latlong2: ^0.9.1      # REMOVE
  # geolocator: ^10.1.0   # REMOVE (unless needed for other features)
```

Run:
```bash
flutter pub get
flutter clean
flutter pub get
```

## 🎨 Design Specifications

### Colors
- **Metro Teal**: `Color(0xFF00A9A5)`
- **Bus Orange**: `Color(0xFFFF6B35)`
- **Dark Text**: `Color(0xFF2C3E50)`
- **Light Gray**: `Colors.grey[600]`

### Spacing
- Station height: Dynamic (screen height / station count)
- Timeline line: 4px wide
- Station dots: 16px diameter with 3px border
- Vehicle markers: 40px with rounded corners

### Animations
- Vehicle movement: 1 second duration with `Curves.easeInOut`
- Use `AnimatedPositioned` for smooth transitions

## ✅ Testing Checklist

1. ✅ Models parse WebSocket data correctly
2. ✅ Timeline renders all stations
3. ✅ Vehicles appear at correct positions
4. ✅ Vehicles animate smoothly between updates
5. ✅ Multiple vehicles don't overlap
6. ✅ Works with different screen sizes
7. ✅ Handles no vehicles gracefully
8. ✅ Error states display properly

## 🚀 Next Steps

1. Implement all entities and models
2. Update data source to handle routes
3. Create timeline widgets
4. Test with backend simulation
5. Polish animations and transitions
6. Add ETA calculations (optional)
7. Add route selection UI
