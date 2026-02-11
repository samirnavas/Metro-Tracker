const mongoose = require('mongoose');

class Database {
    constructor() {
        this.connection = null;
    }

    async connect() {
        try {
            const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/metro-tracker';

            this.connection = await mongoose.connect(mongoURI, {

            });

            console.log('✓ MongoDB connected successfully');

            // Handle connection events
            mongoose.connection.on('error', (err) => {
                console.error('MongoDB connection error:', err);
            });

            mongoose.connection.on('disconnected', () => {
                console.log('MongoDB disconnected');
            });

            return this.connection;
        } catch (error) {
            console.error('MongoDB connection error:', error);
            process.exit(1);
        }
    }

    async disconnect() {
        if (this.connection) {
            await mongoose.disconnect();
            console.log('MongoDB disconnected successfully');
        }
    }
}

module.exports = new Database();
