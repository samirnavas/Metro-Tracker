# Backend Migration Summary: Linear Tracking System

## ✅ Completed Changes

### 1. Dependencies Added
- **mongoose** (^8.1.1): MongoDB ODM
- **dotenv** (^16.4.5): Environment variable management

### 2. Configuration Files
- **`.env`**: Environment configuration
  - MONGODB_URI
  - PORT
  - SIMULATION_INTERVAL

### 3. Database Models (src/models/)

#### Station.js (NEW)
- name, code, orderIndex
- Optional coordinates for future use
- Represents metro/bus stops in sequential order

#### Route.js (NEW)
- name, code, type (METRO/BUS)
- Array of Station references (ordered)
- Represents a complete line/route

#### Vehicle.js (REFACTORED)
**Old Approach:**
- lat, lng, bearing, speed (GPS tracking)

**New Approach:**
- currentStation, nextStation (references)
- progressToNextStation (0.0 to 1.0)
- Linear tracking between stations

### 4. Database Configuration
- **src/config/database.js**: Connection manager with error handling

### 5. Simulation Service (src/services/simulationService.js)

**Old Approach:**
- Random GPS coordinate movement
- Boundary checking
- No real route following

**New Approach:**
- Increments progress between stations
- Automatically moves to next station at 100%
- Loops routes continuously
- Real station data

**Key Methods:**
- `start()`: Initialize simulation engine
- `updateAllVehicles()`: Update all active vehicles
- `moveToNextStation()`: Transition to next station
- `getVehicleData()`: Format data for WebSocket
- `getAllRoutes()`: Get route information

### 6. WebSocket Controller (src/controllers/websocketController.js)

**Enhancements:**
- Initial data send (routes + vehicles)
- Message handling (GET_ROUTES, GET_VEHICLES, GET_ROUTE)
- Periodic broadcasting
- Better error handling

**Message Protocol:**
```
Client → Server:
- GET_ROUTES
- GET_VEHICLES  
- GET_ROUTE

Server → Client:
- ROUTES
- VEHICLE_UPDATE
- ROUTE_DATA
```

### 7. Main Server (index.js)

**New Features:**
- MongoDB connection on startup
- Simulation engine initialization
- REST API endpoints
- Graceful shutdown handling

**API Endpoints:**
- GET /health
- GET /api/routes
- GET /api/vehicles

### 8. Scripts

#### src/scripts/seed.js
Complete database population with:
- **25 real Kochi Metro stations** (Aluva to Thripunithura)
- **6 feeder bus stations** (Aluva area)
- **2 routes** (Metro Line 1, Feeder Route)
- **4 sample vehicles** (2 metro, 2 bus)

#### src/scripts/check-mongo.js
MongoDB connection diagnostic tool

### 9. NPM Scripts
```json
{
  "start": "node index.js",
  "dev": "nodemon index.js",
  "seed": "node src/scripts/seed.js",
  "check-mongo": "node src/scripts/check-mongo.js"
}
```

### 10. Documentation
- **README.md**: Complete API and architecture documentation
- **MONGODB_SETUP.md**: MongoDB installation guide

## 📊 Data Structure Comparison

### Old System (GPS-based):
```json
{
  "id": "bus-201",
  "type": "BUS",
  "lat": 10.1076,
  "lng": 76.3534,
  "bearing": 90,
  "speed": 30,
  "routeId": "F1"
}
```

### New System (Linear Tracking):
```json
{
  "id": "BUS-F1-01",
  "type": "BUS",
  "routeId": "...",
  "routeName": "Aluva Feeder Route 1",
  "currentStation": {
    "id": "...",
    "name": "Aluva Metro Station",
    "code": "F_ALUVA",
    "orderIndex": 0
  },
  "nextStation": {
    "id": "...",
    "name": "Aluva Bus Stand",
    "code": "F_ALUVA_BUS",
    "orderIndex": 1
  },
  "progress": 0.35
}
```

## 🎯 Benefits of Linear Tracking

1. **Simpler UI**: Vertical timeline instead of complex map
2. **Predictable**: Progress is always 0.0 to 1.0
3. **Accurate**: Station-based tracking (no GPS drift)
4. **Lightweight**: Less data transmission
5. **Better UX**: "Where is my train" style interface

## 🚀 Next Steps

### Backend Setup:
1. Install MongoDB (see MONGODB_SETUP.md)
2. Run `npm run check-mongo` to verify connection
3. Run `npm run seed` to populate database
4. Run `npm run dev` to start server

### Flutter Integration:
1. Remove Google Maps dependencies
2. Create TimelineScreen widget
3. Implement vertical station list
4. Position bus icon using: `currentStation.orderIndex + progress`
5. Add smooth animations with AnimatedPositioned

## 📁 File Structure
```
backend/
├── .env                          # Environment config
├── index.js                      # Main server (REFACTORED)
├── package.json                  # Updated dependencies
├── README.md                     # API documentation
├── MONGODB_SETUP.md             # Setup guide
└── src/
    ├── config/
    │   └── database.js          # NEW - DB connection
    ├── controllers/
    │   └── websocketController.js  # REFACTORED
    ├── models/
    │   ├── Station.js           # NEW
    │   ├── Route.js             # NEW
    │   └── Vehicle.js           # REFACTORED
    ├── services/
    │   └── simulationService.js # REFACTORED
    └── scripts/
        ├── seed.js              # NEW - Database seeder
        └── check-mongo.js       # NEW - Connection checker
```

## 🔄 Migration Path

1. ✅ Backend models created
2. ✅ Simulation engine refactored
3. ✅ WebSocket protocol updated
4. ✅ Database seeder ready
5. ⏳ MongoDB setup required
6. ⏳ Flutter app refactoring needed

## 💡 Key Concepts

**orderIndex**: Determines vertical position in timeline
- Station 0 → Top
- Station 24 → Bottom

**progress**: Interpolation between stations
- 0.0 → At current station
- 0.5 → Halfway to next
- 1.0 → Arriving at next (triggers transition)

**Calculation for UI:**
```dart
double busPosition = currentStation.orderIndex + progress;
// Example: Station 3 with 0.35 progress = 3.35
// This can be mapped to Y coordinate in timeline
```
