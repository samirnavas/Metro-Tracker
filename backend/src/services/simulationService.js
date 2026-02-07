
const Vehicle = require('../models/Vehicle');
const { movePoint } = require('../utils/geoUtils');

// Define specific routes (simplified)
// Kochi Metro Line 1 (Aluva -> Thripunithura)
const METRO_LINE_1 = [
    { lat: 10.1076, lng: 76.3534 }, // Aluva
    { lat: 10.0573, lng: 76.3312 }, // Edappally
    { lat: 10.0264, lng: 76.3086 }, // Kaloor
    { lat: 9.9754, lng: 76.2796 },  // MG Road
    { lat: 9.9405, lng: 76.3013 },  // Vyttila
    { lat: 9.9576, lng: 76.3639 },  // Thripunithura
];

// Feeder Bus Routes (Short loops)
const BUS_ROUTE_1 = [
    { lat: 10.1076, lng: 76.3534 }, // Aluva Station
    { lat: 10.1150, lng: 76.3600 },
    { lat: 10.1100, lng: 76.3700 },
    { lat: 10.1000, lng: 76.3600 },
];

class SimulationService {
    constructor() {
        this.vehicles = [];
        this.initVehicles();
    }

    initVehicles() {
        // Metro Trains
        this.vehicles.push(new Vehicle('metro-101', 'METRO', 'L1', 10.1076, 76.3534, 180, 60));
        this.vehicles.push(new Vehicle('metro-102', 'METRO', 'L1', 10.0264, 76.3086, 180, 60));

        // Feeder Buses
        this.vehicles.push(new Vehicle('bus-201', 'BUS', 'F1', 10.1076, 76.3534, 90, 30));
        this.vehicles.push(new Vehicle('bus-202', 'BUS', 'F1', 10.1100, 76.3700, 270, 30));
    }

    updatePositions() {
        const timeDelta = 1; // 1 second update cycle

        this.vehicles.forEach(vehicle => {
            // Simulate movement
            // Simple random jitter for demo, or follow a path logic could be here
            // For now, simple jitter + drift to simulate movement

            const speedKmH = vehicle.speed;
            const distance = (speedKmH / 3600) * timeDelta; // Distance in km per second

            // Update bearing strictly (simplified: just keep moving in general direction or bounce)
            // Real implementation would follow path points

            // Add some random turn
            vehicle.bearing += (Math.random() - 0.5) * 10;

            const newPos = movePoint(vehicle.lat, vehicle.lng, vehicle.bearing, distance);

            // Boundary check (keep near Kochi)
            if (newPos.lat > 10.2 || newPos.lat < 9.8 || newPos.lng > 76.5 || newPos.lng < 76.1) {
                vehicle.bearing += 180; // Turn around
            } else {
                vehicle.lat = newPos.lat;
                vehicle.lng = newPos.lng;
            }

            vehicle.lastUpdate = Date.now();
        });

        return this.vehicles;
    }

    getVehicleData() {
        return this.vehicles.map(v => v.toJSON());
    }
}

module.exports = new SimulationService();
