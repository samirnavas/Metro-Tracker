# Quick Start Guide - Database Integration

## ✅ What Was Done

1. **Created mock data in MongoDB database:**
   - 31 stations (real Kochi Metro stations)
   - 4 vehicles (2 metro trains, 2 buses)
   - 2 routes (Metro Line 1 + Feeder bus route)

2. **Created backend REST APIs:**
   - GET `/api/routes` - All routes
   - GET `/api/stations` - All stations
   - GET `/api/stations/nearby?lat=X&amp;lng=Y` - Nearest stations

3. **Updated Flutter HomeScreen:**
   - Removed hardcoded "Aluva - Edappally" routes
   - Removed hardcoded "Kaloor" stations
   - Now fetches real data from database via API
   - Shows loading states and error handling

## 🚀 How to Run

### Backend (already running):
```bash
# Your backend is already running on port 8080
# If you need to restart:
cd backend
npm run dev
```

### Flutter App:
```bash
cd metro_tracker_app
flutter pub get  # Install any new dependencies
flutter run      # Run the app
```

## 📱 What You'll See in the App

**Home Screen:**
- **Available Routes** section now shows:
  - ✅ Kochi Metro Line 1 (L1) - with Metro train icon
  - ✅ Aluva Feeder Route 1 (F1) - with Bus icon
  
- **Nearest Metro Stations** section now shows:
  - ✅ Real station names (e.g., "Town Hall", "Kaloor", "JLN Stadium")
  - ✅ Actual distances in kilometers
  - ✅ Horizontal scrollable list

**Live Map Screen:**
  - ✅ Still shows real-time vehicle tracking (unchanged)
  - ✅ 4 vehicles moving on their routes

## 🧪 Test the Database

Check what's in the database:
```bash
cd backend
node src/scripts/check-mongo.js
```

Re-seed database with fresh mock data:
```bash
cd backend
node src/scripts/seed.js
```

Test the API endpoints:
```bash
cd backend
node test-api.js
```

## 📊 Database Contents

**Routes:**
1. Kochi Metro Line 1 (Code: L1)
   - Type: METRO
   - Stations: 25 (Aluva to Thripunithura)

2. Aluva Feeder Route 1 (Code: F1)
   - Type: BUS
   - Stations: 6 (Aluva Metro to Eloor)

**Vehicles:**
- METRO-101: On Line 1 at Aluva
- METRO-102: On Line 1 at MG Road (30% to next station)
- BUS-F1-01: On Feeder Route at Aluva Metro
- BUS-F1-02: On Feeder Route mid-route (50% progress)

## 🎯 Key Changes

| Before | After |
|--------|-------|
| Hardcoded "Aluva - Edappally" (x3) | Real routes from database |
| Hardcoded "Kaloor" station (x5) | Real nearby stations with distances |
| Static placeholder data | Dynamic data from MongoDB |
| No loading states | Loading spinners + error handling |
| All routes looked identical | Metro vs Bus icons, unique names |

## 🔧 Architecture

```
Flutter App (HomeScreen)
    ↓
RouteBloc (State Management)
    ↓
RouteRepository (Data abstraction)
    ↓
RouteRemoteDataSource (HTTP client)
    ↓
Backend API (Express.js)
    ↓
MongoDB Database (Real data)
```

## 📝 Files Changed

### Backend:
- ✅ `src/controllers/routeController.js` - NEW API controller
- ✅ `src/routes/routes.js` - NEW route definitions
- ✅ `index.js` - Updated to use new routes
- ✅ Database seeded with mock data

### Flutter:
- ✅ `domain/entities/station.dart` - NEW
- ✅ `domain/entities/route.dart` - NEW
- ✅ `domain/repositories/route_repository.dart` - NEW
- ✅ `data/models/station_model.dart` - NEW
- ✅ `data/models/route_model.dart` - NEW
- ✅ `data/datasources/route_remote_data_source.dart` - NEW
- ✅ `data/repositories/route_repository_impl.dart` - NEW
- ✅ `presentation/bloc/route_bloc.dart` - NEW
- ✅ `presentation/bloc/route_event.dart` - NEW
- ✅ `presentation/bloc/route_state.dart` - NEW
- ✅ `presentation/pages/home_screen.dart` - UPDATED (no more hardcoded data!)
- ✅ `injection_container.dart` - UPDATED
- ✅ `main.dart` - UPDATED

## ⚡ Next Steps (Optional)

1. **Add search functionality** to find routes between stations
2. **Use user's real location** for nearby stations (currently uses fixed coordinates)
3. **Add route detail screen** when tapping on a route
4. **Implement caching** for offline access
5. **Add more routes and stations** to the database as needed

## 🐛 Troubleshooting

**App shows empty routes/stations:**
- Make sure backend is running on port 8080
- Run: `node src/scripts/check-mongo.js` to verify database has data
- If empty, run: `node src/scripts/seed.js` to populate database

**Can't connect to backend from Android emulator:**
- The app automatically uses `10.0.2.2:8080` for Android emulator
- Make sure backend is running on your host machine

**Lint errors in Flutter:**
- Run: `flutter pub get` to ensure all packages are installed
- Run: `flutter clean` if you see persistent errors

## 📖 Need More Details?

See `DATABASE_INTEGRATION_SUMMARY.md` for comprehensive documentation including:
- Complete database schema
- Detailed data flow diagrams
- API endpoint specifications
- Testing procedures
- Architecture explanations

---

**Status:** ✅ Complete - Database integration successful!
