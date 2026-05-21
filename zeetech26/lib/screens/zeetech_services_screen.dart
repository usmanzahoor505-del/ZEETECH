import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ZeetechServicesScreen extends StatelessWidget {
  final void Function(String screen, {String? serviceId}) onNavigate;

  const ZeetechServicesScreen({super.key, required this.onNavigate});

  static const List<Map<String, dynamic>> _services = [
    {
      'id': 'ac',
      'emoji': '❄️',
      'name': 'Air Conditioner',
      'description': 'Installation, repair & maintenance',
      'gradient': AppGradients.ac,
    },
    {
      'id': 'refrigerator',
      'emoji': '🧊',
      'name': 'Refrigerator',
      'description': 'All brands service & repair',
      'gradient': AppGradients.refrigerator,
    },
    {
      'id': 'solar',
      'emoji': '☀️',
      'name': 'Solar Energy',
      'description': 'Solar panel installation & repair',
      'gradient': AppGradients.solar,
    },
    {
      'id': 'inverter',
      'emoji': '🔋',
      'name': 'Inverter Services',
      'description': 'UPS & inverter solutions',
      'gradient': AppGradients.inverter,
    },
    {
      'id': 'carpenter',
      'emoji': '🪚',
      'name': 'Carpenter',
      'description': 'Furniture & woodwork services',
      'gradient': AppGradients.carpenter,
    },
    {
      'id': 'electrician',
      'emoji': '⚡',
      'name': 'General Electrician',
      'description': 'Wiring, fixtures & electrical work',
      'gradient': AppGradients.electrician,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppGradients.header,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Services',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Professional repair & maintenance solutions',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // Services Grid
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72, // Adjust card height
                ),
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return GestureDetector(
                    onTap: () => onNavigate('service-detail', serviceId: service['id']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gradient Header with Emoji
                          Container(
                            height: 110,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: service['gradient'],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(28),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              service['emoji'],
                              style: const TextStyle(fontSize: 48),
                            ),
                          ),

                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      service['description'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Book Now button lookalike
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: AppGradients.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Book Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Emergency Contact Card
              Container(
                decoration: BoxDecoration(
                  gradient: AppGradients.header,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBg.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bolt,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Service?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "We're available 24/7 for urgent repairs",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => onNavigate('contact'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Call Now: 0300-5518622',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
