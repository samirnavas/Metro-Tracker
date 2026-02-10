import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final DraggableScrollableController _bottomSheetController =
      DraggableScrollableController();
  bool _isBottomSheetExpanded = false;
  int _selectedBusIndex = -1;
  bool _isAlertEnabled = false;
  int _selectedTab = 0; // 0 = Live Map, 1 = Timetable

  // Mock data for demonstration
  final List<Map<String, dynamic>> _buses = [
    {
      'id': 'F-12',
      'name': 'Aluva - Edappally',
      'eta': '5 mins',
      'occupancy': 'Medium',
      'speed': '35 km/h',
      'position': 0.3, // Position on timeline
    },
    {
      'id': 'F-08',
      'name': 'Kakkanad - MG Road',
      'eta': '12 mins',
      'occupancy': 'Low',
      'speed': '42 km/h',
      'position': 0.6,
    },
  ];

  final List<Map<String, String>> _stops = [
    {'name': 'Aluva Metro Station', 'time': '2:00 PM'},
    {'name': 'Pulinchode', 'time': '2:05 PM'},
    {'name': 'Companypadi', 'time': '2:10 PM'},
    {'name': 'Ambattukavu', 'time': '2:15 PM'},
    {'name': 'Edappally Metro Station', 'time': '2:25 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content - Timeline View
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildTimelineView()),
              ],
            ),
          ),

          // Sliding Bottom Sheet
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Logo/Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.train, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KochiConnect',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    Text(
                      'Metro Feeder Tracker',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter icon
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppColors.slateGrey),
                onPressed: _showFilterDialog,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search bar with glassmorphic design
          _buildGlassmorphicSearchBar(),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: TextField(
        style: GoogleFonts.roboto(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search routes, stops, or buses...',
          hintStyle: GoogleFonts.roboto(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: const Icon(Icons.mic, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTimelineView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.primary.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          // Tab switcher
          _buildTabSwitcher(),

          // Timeline or Timetable view
          Expanded(
            child: _selectedTab == 0 ? _buildLiveTimeline() : _buildTimetable(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('Live Map', 0, Icons.map),
          ),
          Expanded(
            child: _buildTabButton('Timetable', 1, Icons.schedule),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTimeline() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Buses',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 16),

          // Timeline with buses and stations
          ..._stops.asMap().entries.map((entry) {
            int idx = entry.key;
            Map<String, String> stop = entry.value;
            bool isLast = idx == _stops.length - 1;

            // Check if any bus is near this stop
            Map<String, dynamic>? nearbyBus;
            for (var bus in _buses) {
              double busPos = bus['position'];
              double stopPos = idx / (_stops.length - 1);
              if ((busPos - stopPos).abs() < 0.15) {
                nearbyBus = bus;
                break;
              }
            }

            return _buildTimelineStop(stop, isLast, nearbyBus, idx);
          }).toList(),

          const SizedBox(height: 100), // Space for bottom sheet
        ],
      ),
    );
  }

  Widget _buildTimelineStop(Map<String, String> stop, bool isLast,
      Map<String, dynamic>? nearbyBus, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and icon
        Column(
          children: [
            // Metro station icon (Navy circle)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child:
                  const Icon(Icons.location_on, color: Colors.white, size: 18),
            ),

            // Connecting line
            if (!isLast)
              Container(
                width: 3,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 16),

        // Stop info with glassmorphic card
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            stop['name']!,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMain,
                            ),
                          ),
                        ),
                        Text(
                          stop['time']!,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // Show nearby bus if exists
                    if (nearbyBus != null) ...[
                      const SizedBox(height: 8),
                      _buildBusIndicator(nearbyBus, index),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusIndicator(Map<String, dynamic> bus, int stopIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBusIndex = stopIndex;
          _isBottomSheetExpanded = true;
        });
        _bottomSheetController.animateTo(
          0.9,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Pulsing bus icon
            _buildPulsingBusIcon(),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bus['id'],
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    bus['name'],
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                bus['eta'],
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingBusIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.2 + (value * 0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4 * value),
                blurRadius: 12 * value,
                spreadRadius: 4 * value,
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_bus,
            color: AppColors.primary,
            size: 24,
          ),
        );
      },
      onEnd: () {
        setState(() {}); // Restart animation
      },
    );
  }

  Widget _buildTimetable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route F-12 Schedule',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 16),

          // Timetable with frequency labels
          _buildTimetableCard(),
        ],
      ),
    );
  }

  Widget _buildTimetableCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Time',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Type',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Rows
          ...[
            {
              'time': '6:00 AM - 9:00 AM',
              'type': 'Peak',
              'freq': 'Every 10 mins'
            },
            {
              'time': '9:00 AM - 5:00 PM',
              'type': 'Off-Peak',
              'freq': 'Every 20 mins'
            },
            {
              'time': '5:00 PM - 8:00 PM',
              'type': 'Peak',
              'freq': 'Every 10 mins'
            },
            {
              'time': '8:00 PM - 10:00 PM',
              'type': 'Off-Peak',
              'freq': 'Every 25 mins'
            },
          ].map((row) => _buildTimetableRow(row)).toList(),
        ],
      ),
    );
  }

  Widget _buildTimetableRow(Map<String, String> row) {
    final isPeak = row['type'] == 'Peak';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row['time']!,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: AppColors.textMain,
                  ),
                ),
                Text(
                  row['freq']!,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isPeak
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.slateGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                row['type']!,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPeak ? AppColors.primary : AppColors.slateGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      controller: _bottomSheetController,
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.15, 0.5, 0.9],
      builder: (context, scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            setState(() {
              _isBottomSheetExpanded = notification.extent > 0.3;
            });
            return true;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: _isBottomSheetExpanded
                      ? _buildExpandedBottomSheet(scrollController)
                      : _buildCollapsedBottomSheet(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedBottomSheet() {
    final bus = _buses.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.directions_bus, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nearest Bus',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      bus['id'],
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  bus['eta'],
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedBottomSheet(ScrollController scrollController) {
    final bus = _selectedBusIndex >= 0 ? _buses[0] : _buses.first;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Bus header info
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.directions_bus,
                  color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bus['id'],
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  Text(
                    bus['name'],
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Bus stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard('ETA', bus['eta'], Icons.access_time),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Speed', bus['speed'], Icons.speed),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Load', bus['occupancy'], Icons.people),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Divider
        Divider(color: Colors.grey.withOpacity(0.2)),

        const SizedBox(height: 16),

        // Stops timeline
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Route Stops',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),

            // Alert Me toggle
            _buildAlertToggle(),
          ],
        ),

        const SizedBox(height: 16),

        // List of stops
        ..._stops.asMap().entries.map((entry) {
          int idx = entry.key;
          Map<String, String> stop = entry.value;
          bool isDestination = idx == 3; // Ambattukavu as destination

          return _buildStopItem(stop, idx == _stops.length - 1, isDestination);
        }).toList(),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAlertEnabled = !_isAlertEnabled;
        });

        if (_isAlertEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You\'ll be notified when bus arrives',
                style: GoogleFonts.roboto(),
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isAlertEnabled
              ? AppColors.alertActive
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isAlertEnabled
              ? [
                  BoxShadow(
                    color: AppColors.alertActive.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isAlertEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_outlined,
              color: _isAlertEnabled ? Colors.white : AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Alert Me',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _isAlertEnabled ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopItem(
      Map<String, String> stop, bool isLast, bool isDestination) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDestination ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDestination
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: isDestination
                    ? const Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Stop info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop['name']!,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight:
                        isDestination ? FontWeight.bold : FontWeight.w500,
                    color: AppColors.textMain,
                  ),
                ),
                Text(
                  stop['time']!,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Destination marker
          if (isDestination)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Your Stop',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Filter by Route',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['F-12', 'F-08', 'F-15', 'F-20']
              .map((route) => ListTile(
                    title: Text(route, style: GoogleFonts.roboto()),
                    leading: const Icon(Icons.directions_bus,
                        color: AppColors.primary),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Filtered by $route',
                              style: GoogleFonts.roboto()),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
