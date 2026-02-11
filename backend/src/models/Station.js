const mongoose = require('mongoose');

const stationSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    code: {
        type: String,
        required: true,
        unique: true,
        uppercase: true,
        trim: true
    },
    orderIndex: {
        type: Number,
        required: true
    },
    // Optional: for future map integration
    coordinates: {
        lat: Number,
        lng: Number
    }
}, {
    timestamps: true
});

// Index for faster queries

stationSchema.index({ orderIndex: 1 });

module.exports = mongoose.model('Station', stationSchema);
