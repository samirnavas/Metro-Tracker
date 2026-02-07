
const express = require('express');
const http = require('http');
const WebSocketController = require('./src/controllers/websocketController');

const app = express();
const server = http.createServer(app);

// Simple health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok', service: 'Metro Tracker Backend' });
});

// Initialize WebSocket Controller
new WebSocketController(server);

const PORT = 8080;
server.listen(PORT, () => {
    console.log(`Metro Tracker Backend running on port ${PORT}`);
});
