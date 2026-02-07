
// Helper for geographic calculations

/**
 * Calculate distance between two points in km
 */
function getDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Radius of the earth in km
    const dLat = deg2rad(lat2 - lat1);
    const dLon = deg2rad(lon2 - lon1);
    const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const d = R * c; // Distance in km
    return d;
}

function deg2rad(deg) {
    return deg * (Math.PI / 180);
}

/**
 * Move a point along a bearing for a given distance
 */
function movePoint(lat, lon, bearing, distanceKm) {
    const R = 6371; // Earth radius in km
    const brng = deg2rad(bearing);
    const d = distanceKm;

    const lat1 = deg2rad(lat);
    const lon1 = deg2rad(lon);

    const lat2 = Math.asin(Math.sin(lat1) * Math.cos(d / R) +
        Math.cos(lat1) * Math.sin(d / R) * Math.cos(brng));

    const lon2 = lon1 + Math.atan2(Math.sin(brng) * Math.sin(d / R) * Math.cos(lat1),
        Math.cos(d / R) - Math.sin(lat1) * Math.sin(lat2));

    return {
        lat: rad2deg(lat2),
        lng: rad2deg(lon2)
    };
}

function rad2deg(rad) {
    return rad * (180 / Math.PI);
}

module.exports = {
    getDistance,
    movePoint
};
