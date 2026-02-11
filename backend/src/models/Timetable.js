const mongoose = require('mongoose');

const scheduleEntrySchema = new mongoose.Schema({
    timeRange: {
        start: {
            type: String,
            required: true
        },
        end: {
            type: String,
            required: true
        }
    },
    frequency: {
        minutes: {
            type: Number,
            required: true
        },
        type: {
            type: String,
            enum: ['Peak', 'Off-Peak', 'Night'],
            required: true
        }
    }
}, { _id: false });

const timetableSchema = new mongoose.Schema({
    route: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Route',
        required: true
    },
    dayType: {
        type: String,
        enum: ['Weekday', 'Weekend', 'Holiday'],
        default: 'Weekday'
    },
    schedule: [scheduleEntrySchema],
    active: {
        type: Boolean,
        default: true
    }
}, {
    timestamps: true
});

// Index for faster queries
timetableSchema.index({ route: 1, dayType: 1 });

module.exports = mongoose.model('Timetable', timetableSchema);
