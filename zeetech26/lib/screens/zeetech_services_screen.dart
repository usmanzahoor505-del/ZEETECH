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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Custom App Bar matching Screenshot 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
                    onPressed: () => onNavigate('home'),
                  ),
                ],
              ),
            ),

            // Banner Title Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select a category to view expert service packages',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),

            // 2. 3x3 Category Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.90, // Makes them balanced squares
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return GestureDetector(
                    onTap: () => onNavigate('service-detail', serviceId: cat['id']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.015),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon in a light circular container
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
                          const SizedBox(height: 8),
                          // Category Label
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              cat['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
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
      ),
    );
  }
}
