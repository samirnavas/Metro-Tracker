# Metro Tracker Backend

A real-time vehicle tracking backend for Kochi Metro and Feeder buses using **Linear Tracking** (similar to "Where Is My Train").

## 🏗️ Architecture

### Linear Tracking System
Instead of GPS coordinates, we track vehicles using:
- **Current Station**: Where the vehicle is/was last
- **Next Station**: Where it's heading
- **Progress**: 0.0 to 1.0 (percentage between stations)

This enables a clean vertical timeline UI in the Flutter app.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- MongoDB (local or cloud instance)

### Installation

1. **Install dependencies:**
```bash
npm install
```

2. **Configure environment:**
Edit `.env` file (already created):
```env
MONGODB_URI=mongodb://localhost:27017/metro-tracker
PORT=8080
SIMULATION_INTERVAL=3000
```

3. **Install MongoDB** (if not already installed):

**Windows:**
```bash
# Download from: https://www.mongodb.com/try/download/community
# Or use chocolatey:
choco install mongodb
```

**Start MongoDB:**
```bash
# Windows (run as admin)
net start MongoDB

# Or manually:
mongod --dbpath="C:\data\db"
```

4. **Seed the database:**
```bash
npm run seed
```

Expected output:
```
🌱 Starting database seed...
✓ Created 25 metro stations
✓ Created 6 feeder stations
✓ Created route: Kochi Metro Line 1
✓ Created route: Aluva Feeder Route 1
✓ Created 4 vehicles
✅ Database seeded successfully!
```

5. **Start the server:**
```bash
npm run dev
```

## 📡 API Endpoints

### HTTP REST API
- `GET /health` - Health check
- `GET /api/routes` - Get all routes with stations
- `GET /api/vehicles` - Get current vehicle positions

### WebSocket
Connect to `ws://localhost:8080`

**Client → Server Messages:**
```json
{ "type": "GET_ROUTES" }
{ "type": "GET_VEHICLES" }
{ "type": "GET_ROUTE", "routeId": "..." }
```

**Server → Client Messages:**
```json
{
  "type": "ROUTES",
  "data": [...]
}

{
  "type": "VEHICLE_UPDATE",
  "timestamp": 1234567890,
  "data": [{
    "id": "METRO-101",
    "type": "METRO",
    "routeId": "...",
    "routeName": "Kochi Metro Line 1",
    "currentStation": {
      "id": "...",
      "name": "Aluva",
      "code": "ALUVA",
      "orderIndex": 0
    },
    "nextStation": {
      "id": "...",
      "name": "Pulinchodu",
      "code": "PULINCHODU",
      "orderIndex": 1
    },
    "progress": 0.35
  }]
}
```

## 🗄️ Database Schema

### Station
```javascript
{
  name: String,           // "Aluva"
  code: String,           // "ALUVA"
  orderIndex: Number,     // 0, 1, 2... (for vertical ordering)
  coordinates: {
    lat: Number,
    lng: Number
  }
}
```

### Route
```javascript
{
  name: String,           // "Kochi Metro Line 1"
  code: String,           // "L1"
  type: String,           // "METRO" | "BUS"
  stations: [StationId],  // References to Station documents (ordered)
  active: Boolean,
  description: String
}
```

### Vehicle
```javascript
{
  vehicleId: String,               // "METRO-101"
  type: String,                    // "METRO" | "BUS"
  route: RouteId,
  currentStation: StationId,
  nextStation: StationId,
  progressToNextStation: Number,   // 0.0 to 1.0
  active: Boolean,
  lastUpdate: Date
}
```

## 🎮 Simulation Engine

The simulation engine runs every 3 seconds (configurable via `SIMULATION_INTERVAL`):

1. Increments `progressToNextStation` by 5% (0.05)
2. When progress ≥ 1.0:
   - Moves vehicle to next station
   - Resets progress to 0
   - Loops back to first station at route end

This creates smooth, predictable vehicle movement for the timeline UI.

## 📊 Real Data

### Kochi Metro Line 1 (25 stations)
Aluva → Pulinchodu → Companypady → Ambattukavu → Muttom → Kalamassery → CUSAT → Pathadipalam → Edachira → Changampuzha Park → Palarivattom → JLN Stadium → Kaloor → Town Hall → Maharajas → MG Road → Ernakulam South → Kadavanthara → Elamkulam → Vyttila → Thaikoodam → Petta → SN Junction → Vadakkekotta → Thripunithura

### Feeder Bus Route (6 stations)
Aluva Metro Station → Aluva Bus Stand → Aluva Market → Medical College Junction → CISF Campus → Eloor

## 🔧 Development

### Reset Database
```bash
npm run seed
```

### Check vehicle positions
```bash
curl http://localhost:8080/api/vehicles
```

### Monitor in real-time
Use a WebSocket client (like [wscli](https://github.com/esphen/wsta)):
```bash
wscli ws://localhost:8080
```

## 🎯 Next Steps (Flutter Integration)

The Flutter app should:

1. **Connect to WebSocket** (`ws://localhost:8080`)
2. **Listen for** `VEHICLE_UPDATE` messages
3. **Render Timeline UI**:
   - Vertical line with station dots
   - Bus icon positioned at: `currentStation.orderIndex + progress`
   - Animate position changes smoothly using `AnimatedPositioned`

Example calculation:
```dart
double getBusYPosition(VehicleUpdate vehicle) {
  final currentIndex = vehicle.currentStation.orderIndex;
  final nextIndex = vehicle.nextStation.orderIndex;
  final totalStations = route.stations.length;
  
  final distanceBetweenStations = screenHeight / totalStations;
  final currentY = currentIndex * distanceBetweenStations;
  final nextY = nextIndex * distanceBetweenStations;
  
  return currentY + (nextY - currentY) * vehicle.progress;
}
```

## 📝 License

MIT
