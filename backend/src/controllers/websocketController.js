
const WebSocket = require('ws');
const simulationService = require('../services/simulationService');

class WebSocketController {
    constructor(server) {
        this.wss = new WebSocket.Server({ server });
        this.init();
    }

    init() {
        this.wss.on('connection', (ws) => {
            console.log('New client connected');

            // Send initial state
            this.sendUpdate(ws);

            const interval = setInterval(() => {
                if (ws.readyState === WebSocket.OPEN) {
                    simulationService.updatePositions();
                    this.sendUpdate(ws);
                }
            }, 1000); // 1-second updates

            ws.on('close', () => {
                console.log('Client disconnected');
                clearInterval(interval);
            });

            ws.on('error', (err) => console.error('WS Error:', err));
        });
    }

    sendUpdate(ws) {
        const data = simulationService.getVehicleData();
        ws.send(JSON.stringify({
            timestamp: Date.now(),
            vehicles: data
        }));
    }
}

module.exports = WebSocketController;
