# MetroConnect - Quick Start Guide

## 🚀 What We Built

A **Linear Tracking System** for Kochi Metro and Feeder buses - similar to the "Where Is My Train" app with a vertical timeline UI instead of a map.

## 📦 Project Structure

```
Metro-Tracker/
├── backend/                          # Node.js + MongoDB Backend
│   ├── .env                         # Configuration
│   ├── index.js                     # Main server
│   ├── package.json                 # Dependencies
│   ├── src/
│   │   ├── config/
│   │   │   └── database.js         # MongoDB connection
│   │   ├── controllers/
│   │   │   └── websocketController.js  # WebSocket handling
│   │   ├── models/
│   │   │   ├── Station.js          # Station schema
│   │   │   ├── Route.js            # Route schema
│   │   │   └── Vehicle.js          # Vehicle schema
│   │   ├── services/
│   │   │   └── simulationService.js  # Movement simulation
│   │   └── scripts/
│   │       ├── seed.js             # Database seeder
│   │       └── check-mongo.js      # Connection checker
│   ├── README.md                    # API docs
│   ├── MONGODB_SETUP.md            # MongoDB installation
│   └── MIGRATION_SUMMARY.md        # Change log
│
├── metro_tracker_app/               # Flutter App
│   └── lib/
│       └── features/metro_tracking/
│
└── FLUTTER_IMPLEMENTATION.md        # Flutter refactoring guide
```

## 🎯 Quick Start

### 1️⃣ Backend Setup (5 minutes)

```bash
# Navigate to backend
cd backend

# Install dependencies (if not already done)
npm install

# Install MongoDB
# See: MONGODB_SETUP.md for detailed instructions
# Quick option: Use MongoDB Atlas (cloud, free tier)

# Check MongoDB connection
npm run check-mongo

# If connected, seed the database
npm run seed

# Start the server
npm run dev
```

**Expected Output:**
```
✅ Server Ready!
─────────────────────────────
HTTP Server: http://localhost:8080
WebSocket: ws://localhost:8080
Health Check: http://localhost:8080/health
Routes API: http://localhost:8080/api/routes
Vehicles API: http://localhost:8080/api/vehicles
─────────────────────────────

🚀 Starting simulation engine...
✓ Found 4 active vehicles
✓ Simulation running (updates every 3000ms)
```

### 2️⃣ Test Backend (1 minute)

```bash
# Test HTTP endpoint
curl http://localhost:8080/api/vehicles

# You should see vehicle data with progress between stations
```

### 3️⃣ Flutter App Refactoring

Follow the detailed guide in `FLUTTER_IMPLEMENTATION.md`

**Summary of changes:**
1. Update entity models (Station, Route, Vehicle)
2. Update data models and WebSocket parsing
3. Create Timeline UI widgets
4. Remove map dependencies
5. Test with live backend

## 📊 What's Different?

### Before (GPS-based):
```json
{
  "id": "bus-201",
  "lat": 10.1076,
  "lng": 76.3534,
  "bearing": 90,
  "speed": 30
}
```
➡️ Displayed on a **map** (requires Google Maps API, complex)

### After (Linear Tracking):
```json
{
  "id": "BUS-F1-01",
  "currentStation": {
    "name": "Aluva Metro Station",
    "orderIndex": 0
  },
  "nextStation": {
    "name": "Aluva Bus Stand",
    "orderIndex": 1
  },
  "progress": 0.35
}
```
➡️ Displayed on a **vertical timeline** (clean, simple, "Where Is My Train" style)

## 🎨 Visual Example

```
Timeline UI (Vertical):

 🚇  ● Aluva                    ← Station 0
     │
     │  🚌 BUS-F1-01 (35%)      ← progress: 0.35
     │
     ● Aluva Bus Stand          ← Station 1
     │
     ● Aluva Market             ← Station 2
     │
     ● Medical College          ← Station 3
```

## 🗄️ Database Content (Real Kochi Data)

### Metro Line 1 (25 stations):
Aluva → Pulinchodu → Companypady → Ambattukavu → Muttom → Kalamassery → CUSAT → Pathadipalam → Edachira → Changampuzha Park → Palarivattom → JLN Stadium → Kaloor → Town Hall → Maharajas → MG Road → Ernakulam South → Kadavanthara → Elamkulam → Vyttila → Thaikoodam → Petta → SN Junction → Vadakkekotta → Thripunithura

### Feeder Bus Route (6 stations):
Aluva Metro → Aluva Bus Stand → Aluva Market → Medical College → CISF Campus → Eloor

## 🔧 Troubleshooting

### Backend won't start
```bash
# Check MongoDB
npm run check-mongo

# If MongoDB not running:
# Windows: net start MongoDB
# Or see MONGODB_SETUP.md
```

### No vehicle updates
```bash
# Check if vehicles are seeded
npm run seed

# Restart server
npm run dev
```

### Flutter build errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## 📚 Documentation Index

| Document | Purpose |
|----------|---------|
| `backend/README.md` | API documentation, architecture |
| `backend/MONGODB_SETUP.md` | MongoDB installation guide |
| `backend/MIGRATION_SUMMARY.md` | Complete change log |
| `FLUTTER_IMPLEMENTATION.md` | Step-by-step Flutter refactoring |
| `QUICK_START.md` (this file) | Getting started guide |

## 🎬 Next Actions

### Immediate (Backend):
1. ✅ Dependencies installed
2. ⏳ **Install MongoDB** (see MONGODB_SETUP.md)
3. ⏳ **Run `npm run seed`**
4. ⏳ **Run `npm run dev`**
5. ⏳ Test endpoints with curl/Postman

### Next (Flutter):
1. ⏳ Update entities (Station, Route, Vehicle)
2. ⏳ Update models and WebSocket parsing
3. ⏳ Create Timeline UI widgets
4. ⏳ Test with live backend
5. ⏳ Polish animations

## 🆘 Need Help?

### MongoDB Installation
- **Local**: See `backend/MONGODB_SETUP.md` - Option 1
- **Cloud (easier)**: See `backend/MONGODB_SETUP.md` - Option 2 (MongoDB Atlas free tier)

### Backend Issues
- Check `backend/README.md` for API docs
- Run `npm run check-mongo` for diagnostics

### Flutter Refactoring
- Follow `FLUTTER_IMPLEMENTATION.md` step-by-step
- Start with Phase 1 (entities)
- Test each phase before moving to next

## 🎯 Success Criteria

✅ Backend:
- MongoDB connected
- 4 vehicles seeded
- WebSocket broadcasting every 1 second
- Vehicles moving between stations

✅ Flutter:
- No map dependencies
- Timeline UI showing stations
- Bus/metro icons moving smoothly
- Real-time updates from WebSocket

## 📝 Quick Commands Reference

```bash
# Backend
npm install              # Install dependencies
npm run check-mongo      # Test MongoDB connection
npm run seed            # Populate database
npm run dev             # Start server

# Flutter
flutter clean           # Clean build
flutter pub get         # Get dependencies
flutter run            # Run app
flutter doctor         # Check setup
```

## 🚀 You're All Set!

Your backend is ready with:
- ✅ MongoDB schemas (Station, Route, Vehicle)
- ✅ Real Kochi Metro data (25 stations)
- ✅ Simulation engine (vehicles moving every 3 seconds)
- ✅ WebSocket broadcasting (updates every 1 second)
- ✅ REST API endpoints

**Next:** Install MongoDB and run `npm run seed` to see it in action!
