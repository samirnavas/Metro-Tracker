require('dotenv').config();
const mongoose = require('mongoose');

async function quickTest() {
    console.log('Testing MongoDB connection...');
    console.log('URI:', process.env.MONGODB_URI?.substring(0, 50) + '...');

    try {
        await mongoose.connect(process.env.MONGODB_URI, {
            serverSelectionTimeoutMS: 10000
        });

        console.log('✅ SUCCESS! MongoDB is connected!');
        console.log('Database:', mongoose.connection.name);

        await mongoose.disconnect();
        process.exit(0);
    } catch (error) {
        console.log('❌ FAILED to connect');
        console.log('Error:', error.message);

        if (error.message.includes('authentication')) {
            console.log('\n💡 Fix: Check your username and password in MongoDB Atlas');
        } else if (error.message.includes('network') || error.message.includes('ENOTFOUND')) {
            console.log('\n💡 Fix: Check your Network Access settings in MongoDB Atlas');
            console.log('   → Allow access from "0.0.0.0/0" (anywhere)');
        }

        process.exit(1);
    }
}

quickTest();
