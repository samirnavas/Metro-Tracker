# Metro Tracker - Database Integration Summary

## Overview
Successfully migrated from hardcoded data to real database integration with MongoDB. The application now fetches real-time data from the backend API.

## ✅ Completed Tasks

### 1. **Database Seeding** (Backend)
- Created and populated MongoDB database with **mock data**:
  - **31 Stations** (25 Metro + 6 Feeder Bus stations)
  - **4 Vehicles** (2 Metro trains + 2 Buses)
  - **2 Routes** (Kochi Metro Line 1 + Aluva Feeder Route)
- All stations include real coordinates for Kochi Metro
- Seed script: `backend/src/scripts/seed.js`

### 2. **Backend API Endpoints** (New)
Created REST API controller (`backend/src/controllers/routeController.js`) with endpoints:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/routes` | GET | Get all active routes with stations |
| `/api/routes/:id` | GET | Get specific route by ID |
| `/api/stations` | GET | Get all stations |
| `/api/stations/nearby?lat=X&amp;lng=Y&amp;limit=N` | GET | Get nearby stations based on coordinates |

Features:
- Distance calculation using Haversine formula
- Populated station data with coordinates
- Sorted results by distance/order

### 3. **Backend Routes** (New)
- Created `backend/src/routes/routes.js` to define API route mappings
- Updated `backend/index.js` to mount the new routes under `/api`
- Added console logging for new endpoints on server startup

### 4. **Flutter Domain Layer** (New)
Created domain entities:
- `Station` entity (`domain/entities/station.dart`)
- `Coordinates` entity (embedded in Station)
- `MetroRoute` entity (`domain/entities/route.dart`)
- `RouteRepository` interface (`domain/repositories/route_repository.dart`)

### 5. **Flutter Data Layer** (New)
Created data models and sources:
- `StationModel` with JSON serialization (`data/models/station_model.dart`)
- `CoordinatesModel` with JSON serialization
- `RouteModel` with JSON serialization (`data/models/route_model.dart`)
- `RouteRemoteDataSource` with HTTP client (`data/datasources/route_remote_data_source.dart`)
- `RouteRepositoryImpl` implementation (`data/repositories/route_repository_impl.dart`)

### 6. **Flutter Presentation Layer** (Updated)
Created BLoC for state management:
- **RouteBloc** (`presentation/bloc/route_bloc.dart`)
- **RouteEvent** (`presentation/bloc/route_event.dart`) - Events: `LoadAllRoutes`, `LoadAllStations`, `LoadNearbyStations`
- **RouteState** (`presentation/bloc/route_state.dart`) - States: `RouteInitial`, `RouteLoading`, `RoutesLoaded`, `StationsLoaded`, `NearbyStationsLoaded`, `RouteError`

### 7. **UI Refactoring** (Major Update)
**HomeScreen** (`presentation/pages/home_screen.dart`) completely refactored:

**Before:**
- Hardcoded 3 identical "Aluva - Edappally" routes
-Hardcoded 5 identical "Kaloor" stations (0.5 km away)
- No real data, static placeholders

**After:**
- ✅ Fetches real routes from database via API
- ✅ Displays route name, code, type (Metro/Bus), and description
- ✅ Fetches nearby stations based on coordinates
- ✅ Shows actual station names and calculated distances
- ✅ Loading states with spinners
- ✅ Error handling with SnackBar messages
- ✅ Different icons for Metro (train) vs Bus routes
- ✅ Empty state messages when no data available

### 8. **Dependency Injection** (Updated)
Updated `injection_container.dart`:
- Added `RouteBloc` factory
- Added `RouteRepository` lazy singleton
- Added `RouteRemoteDataSource` lazy singleton
- Added `http.Client` for API requests
- Added base URL configuration (handles Android emulator vs localhost)

### 9. **Main App** (Updated)
Updated `main.dart`:
- Added `RouteBloc` to `MultiBlocProvider`
- Now provides both `VehicleBloc` and `RouteBloc` app-wide

## 📊 Database Schema

### Stations Collection
```javascript
{
  name: String,        // e.g., "Aluva"
  code: String,        // e.g., "ALUVA" (unique, uppercase)
  orderIndex: Number,  // Position in route sequence
  coordinates: {
    lat: Number,       // e.g., 10.1076
    lng: Number        // e.g., 76.3534
  }
}
```

### Routes Collection
```javascript
{
  name: String,        // e.g., "Kochi Metro Line 1"
  code: String,        // e.g., "L1" (unique, uppercase)
  type: String,        // "METRO" or "BUS"
  stations: [ObjectId], // References to Station documents
  active: Boolean,     // Default: true
  description: String  // e.g., "Aluva to Thripunithura"
}
```

### Vehicles Collection
```javascript
{
  vehicleId: String,              // e.g., "METRO-101"
  type: String,                   // "METRO" or "BUS"
  route: ObjectId,                // Reference to Route
  currentStation: ObjectId,       // Reference to Station
  nextStation: ObjectId,          // Reference to Station
  progressToNextStation: Number,  // 0.0 to 1.0
  active: Boolean,                // Default: true
  lastUpdate: Date
}
```

## 🔄 Data Flow

### For Routes &amp; Stations:
```
User opens HomeScreen
    ↓
