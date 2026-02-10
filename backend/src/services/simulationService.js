const Vehicle = require('../models/Vehicle');
const Route = require('../models/Route');
const Station = require('../models/Station');

class SimulationService {
    constructor() {
        this.simulationInterval = null;
        this.updateSpeed = 0.05; // Progress increment per update (5% per 3 seconds)
    }

    /**
     * Start the simulation engine
     */
    async start() {
        console.log('🚀 Starting simulation engine...');

        // Initial setup - ensure data exists
        const vehicleCount = await Vehicle.countDocuments({ active: true });
        if (vehicleCount === 0) {
            console.warn('⚠️  No active vehicles found. Please run the seed script first.');
            return;
        }

        console.log(`✓ Found ${vehicleCount} active vehicles`);

        // Start periodic updates
        const interval = parseInt(process.env.SIMULATION_INTERVAL) || 3000;
        this.simulationInterval = setInterval(() => {
            this.updateAllVehicles();
        }, interval);

        console.log(`✓ Simulation running (updates every ${interval}ms)`);
    }

    /**
     * Stop the simulation engine
     */
    stop() {
        if (this.simulationInterval) {
            clearInterval(this.simulationInterval);
            this.simulationInterval = null;
            console.log('✓ Simulation stopped');
        }
    }

    /**
     * Update all active vehicles
     */
    async updateAllVehicles() {
        try {
            const vehicles = await Vehicle.find({ active: true })
                .populate('route')
                .populate('currentStation')
                .populate('nextStation');

            for (const vehicle of vehicles) {
                await this.updateVehiclePosition(vehicle);
            }
        } catch (error) {
            console.error('Error updating vehicles:', error);
        }
    }

    /**
     * Update a single vehicle's position
     */
    async updateVehiclePosition(vehicle) {
        try {
            // Increment progress
            vehicle.progressToNextStation += this.updateSpeed;

            // If reached next station
            if (vehicle.progressToNextStation >= 1.0) {
                await this.moveToNextStation(vehicle);
            } else {
                // Just update progress
                vehicle.lastUpdate = new Date();
                await vehicle.save();
            }
        } catch (error) {
            console.error(`Error updating vehicle ${vehicle.vehicleId}:`, error);
        }
    }

    /**
     * Move vehicle to the next station in the route
     */
    async moveToNextStation(vehicle) {
        try {
            // Get the full route with all stations
            const route = await Route.findById(vehicle.route._id || vehicle.route);

            if (!route || !route.stations || route.stations.length === 0) {
                console.error(`Invalid route for vehicle ${vehicle.vehicleId}`);
                return;
            }

            // Find current station index
            const currentStationId = vehicle.currentStation._id || vehicle.currentStation;
            const currentIndex = route.stations.findIndex(
                s => s.toString() === currentStationId.toString()
            );

            if (currentIndex === -1) {
                console.error(`Current station not found in route for vehicle ${vehicle.vehicleId}`);
                return;
            }

            // Calculate next station index (loop back to start if at end)
            const nextIndex = (currentIndex + 1) % route.stations.length;
            const newNextIndex = (nextIndex + 1) % route.stations.length;

            // Update vehicle
            vehicle.currentStation = route.stations[nextIndex];
            vehicle.nextStation = route.stations[newNextIndex];
            vehicle.progressToNextStation = 0; // Reset progress
            vehicle.lastUpdate = new Date();

            await vehicle.save();

            // Log the transition
            const currentStation = await Station.findById(route.stations[nextIndex]);
            console.log(`🚊 ${vehicle.vehicleId} arrived at ${currentStation.name}`);
        } catch (error) {
            console.error(`Error moving vehicle ${vehicle.vehicleId} to next station:`, error);
        }
    }

    /**
     * Get current state of all active vehicles for WebSocket transmission
     */
    async getVehicleData() {
        try {
            const vehicles = await Vehicle.find({ active: true })
                .populate('route', 'name code type')
                .populate('currentStation', 'name code orderIndex')
                .populate('nextStation', 'name code orderIndex');

            return vehicles.map(v => ({
                id: v.vehicleId,
                type: v.type,
                routeId: v.route._id,
                routeName: v.route.name,
                routeCode: v.route.code,
                currentStation: {
                    id: v.currentStation._id,
                    name: v.currentStation.name,
                    code: v.currentStation.code,
                    orderIndex: v.currentStation.orderIndex
                },
                nextStation: v.nextStation ? {
                    id: v.nextStation._id,
                    name: v.nextStation.name,
                    code: v.nextStation.code,
                    orderIndex: v.nextStation.orderIndex
                } : null,
                progress: parseFloat(v.progressToNextStation.toFixed(3)),
                timestamp: Math.floor(v.lastUpdate.getTime() / 1000)
            }));
        } catch (error) {
            console.error('Error getting vehicle data:', error);
            return [];
        }
    }

    /**
     * Get route information with all stations
     */
    async getRouteData(routeId) {
        try {
            const route = await Route.findById(routeId)
                .populate('stations');

            if (!route) return null;

            return {
                id: route._id,
                name: route.name,
                code: route.code,
                type: route.type,
                stations: route.stations.map(s => ({
                    id: s._id,
                    name: s.name,
                    code: s.code,
                    orderIndex: s.orderIndex
                }))
            };
        } catch (error) {
            console.error('Error getting route data:', error);
            return null;
        }
    }

    /**
     * Get all routes
     */
    async getAllRoutes() {
        try {
            const routes = await Route.find({ active: true })
                .populate('stations');

            return routes.map(route => ({
                id: route._id,
                name: route.name,
                code: route.code,
                type: route.type,
                description: route.description,
                stations: route.stations.map(s => ({
                    id: s._id,
                    name: s.name,
                    code: s.code,
                    orderIndex: s.orderIndex,
                    coordinates: s.coordinates
                }))
            }));
        } catch (error) {
            console.error('Error getting all routes:', error);
            return [];
        }
    }
}

module.exports = new SimulationService();
