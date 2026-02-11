require('dotenv').config();
const database = require('../config/database');
const Station = require('../models/Station');
const Route = require('../models/Route');
const Vehicle = require('../models/Vehicle');
const Timetable = require('../models/Timetable');


// Real Kochi Metro Stations (Line 1: Aluva to Thripunithura)
const METRO_STATIONS = [
    { name: 'Aluva', code: 'ALUVA', orderIndex: 0, coordinates: { lat: 10.1076, lng: 76.3534 } },
    { name: 'Pulinchodu', code: 'PULINCHODU', orderIndex: 1, coordinates: { lat: 10.1014, lng: 76.3497 } },
    { name: 'Companypady', code: 'COMPANYPADY', orderIndex: 2, coordinates: { lat: 10.0962, lng: 76.3461 } },
    { name: 'Ambattukavu', code: 'AMBATTUKAVU', orderIndex: 3, coordinates: { lat: 10.0899, lng: 76.3416 } },
    { name: 'Muttom', code: 'MUTTOM', orderIndex: 4, coordinates: { lat: 10.0835, lng: 76.3370 } },
    { name: 'Kalamassery', code: 'KALAMASSERY', orderIndex: 5, coordinates: { lat: 10.0766, lng: 76.3318 } },
    { name: 'Cochin University', code: 'CUSAT', orderIndex: 6, coordinates: { lat: 10.0690, lng: 76.3256 } },
    { name: 'Pathadipalam', code: 'PATHADIPALAM', orderIndex: 7, coordinates: { lat: 10.0621, lng: 76.3199 } },
    { name: 'Edachira', code: 'EDACHIRA', orderIndex: 8, coordinates: { lat: 10.0571, lng: 76.3159 } },
    { name: 'Changampuzha Park', code: 'CHANGAMPUZHA', orderIndex: 9, coordinates: { lat: 10.0539, lng: 76.3131 } },
    { name: 'Palarivattom', code: 'PALARIVATTOM', orderIndex: 10, coordinates: { lat: 10.0496, lng: 76.3089 } },
    { name: 'JLN Stadium', code: 'JLN', orderIndex: 11, coordinates: { lat: 10.0441, lng: 76.3038 } },
    { name: 'Kaloor', code: 'KALOOR', orderIndex: 12, coordinates: { lat: 10.0264, lng: 76.3086 } },
    { name: 'Town Hall', code: 'TOWNHALL', orderIndex: 13, coordinates: { lat: 10.0183, lng: 76.3041 } },
    { name: 'Maharajas', code: 'MAHARAJAS', orderIndex: 14, coordinates: { lat: 10.0116, lng: 76.2989 } },
    { name: 'MG Road', code: 'MGROAD', orderIndex: 15, coordinates: { lat: 9.9754, lng: 76.2796 } },
    { name: 'Ernakulam South', code: 'ERNAKULSOUTH', orderIndex: 16, coordinates: { lat: 9.9688, lng: 76.2847 } },
    { name: 'Kadavanthara', code: 'KADAVANTHARA', orderIndex: 17, coordinates: { lat: 9.9629, lng: 76.2891 } },
    { name: 'Elamkulam', code: 'ELAMKULAM', orderIndex: 18, coordinates: { lat: 9.9572, lng: 76.2933 } },
    { name: 'Vyttila', code: 'VYTTILA', orderIndex: 19, coordinates: { lat: 9.9405, lng: 76.3013 } },
    { name: 'Thaikoodam', code: 'THAIKOODAM', orderIndex: 20, coordinates: { lat: 9.9461, lng: 76.3153 } },
    { name: 'Petta', code: 'PETTA', orderIndex: 21, coordinates: { lat: 9.9510, lng: 76.3277 } },
    { name: 'SN Junction', code: 'SNJUNCTION', orderIndex: 22, coordinates: { lat: 9.9543, lng: 76.3458 } },
    { name: 'Vadakkekotta', code: 'VADAKKEKOTTA', orderIndex: 23, coordinates: { lat: 9.9560, lng: 76.3556 } },
    { name: 'Thripunithura', code: 'THRIPUNITHURA', orderIndex: 24, coordinates: { lat: 9.9576, lng: 76.3639 } }
];

