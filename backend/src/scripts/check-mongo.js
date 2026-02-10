require('dotenv').config();
const mongoose = require('mongoose');

async function checkMongoDB() {
    console.log('🔍 Checking MongoDB connection...\n');

    const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/metro-tracker';
    console.log(`Attempting to connect to: ${mongoURI}\n`);

    try {
        await mongoose.connect(mongoURI, {
            serverSelectionTimeoutMS: 5000
        });

        console.log('✅ MongoDB is running and accessible!\n');

        // Check database
        const databases = await mongoose.connection.db.admin().listDatabases();
        console.log('Available databases:');
        databases.databases.forEach(db => {
            console.log(`  • ${db.name}`);
        });

        // Check if metro-tracker database exists
        const metroTrackerDB = databases.databases.find(db => db.name === 'metro-tracker');

        if (metroTrackerDB) {
            console.log('\n✓ metro-tracker database exists');

            // Check collections
            const collections = await mongoose.connection.db.listCollections().toArray();

            if (collections.length > 0) {
                console.log('\nCollections:');
                for (const col of collections) {
                    const count = await mongoose.connection.db.collection(col.name).countDocuments();
                    console.log(`  • ${col.name}: ${count} documents`);
                }
            } else {
                console.log('\n⚠️  No collections found. Run "npm run seed" to populate the database.');
            }
        } else {
            console.log('\n⚠️  metro-tracker database not found. Run "npm run seed" to create it.');
        }

        await mongoose.disconnect();
        console.log('\n✓ Connection closed');
        process.exit(0);

    } catch (error) {
        console.error('❌ Cannot connect to MongoDB!\n');
        console.error('Error:', error.message);
        console.error('\n📋 Troubleshooting:');
        console.error('  1. Make sure MongoDB is installed');
        console.error('  2. Start MongoDB service:');
        console.error('     Windows: net start MongoDB');
        console.error('     Or manually: mongod --dbpath="C:\\data\\db"');
        console.error('  3. Check if MongoDB is running on port 27017');
        console.error('  4. Update MONGODB_URI in .env if using a different host/port\n');
        process.exit(1);
    }
}

checkMongoDB();