RouteBloc receives LoadAllRoutes &amp; LoadNearbyStations events
    ↓
RouteBloc calls RouteRepository methods
    ↓
RouteRepository calls RouteRemoteDataSource
    ↓
HTTP GET request to backend API
    ↓
Backend fetches data from MongoDB
    ↓
Response parsed into RouteModel/StationModel
    ↓
BLoC emits RoutesLoaded/NearbyStationsLoaded state
    ↓
UI rebuilds with real data
```

### For Vehicles (Real-time):
```
WebSocket connection established
    ↓
Backend simulation service updates vehicle positions every 3s
    ↓
WebSocket broadcasts VEHICLE_UPDATE messages
    ↓
VehicleBloc updates state
    ↓
LiveMapScreen shows real-time vehicle movement
```

## 🧪 Testing

### Backend API Tests
Run the test script to verify all APIs:
```bash
cd backend
node test-api.js
```

**Expected Results:**
- `/api/routes` → 200 OK, 2 routes
- `/api/stations` → 200 OK, 31 stations
- `/api/stations/nearby` → 200 OK, nearest stations with distances
- `/api/vehicles` → 200 OK, 4 active vehicles

### Database Verification
Check database contents:
```bash
cd backend
node src/scripts/check-mongo.js
```

### Re-seed Database (if needed)
```bash
cd backend
node src/scripts/seed.js
```

## 📱 Flutter App Changes

### Dependencies
All required packages already in `pubspec.yaml`:
- ✅ `http: ^1.1.0` - For REST API calls
- ✅ `flutter_bloc: ^8.1.3` - State management
- ✅ `equatable: ^2.0.5` - Value comparison
- ✅ `get_it: ^7.6.0` - Dependency injection

### Configuration
HTTP base URL automatically configured based on platform:
- **Android Emulator**: `http://10.0.2.2:8080`
- **iOS Simulator/Desktop**: `http://localhost:8080`

## 🚀 Running the Application

### 1. Start Backend
```bash
cd backend
npm run dev
```

The server will start on `http://localhost:8080` with:
- WebSocket endpoint for real-time vehicle updates
- REST API endpoints for routes and stations
- Simulation engine for vehicle movement

### 2. Run Flutter App
```bash
cd metro_tracker_app
flutter run
```

### 3. What You'll See

**Home Screen:**
- Header: "Metro Tracker - Track your journey in real-time"
- Search card (TODO: functionality coming soon)
- **Available Routes section:**
  - Kochi Metro Line 1 (L1) - Metro icon
  - Aluva Feeder Route 1 (F1) - Bus icon
- **Nearest Metro Stations section:**
  - Horizontal scrollable list
  - Shows actual station names
  - Displays calculated distance in km

**Live Map Screen:**
- Real-time vehicle positions
- Moving markers for metro trains and buses
- Vehicle details panel with current/next station info

## 🎯 Key Improvements

1. **No More Hardcoded Data** - Everything fetched from database
2. **Real Station Names** - Actual Kochi Metro stations displayed
3. **Accurate Distances** - Calculated using Haversine formula
4. **Type Differentiation** - Metro vs Bus routes with different icons
5. **Loading States** - User feedback during data fetching
6. **Error Handling** - Graceful error messages
7. **Scalability** - Easy to add more routes/stations in database
8. **Clean Architecture** - Proper separation of concerns (Domain/Data/Presentation)

## 🐛 Known Issues / TODO

1. **Search Functionality** - Not yet implemented (shows "coming soon" message)
2. **User Location** - Currently using hardcoded Kochi Metro coordinates for nearby stations
3. **Route Details** - Click on route doesn't navigate anywhere yet
4. **Caching** - No offline support, requires internet connection

## 📝 Next Steps

To enhance further:
1. Implement search functionality for finding routes between stations
2. Add user location services to show truly nearby stations
3. Add route details screen with full station list
4. Implement caching for offline access
5. Add favorites/recent searches
6. Push notifications for vehicle arrival times

## 🎉 Summary

The Metro Tracker app has been successfully migrated from using hardcoded placeholder data to a fully functional database-backed system. The HomeScreen now fetches and displays:
- **2 real routes** from the database (Kochi Metro Line 1 + Aluva Feeder Route)
- **Nearby stations** with actual calculated distances
- Proper loading states and error handling
- Clean, professional UI that scales with data

All backend APIs are tested and working, and the Flutter app is properly integrated with BLoC state management and dependency injection.
