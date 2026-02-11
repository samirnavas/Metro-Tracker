const mongoose = require('mongoose');

const vehicleSchema = new mongoose.Schema({
  vehicleId: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  type: {
    type: String,
    enum: ['METRO', 'BUS'],
    required: true
  },
  route: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Route',
    required: true
  },
  currentStation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Station',
    required: true
  },
  nextStation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Station'
  },
  // Progress between current and next station (0.0 to 1.0)
  progressToNextStation: {
    type: Number,
    default: 0,
    min: 0,
    max: 1
  },
  active: {
    type: Boolean,
    default: true
  },
  lastUpdate: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Index for faster queries

vehicleSchema.index({ route: 1, active: 1 });
vehicleSchema.index({ active: 1 });

// Method to convert to JSON for WebSocket transmission
vehicleSchema.methods.toClientJSON = function () {
  return {
    id: this.vehicleId,
    type: this.type,
    routeId: this.route,
    currentStationId: this.currentStation,
    nextStationId: this.nextStation,
    progress: this.progressToNextStation,
    timestamp: Math.floor(this.lastUpdate.getTime() / 1000)
  };
};

module.exports = mongoose.model('Vehicle', vehicleSchema);
