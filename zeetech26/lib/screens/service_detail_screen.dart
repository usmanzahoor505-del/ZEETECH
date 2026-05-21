import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;
  final ValueChanged<String> onNavigate;
  final void Function(
    String serviceName,
    List<Map<String, dynamic>> selectedServices,
    int totalPrice,
    String paymentMethod,
  ) onBook;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    required this.onNavigate,
    required this.onBook,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final Set<Map<String, dynamic>> _selectedServices = {};
  String _selectedPaymentMethod = 'Cash on Service';

  static const Map<String, Map<String, dynamic>> _serviceData = {
    'ac': {
      'name': 'Air Conditioner Services',
      'emoji': '❄️',
      'gradient': AppGradients.ac,
      'description':
          'Expert AC installation, repair, and maintenance services for all major brands. Our certified technicians ensure optimal cooling performance and energy efficiency.',
      'subServices': [
        {'name': 'AC Installation (Split & Window)', 'price': 3500},
        {'name': 'Gas Refill & Leak Detection', 'price': 4500},
        {'name': 'Regular Service & Cleaning', 'price': 1500},
        {'name': 'Compressor Repair/Replacement', 'price': 8500},
        {'name': 'Thermostat & PCB Repair', 'price': 2500},
        {'name': 'Emergency AC Breakdown Service', 'price': 2000},
      ],
    },
    'refrigerator': {
      'name': 'Refrigerator Services',
      'emoji': '🧊',
      'gradient': AppGradients.refrigerator,
      'description':
          'Complete refrigerator repair and maintenance for all brands including Samsung, LG, Haier, PEL, and more. Fast, reliable service to keep your food fresh.',
      'subServices': [
        {'name': 'Cooling System Repair', 'price': 3000},
        {'name': 'Gas Charging & Leak Fix', 'price': 4000},
        {'name': 'Compressor Replacement', 'price': 9000},
        {'name': 'Door Seal Replacement', 'price': 1200},
        {'name': 'Thermostat Repair', 'price': 1800},
        {'name': 'Ice Maker Repair', 'price': 2500},
      ],
    },
    'solar': {
      'name': 'Solar Energy Solutions',
      'emoji': '☀️',
      'gradient': AppGradients.solar,
      'description':
          'Professional solar panel installation and maintenance services. Switch to clean energy and reduce your electricity bills with our expert solutions.',
      'subServices': [
        {'name': 'Solar Panel Installation', 'price': 12000},
        {'name': 'Inverter Installation', 'price': 8000},
        {'name': 'System Maintenance', 'price': 5000},
        {'name': 'Battery Replacement', 'price': 25000},
        {'name': 'Net Metering Setup', 'price': 15000},
        {'name': 'Solar Water Heater Installation', 'price': 10000},
      ],
    },
    'inverter': {
      'name': 'Inverter & UPS Services',
      'emoji': '🔋',
      'gradient': AppGradients.inverter,
      'description':
          'Complete inverter and UPS solutions for homes and businesses. Installation, repair, and battery replacement services for uninterrupted power supply.',
      'subServices': [
        {'name': 'Inverter Installation', 'price': 4000},
        {'name': 'UPS Repair & Maintenance', 'price': 3000},
        {'name': 'Battery Replacement', 'price': 22000},
        {'name': 'Circuit & Wiring Check', 'price': 1500},
        {'name': 'Load Calculation', 'price': 1000},
        {'name': 'Automatic Transfer Switch Setup', 'price': 3500},
      ],
    },
    'carpenter': {
      'name': 'Carpentry Services',
      'emoji': '🪚',
      'gradient': AppGradients.carpenter,
      'description':
          'Expert carpentry and woodwork services including furniture repair, custom woodwork, door/window installation, and interior finishing.',
      'subServices': [
        {'name': 'Furniture Repair & Restoration', 'price': 2500},
        {'name': 'Custom Furniture Making', 'price': 15000},
        {'name': 'Door & Window Installation', 'price': 3000},
        {'name': 'Kitchen Cabinet Work', 'price': 8000},
        {'name': 'Wardrobe Installation', 'price': 10000},
        {'name': 'False Ceiling Work', 'price': 12000},
      ],
    },
    'electrician': {
      'name': 'General Electrician Services',
      'emoji': '⚡',
      'gradient': AppGradients.electrician,
      'description':
          'Professional electrical services for residential and commercial properties. Licensed electricians for safe and reliable electrical work.',
      'subServices': [
        {'name': 'Wiring & Rewiring', 'price': 5000},
        {'name': 'Light Fixtures Installation', 'price': 1500},
        {'name': 'Fan & Chandelier Installation', 'price': 2000},
        {'name': 'Circuit Breaker Repair', 'price': 1200},
        {'name': 'Electric Panel Upgrades', 'price': 7000},
        {'name': 'Emergency Electrical Repairs', 'price': 1800},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    // Pre-select the first service by default so cart is not empty
    final service = _serviceData[widget.serviceId] ?? _serviceData['ac']!;
    final List<Map<String, dynamic>> subServices = List<Map<String, dynamic>>.from(service['subServices']);
    if (subServices.isNotEmpty) {
      _selectedServices.add(subServices.first);
    }
  }

  Future<void> _handlePhoneCall() async {
    final url = Uri.parse("tel:+923005518622");
    try {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch phone dialer');
      }
    } catch (e) {
      debugPrint("Error making call: $e");
    }
  }

  void _toggleServiceSelection(Map<String, dynamic> subService) {
    setState(() {
      if (_selectedServices.contains(subService)) {
        _selectedServices.remove(subService);
      } else {
        _selectedServices.add(subService);
      }
    });
  }

  int _calculateTotalPrice() {
    return _selectedServices.fold<int>(0, (sum, item) => sum + (item['price'] as int));
  }

  @override
  Widget build(BuildContext context) {
    final service = _serviceData[widget.serviceId] ?? _serviceData['ac']!;
    final List<Map<String, dynamic>> subServices = List<Map<String, dynamic>>.from(service['subServices']);
    final int totalPrice = _calculateTotalPrice();

    return Scaffold(
      body: Stack(
        children: [
          // Scrollable content
          Positioned.fill(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Hero Image / Gradient Header
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: service['gradient'],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    service['emoji'],
                    style: const TextStyle(fontSize: 96),
                  ),
                ),

                const SizedBox(height: 24),

                // Text Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Name
                      Text(
                        service['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        service['description'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textGray,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // What We Offer title
                      const Text(
                        'Select Service Offers',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select one or multiple services to book',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sub-services list with prices and add-to-cart style
                      Column(
                        children: subServices.map((subService) {
                          final isSelected = _selectedServices.contains(subService);
                          return GestureDetector(
                            onTap: () => _toggleServiceSelection(subService),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withOpacity(0.02) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.grey.shade200,
                                  width: isSelected ? 1.5 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                                    color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      subService['name'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Rs. ${subService['price']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Payment Method Selector
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPaymentMethod,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                            items: [
                              'Cash on Service',
                              'Bank Transfer',
                              'EasyPaisa / JazzCash'
                            ].map((String method) {
                              return DropdownMenuItem<String>(
                                value: method,
                                child: Text(
                                  method,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  _selectedPaymentMethod = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // CTA Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ready to Book?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total Estimate: Rs. $totalPrice\nPayment: $_selectedPaymentMethod',
                              style: const TextStyle(
                                color: Color(0xE6FFFFFF),
                                fontSize: 13,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // CTA Action buttons
                            InkWell(
                              onTap: _selectedServices.isEmpty
                                  ? () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please select at least one service offer.')),
                                      );
                                    }
                                  : () {
                                      widget.onBook(
                                        service['name'],
                                        _selectedServices.toList(),
                                        totalPrice,
                                        _selectedPaymentMethod,
                                      );
                                    },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: _selectedServices.isEmpty ? Colors.white70 : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Book Selected Services',
                                  style: TextStyle(
                                    color: _selectedServices.isEmpty ? Colors.grey : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: _handlePhoneCall,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.whatsappGreen,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.phone, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Call Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Header float Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: InkWell(
              onTap: () => widget.onNavigate('services'),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0x33FFFFFF)),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
