# Metro Tracker API Reference

## Base URL
```
http://localhost:5000/api
```

## Endpoints

### Routes

#### Get All Routes
```
GET /routes
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "...",
      "name": "Kochi Metro Line 1",
      "code": "L1",
      "type": "METRO",
      "description": "Aluva to Thripunithura",
      "stations": [...]
    }
  ]
}
```

#### Get Route by ID
```
GET /routes/:id
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "...",
    "name": "Kochi Metro Line 1",
    "code": "L1",
    "type": "METRO",
    "description": "Aluva to Thripunithura",
    "stations": [
      {
        "id": "...",
        "name": "Aluva",
        "code": "ALUVA",
        "orderIndex": 0,
        "coordinates": {
          "lat": 10.1076,
          "lng": 76.3534
        }
      }
    ]
  }
}
```

### Stations

#### Get All Stations
```
GET /stations
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "...",
      "name": "Aluva",
      "code": "ALUVA",
      "orderIndex": 0,
      "coordinates": {
        "lat": 10.1076,
        "lng": 76.3534
      }
    }
  ]
}
```

#### Get Nearby Stations
```
GET /stations/nearby?lat=10.0264&lng=76.3086&limit=5
```

**Query Parameters:**
- `lat` (required): Latitude
- `lng` (required): Longitude
- `limit` (optional): Number of stations to return (default: 5)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "...",
      "name": "Kaloor",
      "code": "KALOOR",
      "orderIndex": 12,
      "coordinates": {
        "lat": 10.0264,
        "lng": 76.3086
      },
      "distance": 0.5
    }
  ]
}
```

### Timetables (NEW)

#### Get All Timetables
```
GET /timetables
```

**Query Parameters:**
- `dayType` (optional): Filter by day type - `Weekday`, `Weekend`, or `Holiday`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "...",
      "routeId": "...",
      "routeName": "Kochi Metro Line 1",
      "routeCode": "L1",
      "routeType": "METRO",
      "dayType": "Weekday",
      "schedule": [
        {
          "timeRange": {
            "start": "6:00 AM",
            "end": "9:00 AM"
          },
          "frequency": {
            "minutes": 10,
            "type": "Peak"
          }
        }
      ]
    }
  ]
}
```

#### Get Timetable for Specific Route
```
GET /timetables/route/:routeId
```

**Query Parameters:**
- `dayType` (optional): Day type - `Weekday`, `Weekend`, or `Holiday` (default: `Weekday`)

**Response:**
```json
{
  "success": true,
  "data": {
    "routeId": "...",
    "routeName": "Kochi Metro Line 1",
    "routeCode": "L1",
    "routeType": "METRO",
    "dayType": "Weekday",
    "schedule": [
      {
        "timeRange": {
          "start": "6:00 AM",
          "end": "9:00 AM"
        },
        "frequency": {
          "minutes": 10,
          "type": "Peak"
        }
      },
      {
        "timeRange": {
          "start": "9:00 AM",
          "end": "5:00 PM"
        },
        "frequency": {
          "minutes": 15,
          "type": "Off-Peak"
        }
      },
      {
        "timeRange": {
          "start": "5:00 PM",
          "end": "8:00 PM"
        },
        "frequency": {
          "minutes": 10,
          "type": "Peak"
        }
      },
      {
        "timeRange": {
          "start": "8:00 PM",
          "end": "10:00 PM"
        },
        "frequency": {
          "minutes": 20,
          "type": "Off-Peak"
        }
      },
      {
        "timeRange": {
          "start": "10:00 PM",
          "end": "11:00 PM"
        },
        "frequency": {
          "minutes": 30,
          "type": "Night"
        }
      }
    ]
  }
}
```

## WebSocket

### Connection
```
ws://localhost:5000
```

### Messages

#### Receive: Initial Routes
```json
{
  "type": "ROUTES",
  "data": [...]
}
```

#### Receive: Vehicle Updates
```json
{
  "type": "VEHICLE_UPDATE",
  "timestamp": 1234567890,
  "data": [
    {
      "id": "METRO-101",
      "type": "METRO",
      "routeId": "...",
      "routeName": "Kochi Metro Line 1",
      "routeCode": "L1",
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
      "progress": 0.35,
      "timestamp": 1234567890
    }
  ]
}
```

#### Send: Get Vehicles
```json
{
  "type": "GET_VEHICLES"
}
```

#### Send: Get Routes
```json
{
  "type": "GET_ROUTES"
}
```

#### Send: Get Specific Route
```json
{
  "type": "GET_ROUTE",
  "routeId": "..."
}
```

## Error Responses

All endpoints return errors in this format:
```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message"
}
```

Common HTTP Status Codes:
- `200` - Success
- `400` - Bad Request (missing parameters)
- `404` - Not Found
- `500` - Server Error

## Data Models

### Route Types
- `METRO` - Metro train route
- `BUS` - Feeder bus route

### Day Types
- `Weekday` - Monday to Friday
- `Weekend` - Saturday and Sunday
- `Holiday` - Public holidays

### Frequency Types
- `Peak` - Rush hour service (higher frequency)
- `Off-Peak` - Normal service hours
- `Night` - Late night service (lower frequency)

## Sample Data

The database is seeded with:
- **25 Metro Stations** on Line 1 (Aluva to Thripunithura)
- **6 Feeder Bus Stops** (Aluva area)
- **2 Routes** (1 Metro, 1 Bus)
- **4 Active Vehicles** (2 Trains, 2 Buses)
- **4 Timetables** (Weekday and Weekend for each route)

## Testing with cURL

```bash
# Get all routes
curl http://localhost:5000/api/routes

# Get nearby stations
curl "http://localhost:5000/api/stations/nearby?lat=10.0264&lng=76.3086&limit=5"

# Get weekday timetables
curl "http://localhost:5000/api/timetables?dayType=Weekday"

# Get timetable for specific route
curl "http://localhost:5000/api/timetables/route/YOUR_ROUTE_ID?dayType=Weekend"
```
