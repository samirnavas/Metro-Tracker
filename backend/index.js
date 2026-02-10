require('dotenv').config();
const express = require('express');
const http = require('http');
const database = require('./src/config/database');
const WebSocketController = require('./src/controllers/websocketController');
const simulationService = require('./src/services/simulationService');
const apiRoutes = require('./src/routes/routes');

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

// Mount API routes
app.use('/api', apiRoutes);

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

        // Start HTTP server on all network interfaces
        const PORT = process.env.PORT || 8080;
        const HOST = '0.0.0.0'; // Listen on all network interfaces

        server.listen(PORT, HOST, () => {
            // Get local network IP for physical device connections
            const os = require('os');
            const networkInterfaces = os.networkInterfaces();
            let localIp = 'Unable to detect';

            // Find the first non-internal IPv4 address
            for (const interfaceName in networkInterfaces) {
                for (const iface of networkInterfaces[interfaceName]) {
                    if (iface.family === 'IPv4' && !iface.internal) {
                        localIp = iface.address;
                        break;
                    }
                }
                if (localIp !== 'Unable to detect') break;
            }

            console.log('\n✅ Server Ready!');
            console.log('─────────────────────────────────────────────────');
            console.log('📱 FOR PHYSICAL DEVICE:');
            console.log(`   HTTP Server: http://${localIp}:${PORT}`);
            console.log(`   WebSocket: ws://${localIp}:${PORT}`);
            console.log(`   Health Check: http://${localIp}:${PORT}/health`);
            console.log('');
            console.log('💻 FOR LOCALHOST/WEB:');
            console.log(`   HTTP Server: http://localhost:${PORT}`);
            console.log(`   WebSocket: ws://localhost:${PORT}`);
            console.log(`   Health Check: http://localhost:${PORT}/health`);
            console.log('');
            console.log('📡 API ENDPOINTS:');
            console.log(`   Routes: http://${localIp}:${PORT}/api/routes`);
            console.log(`   Stations: http://${localIp}:${PORT}/api/stations`);
            console.log(`   Vehicles: http://${localIp}:${PORT}/api/vehicles`);
            console.log('─────────────────────────────────────────────────\n');
            console.log(`💡 TIP: Update Flutter app's localIpAddress to: ${localIp}`);
            console.log('─────────────────────────────────────────────────\n');
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
