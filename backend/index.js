require('dotenv').config();
const express = require('express');
const http = require('http');
const database = require('./src/config/database');
const WebSocketController = require('./src/controllers/websocketController');
const simulationService = require('./src/services/simulationService');

const app = express();
const server = http.createServer(app);

// Middleware
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'ok',
        service: 'Metro Tracker Backend',
        timestamp: new Date().toISOString()
    });
});

// API endpoint to get all routes
app.get('/api/routes', async (req, res) => {
    try {
        const routes = await simulationService.getAllRoutes();
        res.json({ success: true, data: routes });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// API endpoint to get vehicle data
app.get('/api/vehicles', async (req, res) => {
    try {
        const vehicles = await simulationService.getVehicleData();
        res.json({ success: true, data: vehicles });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Initialize application
async function startServer() {
    try {
        console.log('🚀 Starting Metro Tracker Backend...\n');

        // Connect to MongoDB
        await database.connect();

        // Initialize WebSocket Controller
        const wsController = new WebSocketController(server);

        // Start simulation engine
        await simulationService.start();

        // Start broadcasting vehicle updates via WebSocket
        wsController.startBroadcasting(1000); // Broadcast every 1 second

        // Start HTTP server
        const PORT = process.env.PORT || 8080;
        server.listen(PORT, () => {
            console.log('\n✅ Server Ready!');
            console.log('─────────────────────────────');
            console.log(`HTTP Server: http://localhost:${PORT}`);
            console.log(`WebSocket: ws://localhost:${PORT}`);
            console.log(`Health Check: http://localhost:${PORT}/health`);
            console.log(`Routes API: http://localhost:${PORT}/api/routes`);
            console.log(`Vehicles API: http://localhost:${PORT}/api/vehicles`);
            console.log('─────────────────────────────\n');
        });

        // Handle graceful shutdown
        process.on('SIGINT', async () => {
            console.log('\n🛑 Shutting down gracefully...');
            simulationService.stop();
            wsController.stopBroadcasting();
            await database.disconnect();
            server.close(() => {
                console.log('✓ Server closed');
                process.exit(0);
            });
        });

    } catch (error) {
        console.error('❌ Failed to start server:', error);
        process.exit(1);
    }
}

// Start the server
startServer();
