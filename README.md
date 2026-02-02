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

### 1. Run the Flutter App (Web Recommended)

Since Visual Studio (for Windows) or Android SDK might not be installed, the easiest way to run the app is on **Chrome**.

1. **Google Maps Key**: Open `web/index.html` and replace `YOUR_API_KEY` with your actual Google Maps API Key.
2. **Run on Chrome**:
   ```bash
   cd metro_tracker_app
   flutter run -d chrome
   ```

**Note**: We have switched to a **Local Mock Data Generator** (`MockLocalBusRepository`), so you **do not** need to run the Node.js backend anymore. The app generates its own bus data internally for demonstration.

*(Optional) If you have Visual Studio installed, you can run on Windows by selecting the Windows device.*

## Features Implemented

- **Mock Data Generator**: Simulates 5 buses moving near Kochi Metro stations.
- **Clean Architecture**: Separation of Domain, Data, and Presentation layers.
- **BLoC State Management**: Handles map state and bus updates.
- **Geofence Alerts**: Mock logic in BLoC triggers console alerts when a bus is within 1km.
