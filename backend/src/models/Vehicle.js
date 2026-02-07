
class Vehicle {
  constructor(id, type, routeId, lat, lng, bearing = 0, speed = 0) {
    this.id = id;
    this.type = type; // 'BUS' or 'METRO'
    this.routeId = routeId;
    this.lat = lat;
    this.lng = lng;
    this.bearing = bearing;
    this.speed = speed;
    this.lastUpdate = Date.now();
  }

  toJSON() {
    return {
      id: this.id,
      type: this.type,
      lat: this.lat,
      lng: this.lng,
      bearing: this.bearing,
      speed: this.speed,
      routeId: this.routeId,
      timestamp: Math.floor(this.lastUpdate / 1000)
    };
  }
}

module.exports = Vehicle;
