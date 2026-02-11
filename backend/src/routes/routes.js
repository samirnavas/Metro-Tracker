const express = require('express');
const router = express.Router();
const routeController = require('../controllers/routeController');
const timetableController = require('../controllers/timetableController');

// Route endpoints
router.get('/routes', routeController.getAllRoutes);
router.get('/routes/:id', routeController.getRouteById);

// Station endpoints
router.get('/stations', routeController.getAllStations);
router.get('/stations/nearby', routeController.getNearbyStations);

// Timetable endpoints
router.get('/timetables', timetableController.getAllTimetables);
router.get('/timetables/route/:routeId', timetableController.getTimetableByRoute);

module.exports = router;

