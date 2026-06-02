import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ZeetechProductsScreen extends StatelessWidget {
  final void Function(String screen, {String? serviceId}) onNavigate;

  const ZeetechProductsScreen({super.key, required this.onNavigate});

  static const List<Map<String, dynamic>> _productCategories = [
    {
      'id': 'ac_products',
      'icon': Icons.ac_unit_rounded,
      'name': 'Air Conditioners',
    },
    {
      'id': 'refrigerator_products',
      'icon': Icons.kitchen_rounded,
      'name': 'Refrigerators',
    },
    {
      'id': 'solar_products',
      'icon': Icons.solar_power_rounded,
      'name': 'Solar Panels',
    },
    {
      'id': 'inverter_products',
      'icon': Icons.battery_charging_full_rounded,
      'name': 'Inverters',
    },
    {
      'id': 'wood_products',
      'icon': Icons.carpenter_rounded,
      'name': 'Wood & Carpenter',
    },
    {
      'id': 'electrician_products',
      'icon': Icons.electrical_services_rounded,
      'name': 'Electrician',
    },
    {
      'id': 'cctv_products',
      'icon': Icons.videocam_rounded,
      'name': 'CCTV Cameras',
    },
    {
      'id': 'washing_machine_products',
      'icon': Icons.local_laundry_service_rounded,
      'name': 'Automatic washing machine',
    },
  ];

  static const List<Map<String, dynamic>> _partsCategories = [
    {
      'id': 'ac_parts',
      'icon': Icons.settings_rounded,
      'name': 'AC Parts',
    },
    {
      'id': 'refrigerator_parts',
      'icon': Icons.thermostat_rounded,
      'name': 'Fridge Parts',
    },
    {
      'id': 'solar_parts',
      'icon': Icons.wb_sunny_rounded,
      'name': 'Solar Parts',
    },
    {
      'id': 'inverter_parts',
      'icon': Icons.power_rounded,
      'name': 'Inverter Parts',
    },
    {
      'id': 'electrician_parts',
      'icon': Icons.cable_rounded,
      'name': 'Electrical Parts',
    },
    {
      'id': 'cctv_parts',
      'icon': Icons.settings_input_composite_rounded,
      'name': 'CCTV Parts',
    },
    {
      'id': 'washing_machine_parts',
      'icon': Icons.settings_rounded,
      'name': 'Washer Parts',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
                    onPressed: () => onNavigate('home'),
                  ),
                ],
              ),
            ),

            // Title Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ZEETECH Store',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Browse products & spare parts for all categories',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                children: [
                  // Section 1: Products
                  _buildSectionHeader(
                    icon: Icons.inventory_2_rounded,
                    title: 'Products',
                    subtitle: 'Complete units & systems',
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryGrid(context, _productCategories),
                  const SizedBox(height: 28),

                  // Section 2: Parts & Accessories
                  _buildSectionHeader(
                    icon: Icons.build_circle_rounded,
                    title: 'Parts & Accessories',
                    subtitle: 'Spare parts for all products',
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryGrid(context, _partsCategories),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context, List<Map<String, dynamic>> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.90,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return GestureDetector(
          onTap: () => onNavigate('product-detail', serviceId: cat['id']),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
