# KMRL Metro Bus Tracking System

This repository contains the source code for the KMRL Metro Bus Tracking mobile application and a mock backend server.

## Project Structure

- **backend/**: Node.js server simulating GTFS-Realtime bus data.
- **metro_tracker_app/**: Flutter application using Clean Architecture and BLoC.

## Prerequisites

- Node.js (for backend)
- Flutter SDK (for mobile app)
- Android Studio / Xcode (for emulators)

## How to Run

### 1. Start the Mock Backend

The backend simulates live bus movements in Kochi.

```bash
cd backend
npm install
npm start
```

The WebSocket server will start on `ws://localhost:8080`.

### 2. Run the Flutter App

Ensure you have a connected device or emulator.

**Important**: 
- If running on Android Emulator, the app is configured to connect to `ws://10.0.2.2:8080` (localhost alias).
- If running on iOS Simulator or real device, update the IP address in `lib/injection_container.dart`.
- You need a Google Maps API Key for the map to render. Add it to `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`.

```bash
cd metro_tracker_app
flutter pub get
flutter run
```

## Features Implemented

- **Mock Data Generator**: Simulates 5 buses moving near Kochi Metro stations.
- **Clean Architecture**: Separation of Domain, Data, and Presentation layers.
- **BLoC State Management**: Handles map state and bus updates.
- **Geofence Alerts**: Mock logic in BLoC triggers console alerts when a bus is within 1km.
