const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

console.log('Mock KMRL Backend started on ws://localhost:8080');

// Initial positions for 5 buses in Kochi
const buses = [
  { id: 'bus-1', lat: 9.9312, lng: 76.2673, routeId: 'route-1' },
  { id: 'bus-2', lat: 9.9350, lng: 76.2600, routeId: 'route-2' },
  { id: 'bus-3', lat: 9.9400, lng: 76.2700, routeId: 'route-1' },
  { id: 'bus-4', lat: 9.9250, lng: 76.2650, routeId: 'route-3' },
  { id: 'bus-5', lat: 9.9300, lng: 76.2750, routeId: 'route-2' },
];

// Helper to simulate movement
function moveBus(bus) {
  // Move by small random amount (~0.0001 degrees is roughly 11 meters)
  const latDelta = (Math.random() - 0.5) * 0.001;
  const lngDelta = (Math.random() - 0.5) * 0.001;
  
  bus.lat += latDelta;
  bus.lng += lngDelta;
  
  return bus;
}

// Generate GTFS-like JSON payload
function generatePayload() {
  const timestamp = Math.floor(Date.now() / 1000);
  
  const entities = buses.map(bus => {
    moveBus(bus);
    return {
      id: bus.id,
      vehicle: {
        timestamp: timestamp,
        position: {
          latitude: bus.lat,
          longitude: bus.lng,
          bearing: Math.random() * 360, // Random bearing for demo
          speed: 10 + Math.random() * 20 // Speed in km/h
        },
        vehicle: {
          id: bus.id,
          label: `KMRL Feeder ${bus.id.split('-')[1]}`
        },
        trip: {
          tripId: `trip-${bus.id}`,
          routeId: bus.routeId
        }
      }
    };
  });

  return JSON.stringify({
    header: {
      gtfsRealtimeVersion: "2.0",
      incrementality: "FULL_DATASET",
      timestamp: timestamp
    },
    entity: entities
  });
}

wss.on('connection', ws => {
  console.log('Client connected');

  // Send initial data immediately
  ws.send(generatePayload());

  // Send updates every 3 seconds
  const intervalId = setInterval(() => {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(generatePayload());
    }
  }, 3000);

  ws.on('close', () => {
    console.log('Client disconnected');
    clearInterval(intervalId);
  });
  
  ws.on('error', (error) => {
    console.error('WebSocket error:', error);
  });
});
