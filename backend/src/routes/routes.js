const express = require('express');
const router = express.Router();
const routeController = require('../controllers/routeController');

// Route endpoints
router.get('/routes', routeController.getAllRoutes);
router.get('/routes/:id', routeController.getRouteById);

// Station endpoints
router.get('/stations', routeController.getAllStations);
router.get('/stations/nearby', routeController.getNearbyStations);

module.exports = router;
