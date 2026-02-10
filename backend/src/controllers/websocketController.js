const WebSocket = require('ws');
const simulationService = require('../services/simulationService');

class WebSocketController {
    constructor(server) {
        this.wss = new WebSocket.Server({ server });
        this.clients = new Set();
        this.init();
    }

    init() {
        this.wss.on('connection', (ws, req) => {
            console.log('✓ New client connected');
            this.clients.add(ws);

            // Send initial data
            this.sendInitialData(ws);

            // Handle client messages
            ws.on('message', async (message) => {
                try {
                    const data = JSON.parse(message);
                    await this.handleMessage(ws, data);
                } catch (error) {
                    console.error('Error handling message:', error);
                }
            });

            ws.on('close', () => {
                console.log('✓ Client disconnected');
                this.clients.delete(ws);
            });

            ws.on('error', (err) => {
                console.error('WebSocket error:', err);
                this.clients.delete(ws);
            });
        });

        console.log('✓ WebSocket server initialized');
    }

    /**
     * Send initial data to newly connected client
     */
    async sendInitialData(ws) {
        try {
            // Send all routes
            const routes = await simulationService.getAllRoutes();
            this.send(ws, {
                type: 'ROUTES',
                data: routes
            });

            // Send current vehicle positions
            const vehicles = await simulationService.getVehicleData();
            this.send(ws, {
                type: 'VEHICLE_UPDATE',
                timestamp: Date.now(),
                data: vehicles
            });
        } catch (error) {
            console.error('Error sending initial data:', error);
        }
    }

    /**
     * Handle incoming messages from clients
     */
    async handleMessage(ws, message) {
        switch (message.type) {
            case 'GET_ROUTES':
                const routes = await simulationService.getAllRoutes();
                this.send(ws, {
                    type: 'ROUTES',
                    data: routes
                });
                break;

            case 'GET_VEHICLES':
                const vehicles = await simulationService.getVehicleData();
                this.send(ws, {
                    type: 'VEHICLE_UPDATE',
                    timestamp: Date.now(),
                    data: vehicles
                });
                break;

            case 'GET_ROUTE':
                if (message.routeId) {
                    const route = await simulationService.getRouteData(message.routeId);
                    this.send(ws, {
                        type: 'ROUTE_DATA',
                        data: route
                    });
                }
                break;

            default:
                console.log('Unknown message type:', message.type);
        }
    }

    /**
     * Broadcast vehicle updates to all connected clients
     */
    async broadcastVehicleUpdate() {
        if (this.clients.size === 0) return;

        try {
            const vehicles = await simulationService.getVehicleData();
            const message = {
                type: 'VEHICLE_UPDATE',
                timestamp: Date.now(),
                data: vehicles
            };

            this.broadcast(message);
        } catch (error) {
            console.error('Error broadcasting vehicle update:', error);
        }
    }

    /**
     * Send message to a specific client
     */
    send(ws, message) {
        if (ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify(message));
        }
    }

    /**
     * Broadcast message to all connected clients
     */
    broadcast(message) {
        const data = JSON.stringify(message);
        this.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(data);
            }
        });
    }

    /**
     * Start periodic broadcasts
     */
    startBroadcasting(interval = 1000) {
        this.broadcastInterval = setInterval(() => {
            this.broadcastVehicleUpdate();
        }, interval);
        console.log(`✓ Broadcasting vehicle updates every ${interval}ms`);
    }

    /**
     * Stop periodic broadcasts
     */
    stopBroadcasting() {
        if (this.broadcastInterval) {
            clearInterval(this.broadcastInterval);
            this.broadcastInterval = null;
        }
    }
}

module.exports = WebSocketController;