// Feeder Bus Stations (Example: Aluva Feeder Route)
const FEEDER_STATIONS = [
    { name: 'Aluva Metro Station', code: 'F_ALUVA', orderIndex: 0, coordinates: { lat: 10.1076, lng: 76.3534 } },
    { name: 'Aluva Bus Stand', code: 'F_ALUVA_BUS', orderIndex: 1, coordinates: { lat: 10.1090, lng: 76.3550 } },
    { name: 'Aluva Market', code: 'F_ALUVA_MKT', orderIndex: 2, coordinates: { lat: 10.1100, lng: 76.3580 } },
    { name: 'Medical College Junction', code: 'F_MEDCOL', orderIndex: 3, coordinates: { lat: 10.1120, lng: 76.3620 } },
    { name: 'CISF Campus', code: 'F_CISF', orderIndex: 4, coordinates: { lat: 10.1150, lng: 76.3670 } },
    { name: 'Eloor', code: 'F_ELOOR', orderIndex: 5, coordinates: { lat: 10.1180, lng: 76.3720 } }
];

async function seedDatabase() {
    try {
        console.log('🌱 Starting database seed...\n');

        // Connect to database
        await database.connect();

        // Clear existing data
        console.log('🗑️  Clearing existing data...');
        await Station.deleteMany({});
        await Route.deleteMany({});
        await Vehicle.deleteMany({});
        await Timetable.deleteMany({});
        console.log('✓ Existing data cleared\n');

        // Create Metro Stations
        console.log('📍 Creating Metro stations...');
        const metroStations = await Station.insertMany(METRO_STATIONS);
        console.log(`✓ Created ${metroStations.length} metro stations\n`);

        // Create Feeder Bus Stations
        console.log('📍 Creating Feeder bus stations...');
        const feederStations = await Station.insertMany(FEEDER_STATIONS);
        console.log(`✓ Created ${feederStations.length} feeder stations\n`);

        // Create Metro Route (Line 1)
        console.log('🚇 Creating Metro Line 1 route...');
        const metroRoute = await Route.create({
            name: 'Kochi Metro Line 1',
            code: 'L1',
            type: 'METRO',
            stations: metroStations.map(s => s._id),
            description: 'Aluva to Thripunithura'
        });
        console.log(`✓ Created route: ${metroRoute.name}\n`);

        // Create Feeder Bus Route
        console.log('🚌 Creating Feeder bus route...');
        const feederRoute = await Route.create({
            name: 'Aluva Feeder Route 1',
            code: 'F1',
            type: 'BUS',
            stations: feederStations.map(s => s._id),
            description: 'Aluva Metro to Eloor'
        });
        console.log(`✓ Created route: ${feederRoute.name}\n`);

        // Create Sample Vehicles
        console.log('🚊 Creating sample vehicles...');

        // Metro Train 1 (starting at Aluva)
        const metro1 = await Vehicle.create({
            vehicleId: 'METRO-101',
            type: 'METRO',
            route: metroRoute._id,
            currentStation: metroStations[0]._id,
            nextStation: metroStations[1]._id,
            progressToNextStation: 0,
            active: true
        });

        // Metro Train 2 (starting at MG Road)
        const metro2 = await Vehicle.create({
            vehicleId: 'METRO-102',
            type: 'METRO',
            route: metroRoute._id,
            currentStation: metroStations[15]._id, // MG Road
            nextStation: metroStations[16]._id,
            progressToNextStation: 0.3,
            active: true
        });

        // Feeder Bus 1 (starting at Aluva Metro)
        const bus1 = await Vehicle.create({
            vehicleId: 'BUS-F1-01',
            type: 'BUS',
            route: feederRoute._id,
            currentStation: feederStations[0]._id,
            nextStation: feederStations[1]._id,
            progressToNextStation: 0,
            active: true
        });

        // Feeder Bus 2 (mid-route)
        const bus2 = await Vehicle.create({
            vehicleId: 'BUS-F1-02',
            type: 'BUS',
            route: feederRoute._id,
            currentStation: feederStations[3]._id,
            nextStation: feederStations[4]._id,
            progressToNextStation: 0.5,
            active: true
        });

        console.log(`✓ Created ${4} vehicles\n`);

        // Create Timetables
        console.log('📅 Creating timetables...');

        // Metro Line 1 Timetable (Weekday)
        await Timetable.create({
            route: metroRoute._id,
            dayType: 'Weekday',
            schedule: [
                {
                    timeRange: { start: '6:00 AM', end: '9:00 AM' },
                    frequency: { minutes: 10, type: 'Peak' }
                },
                {
                    timeRange: { start: '9:00 AM', end: '5:00 PM' },
                    frequency: { minutes: 15, type: 'Off-Peak' }
                },
                {
                    timeRange: { start: '5:00 PM', end: '8:00 PM' },
                    frequency: { minutes: 10, type: 'Peak' }
                },
                {
                    timeRange: { start: '8:00 PM', end: '10:00 PM' },
                    frequency: { minutes: 20, type: 'Off-Peak' }
                },
                {
                    timeRange: { start: '10:00 PM', end: '11:00 PM' },
                    frequency: { minutes: 30, type: 'Night' }
                }
            ]
        });

        // Feeder Bus Route Timetable (Weekday)
        await Timetable.create({
            route: feederRoute._id,
            dayType: 'Weekday',
            schedule: [
                {
                    timeRange: { start: '6:00 AM', end: '9:00 AM' },
                    frequency: { minutes: 10, type: 'Peak' }
                },
                {
                    timeRange: { start: '9:00 AM', end: '5:00 PM' },
                    frequency: { minutes: 20, type: 'Off-Peak' }
                },
                {
                    timeRange: { start: '5:00 PM', end: '8:00 PM' },
                    frequency: { minutes: 10, type: 'Peak' }
                },
                {
                    timeRange: { start: '8:00 PM', end: '10:00 PM' },
                    frequency: { minutes: 25, type: 'Off-Peak' }
                }
            ]
        });

        // Weekend timetables (less frequent)
        await Timetable.create({
            route: metroRoute._id,
            dayType: 'Weekend',
            schedule: [
                {
                    timeRange: { start: '7:00 AM', end: '11:00 PM' },
                    frequency: { minutes: 20, type: 'Off-Peak' }
                }
            ]
        });

        await Timetable.create({
            route: feederRoute._id,
            dayType: 'Weekend',
            schedule: [
                {
                    timeRange: { start: '7:00 AM', end: '10:00 PM' },
                    frequency: { minutes: 30, type: 'Off-Peak' }
                }
            ]
        });

        console.log('✓ Created timetables for all routes\n');

        // Display summary
        console.log('📊 Seed Summary:');
        console.log('─────────────────────────────');
        console.log(`Metro Stations: ${metroStations.length}`);
        console.log(`Feeder Stations: ${feederStations.length}`);
        console.log(`Routes: 2 (1 Metro, 1 Bus)`);
        console.log(`Vehicles: 4 (2 Metro, 2 Bus)`);
        console.log(`Timetables: 4 (2 Weekday, 2 Weekend)`);
        console.log('─────────────────────────────\n');

        console.log('✅ Database seeded successfully!');

        // Display some sample data
        console.log('\n🚇 Sample Metro Train:');
        const populatedMetro = await Vehicle.findById(metro1._id)
            .populate('route')
            .populate('currentStation')
            .populate('nextStation');
        console.log(`  ${populatedMetro.vehicleId}`);
        console.log(`  Route: ${populatedMetro.route.name}`);
        console.log(`  Current: ${populatedMetro.currentStation.name}`);
        console.log(`  Next: ${populatedMetro.nextStation.name}`);
        console.log(`  Progress: ${(populatedMetro.progressToNextStation * 100).toFixed(0)}%`);

        console.log('\n🚌 Sample Feeder Bus:');
        const populatedBus = await Vehicle.findById(bus1._id)
            .populate('route')
            .populate('currentStation')
            .populate('nextStation');
        console.log(`  ${populatedBus.vehicleId}`);
        console.log(`  Route: ${populatedBus.route.name}`);
        console.log(`  Current: ${populatedBus.currentStation.name}`);
        console.log(`  Next: ${populatedBus.nextStation.name}`);
        console.log(`  Progress: ${(populatedBus.progressToNextStation * 100).toFixed(0)}%`);

        process.exit(0);
    } catch (error) {
        console.error('❌ Seed error:', error);
        process.exit(1);
    }
}

// Run the seed
seedDatabase();
