import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ZeetechServicesScreen extends StatelessWidget {
  final void Function(String screen, {String? serviceId}) onNavigate;

  const ZeetechServicesScreen({super.key, required this.onNavigate});

  static const List<Map<String, dynamic>> _categories = [
    {
      'id': 'ac',
      'icon': Icons.ac_unit_rounded,
      'name': 'Air Conditioner',
    },
    {
      'id': 'refrigerator',
      'icon': Icons.kitchen_rounded,
      'name': 'Refrigerator',
    },
    {
      'id': 'solar',
      'icon': Icons.wb_sunny_rounded,
      'name': 'Solar Energy',
    },
    {
      'id': 'inverter',
      'icon': Icons.battery_charging_full_rounded,
      'name': 'Inverter Services',
    },
    {
      'id': 'carpenter',
      'icon': Icons.handyman_rounded,
      'name': 'Carpenter',
    },
    {
      'id': 'electrician',
      'icon': Icons.electrical_services_rounded,
      'name': 'Electrician',
    },
    {
      'id': 'cctv',
      'icon': Icons.videocam_rounded,
      'name': 'CCTV Installation',
    },
    {
      'id': 'washing_machine',
      'icon': Icons.local_laundry_service_rounded,
      'name': 'Automatic washing machine',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Matching premium slate-white background of home screen
      body: Column(
        children: [
          // ── PREMIUM BRAND HEADER BAR ──
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0066FF), Color(0xFF00A3FF)], // Matching home services blue gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0066FF).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(12.0, 14.0, 16.0, 14.0),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => onNavigate('home'),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Home Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Banner Descriptive Subtitle Area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore Expert Services',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select a service category to view specialized repair, installation, and custom plans.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textGray.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // 2. 3x3 Category Grid - Upgraded premium cards
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.88, // Balanced layout ratio
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return GestureDetector(
                  onTap: () => onNavigate('service-detail', serviceId: cat['id']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon inside clean premium brand circular container
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.06),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat['icon'],
                            color: AppColors.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Category Label
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            cat['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
