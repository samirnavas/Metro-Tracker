const Timetable = require('../models/Timetable');
const Route = require('../models/Route');

/**
 * Get timetable for a specific route
 */
const getTimetableByRoute = async (req, res) => {
    try {
        const { routeId } = req.params;
        const { dayType = 'Weekday' } = req.query;

        const timetable = await Timetable.findOne({
            route: routeId,
            dayType: dayType,
            active: true
        }).populate('route', 'name code type');

        if (!timetable) {
            return res.status(404).json({
                success: false,
                message: 'Timetable not found for this route'
            });
        }

        res.json({
            success: true,
            data: {
                routeId: timetable.route._id,
                routeName: timetable.route.name,
                routeCode: timetable.route.code,
                routeType: timetable.route.type,
                dayType: timetable.dayType,
                schedule: timetable.schedule
            }
        });
    } catch (error) {
        console.error('Error fetching timetable:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch timetable',
            error: error.message
        });
    }
};

/**
 * Get all timetables
 */
const getAllTimetables = async (req, res) => {
    try {
        const { dayType } = req.query;

        const query = { active: true };
        if (dayType) {
            query.dayType = dayType;
        }

        const timetables = await Timetable.find(query)
            .populate('route', 'name code type')
            .sort({ 'route.code': 1 });

        res.json({
            success: true,
            data: timetables.map(t => ({
                id: t._id,
                routeId: t.route._id,
                routeName: t.route.name,
                routeCode: t.route.code,
                routeType: t.route.type,
                dayType: t.dayType,
                schedule: t.schedule
            }))
        });
    } catch (error) {
        console.error('Error fetching timetables:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch timetables',
            error: error.message
        });
    }
};

module.exports = {
    getTimetableByRoute,
    getAllTimetables
};
