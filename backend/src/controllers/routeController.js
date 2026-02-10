const Route = require('../models/Route');
const Station = require('../models/Station');

/**
 * Get all routes with populated station information
 */
const getAllRoutes = async (req, res) => {
    try {
        const routes = await Route.find({ active: true })
            .populate('stations')
            .sort({ code: 1 });

        const formattedRoutes = routes.map(route => ({
            id: route._id,
            name: route.name,
            code: route.code,
            type: route.type,
            description: route.description,
            stations: route.stations.map(station => ({
                id: station._id,
                name: station.name,
                code: station.code,
                orderIndex: station.orderIndex,
                coordinates: station.coordinates
            }))
        }));

        res.json({
            success: true,
            data: formattedRoutes
        });
    } catch (error) {
        console.error('Error fetching routes:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch routes',
            error: error.message
        });
    }
};

/**
 * Get a specific route by ID
 */
const getRouteById = async (req, res) => {
    try {
        const { id } = req.params;
        const route = await Route.findById(id).populate('stations');

        if (!route) {
            return res.status(404).json({
                success: false,
                message: 'Route not found'
            });
        }

        res.json({
            success: true,
            data: {
                id: route._id,
                name: route.name,
                code: route.code,
                type: route.type,
                description: route.description,
                stations: route.stations.map(station => ({
                    id: station._id,
                    name: station.name,
                    code: station.code,
                    orderIndex: station.orderIndex,
                    coordinates: station.coordinates
                }))
            }
        });
    } catch (error) {
        console.error('Error fetching route:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch route',
            error: error.message
        });
    }
};

/**
 * Get all stations
 */
const getAllStations = async (req, res) => {
    try {
        const stations = await Station.find().sort({ orderIndex: 1 });

        res.json({
            success: true,
            data: stations.map(station => ({
                id: station._id,
                name: station.name,
                code: station.code,
                orderIndex: station.orderIndex,
                coordinates: station.coordinates
            }))
        });
    } catch (error) {
        console.error('Error fetching stations:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch stations',
            error: error.message
        });
    }
};

/**
 * Get nearby stations based on coordinates
 */
const getNearbyStations = async (req, res) => {
    try {
        const { lat, lng, limit = 5 } = req.query;

        if (!lat || !lng) {
            return res.status(400).json({
                success: false,
                message: 'Latitude and longitude are required'
            });
        }

        // Get all stations with coordinates
        const stations = await Station.find({
            'coordinates.lat': { $exists: true },
            'coordinates.lng': { $exists: true }
        });

        // Calculate distance for each station
        const stationsWithDistance = stations.map(station => {
            const distance = calculateDistance(
                parseFloat(lat),
                parseFloat(lng),
                station.coordinates.lat,
                station.coordinates.lng
            );

            return {
                id: station._id,
                name: station.name,
                code: station.code,
                orderIndex: station.orderIndex,
                coordinates: station.coordinates,
                distance: distance // in kilometers
            };
        });

        // Sort by distance and limit results
        const nearbyStations = stationsWithDistance
            .sort((a, b) => a.distance - b.distance)
            .slice(0, parseInt(limit));

        res.json({
            success: true,
            data: nearbyStations
        });
    } catch (error) {
        console.error('Error fetching nearby stations:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch nearby stations',
            error: error.message
        });
    }
};

/**
 * Calculate distance between two coordinates using Haversine formula
 */
function calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Radius of the Earth in kilometers
    const dLat = deg2rad(lat2 - lat1);
    const dLon = deg2rad(lon2 - lon1);
    const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = R * c; // Distance in kilometers
    return Math.round(distance * 10) / 10; // Round to 1 decimal place
}

function deg2rad(deg) {
    return deg * (Math.PI / 180);
}

module.exports = {
    getAllRoutes,
    getRouteById,
    getAllStations,
    getNearbyStations
};
