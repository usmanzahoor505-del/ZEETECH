import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../models/product_price_model.dart';
import '../services/product_price_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String categoryId;
  final ValueChanged<String> onNavigate;

  const ProductDetailScreen({
    super.key,
    required this.categoryId,
    required this.onNavigate,
  });

  // ── Product Data ──────────────────────────────────────────────────
  static const Map<String, Map<String, dynamic>> productData = {
    // ── Full Products ──
    'ac_products': {
      'name': 'Air Conditioners',
      'icon': Icons.ac_unit_rounded,
      'items': [
        {'name': 'Split AC 1 Ton (Gree)', 'price': 85000, 'desc': 'Gree Fairy Series 1 Ton Inverter Split AC with WiFi control.'},
        {'name': 'Split AC 1.5 Ton (Haier)', 'price': 110000, 'desc': 'Haier HSU-18 CleanCool Turbo 1.5 Ton Inverter AC.'},
        {'name': 'Window AC 1 Ton (General)', 'price': 65000, 'desc': 'General Window Type AC with Rotary Compressor, R410 gas.'},
        {'name': 'Floor Standing AC 2 Ton', 'price': 180000, 'desc': 'Kenwood Floor Standing 2 Ton AC, ideal for large halls.'},
        {'name': 'Cassette AC 3 Ton', 'price': 250000, 'desc': '4-Way Ceiling Cassette AC for commercial spaces, 3 Ton capacity.'},
        {'name': 'Portable AC 1 Ton', 'price': 55000, 'desc': 'Portable movable AC unit with exhaust hose, no installation needed.'},
      ],
    },
    'refrigerator_products': {
      'name': 'Refrigerators',
      'icon': Icons.kitchen_rounded,
      'items': [
        {'name': 'Haier Refrigerator 12 CFT', 'price': 72000, 'desc': 'Haier HRF-336 Glass Door Refrigerator, E-Star Series.'},
        {'name': 'PEL Life Pro 14 CFT', 'price': 85000, 'desc': 'PEL Life Pro Inverter Refrigerator with water dispenser.'},
        {'name': 'Samsung Side-by-Side', 'price': 220000, 'desc': 'Samsung RS72 Side-by-Side with ice maker, 634L capacity.'},
        {'name': 'Dawlance 9188 WB', 'price': 68000, 'desc': 'Dawlance Chrome Pro 9188 WB with wider cabinets and turbo cooling.'},
        {'name': 'LG Smart Inverter 16 CFT', 'price': 130000, 'desc': 'LG GN-C272 Smart Inverter with linear cooling technology.'},
        {'name': 'Deep Freezer 15 CFT', 'price': 95000, 'desc': 'Haier single door deep freezer for commercial and home storage.'},
      ],
    },
    'solar_products': {
      'name': 'Solar Panels',
      'icon': Icons.solar_power_rounded,
      'items': [
        {'name': 'Longi 550W Panel', 'price': 18000, 'desc': 'Longi Hi-MO5 Mono PERC 550W Solar Panel, A-Grade cells.'},
        {'name': 'JA Solar 540W Panel', 'price': 17000, 'desc': 'JA Solar DeepBlue 3.0 Mono Half-Cell 540W, Tier 1 brand.'},
        {'name': 'Canadian Solar 545W', 'price': 17500, 'desc': 'Canadian Solar HiKu6 Mono 545W with 25-year warranty.'},
        {'name': 'Growatt 6KW Inverter', 'price': 145000, 'desc': 'Growatt MIN 6000TL-X Hybrid On-Grid/Off-Grid Inverter.'},
        {'name': 'Tesla Lithium Battery 5KWh', 'price': 280000, 'desc': 'Lithium Iron Phosphate 48V 100Ah with BMS, wall mountable.'},
        {'name': 'Complete 5KW Solar System', 'price': 650000, 'desc': '10 x 550W panels, 5KW inverter, batteries, wiring & installation.'},
      ],
    },
    'inverter_products': {
      'name': 'Inverters',
      'icon': Icons.battery_charging_full_rounded,
      'items': [
        {'name': 'Homage 1500VA UPS', 'price': 28000, 'desc': 'Homage Matrix HMX-1504 1500VA UPS Inverter for home use.'},
        {'name': 'Luminous 2KVA Inverter', 'price': 42000, 'desc': 'Luminous Eco Watt Neo 2KVA Pure Sine Wave Inverter.'},
        {'name': 'Fronus PV 5200', 'price': 85000, 'desc': 'Fronus Solar Hybrid Inverter 5200W with MPPT charger.'},
        {'name': 'AGS Tubular Battery 185Ah', 'price': 35000, 'desc': 'AGS Deep Cycle Tubular Battery 12V 185Ah for UPS/Solar.'},
        {'name': 'Phoenix Tall Tubular 200Ah', 'price': 42000, 'desc': 'Phoenix XP-200 Tall Tubular Battery, extra backup.'},
        {'name': 'APC Smart UPS 3000VA', 'price': 120000, 'desc': 'APC Smart-UPS 3000VA rack mount for servers and critical loads.'},
      ],
    },
    'wood_products': {
      'name': 'Wood & Carpenter',
      'icon': Icons.carpenter_rounded,
      'items': [
        {'name': 'Sheesham Wood (Per CFT)', 'price': 4500, 'desc': 'Premium Sheesham (Rosewood) lumber, seasoned and kiln dried.'},
        {'name': 'Diyar Wood (Per CFT)', 'price': 3200, 'desc': 'Deodar Cedar wood for furniture, doors and window frames.'},
        {'name': 'MDF Board 8x4 (18mm)', 'price': 4800, 'desc': 'Medium Density Fibreboard 8x4 feet, 18mm thick, for cabinets.'},
        {'name': 'Plywood Sheet 8x4 (12mm)', 'price': 3500, 'desc': 'Commercial plywood sheet 8x4 feet, 12mm waterproof.'},
        {'name': 'Laminate Sheet (Per Sheet)', 'price': 2200, 'desc': 'Formica decorative laminate sheet for table tops & wardrobes.'},
        {'name': 'PVC Edge Banding Roll', 'price': 800, 'desc': '50 meter PVC edge banding roll for MDF furniture finishing.'},
      ],
    },
    'electrician_products': {
      'name': 'Electrician',
      'icon': Icons.electrical_services_rounded,
      'items': [
        {'name': 'Ceiling Fan (Pak Fan)', 'price': 8500, 'desc': 'Pak Fan Emerald 56" copper winding ceiling fan.'},
        {'name': 'LED Panel Light 18W', 'price': 1200, 'desc': 'Square recessed LED panel 18W, cool white 6500K.'},
        {'name': 'Distribution Board 8-Way', 'price': 3500, 'desc': 'Schneider 8-way single phase distribution board with MCBs.'},
        {'name': 'MCB Breaker 32A', 'price': 450, 'desc': 'Schneider EasyPact 32A single pole miniature circuit breaker.'},
        {'name': 'Copper Wire 3/29 (Per KG)', 'price': 2800, 'desc': '3/29 flexible copper wire for house wiring, per KG rate.'},
        {'name': 'Exhaust Fan 12"', 'price': 3200, 'desc': 'National 12 inch metal body exhaust fan for kitchen/bathroom.'},
      ],
    },
    'cctv_products': {
      'name': 'CCTV Cameras',
      'icon': Icons.videocam_rounded,
      'items': [
        {'name': 'Hikvision 2MP Dome Camera', 'price': 4500, 'desc': 'Hikvision DS-2CE56D0T 2MP indoor dome camera, IR night vision.'},
        {'name': 'Dahua 4MP Bullet Camera', 'price': 7500, 'desc': 'Dahua HAC-HFW1400T 4MP outdoor bullet with 30m IR range.'},
        {'name': 'Hikvision 4CH DVR', 'price': 12000, 'desc': 'Hikvision DS-7104 4-Channel Turbo HD DVR, supports 4MP.'},
        {'name': 'Dahua 8CH NVR', 'price': 22000, 'desc': 'Dahua DHI-NVR4108 8-Channel Network Video Recorder with PoE.'},
        {'name': 'WD Purple HDD 1TB', 'price': 8500, 'desc': 'Western Digital Purple 1TB surveillance hard drive, 24/7 rated.'},
        {'name': 'Complete 4-Camera Package', 'price': 35000, 'desc': '4x 2MP cameras, 4CH DVR, 1TB HDD, cables, connectors & setup.'},
      ],
    },
    'washing_machine_products': {
      'name': 'Automatic washing machine',
      'icon': Icons.local_laundry_service_rounded,
      'items': [
        {'name': 'Haier Automatic Washing Machine 9KG', 'price': 65000, 'desc': 'Haier HWM 90-1789 fully automatic top load washing machine.'},
        {'name': 'Samsung EcoBubble Front Load 8KG', 'price': 125000, 'desc': 'Samsung EcoBubble fully automatic front load washing machine with hygiene steam.'},
        {'name': 'Dawlance Inverter Top Load 10KG', 'price': 78000, 'desc': 'Dawlance DWT 270 LVS fully automatic top load machine with extreme drying.'},
        {'name': 'LG AI DD Front Load 9KG', 'price': 145000, 'desc': 'LG AI DD fully automatic front loader with turbo wash technology.'},
      ],
    },

    // ── Parts & Accessories ──
    'ac_parts': {
      'name': 'AC Parts',
      'icon': Icons.settings_rounded,
      'items': [
        {'name': 'AC Compressor (Rotary)', 'price': 8500, 'desc': 'GMCC/Toshiba rotary compressor for 1-1.5 ton split AC.'},
        {'name': 'AC PCB Control Board', 'price': 3500, 'desc': 'Universal indoor unit PCB board with remote control.'},
        {'name': 'AC Fan Motor (Indoor)', 'price': 2200, 'desc': 'Indoor blower fan motor for split AC, YDK type.'},
        {'name': 'Capacitor 35µF', 'price': 350, 'desc': 'CBB65 run capacitor 35µF 450V for outdoor compressor.'},
        {'name': 'Copper Pipe Set (3m)', 'price': 2800, 'desc': 'Insulated copper pipe pair 1/4" + 3/8" with flare nuts, 3 meters.'},
        {'name': 'AC Remote (Universal)', 'price': 500, 'desc': 'Universal AC remote control, compatible with all major brands.'},
      ],
    },
    'refrigerator_parts': {
      'name': 'Fridge Parts',
      'icon': Icons.thermostat_rounded,
      'items': [
        {'name': 'Fridge Compressor', 'price': 7000, 'desc': 'LG/Samsung replacement compressor for 12-16 CFT refrigerators.'},
        {'name': 'Thermostat Switch', 'price': 800, 'desc': 'Temperature control thermostat for single/double door fridges.'},
        {'name': 'Door Gasket Seal', 'price': 1200, 'desc': 'Magnetic rubber door seal gasket, cut to size for any model.'},
        {'name': 'Relay & Overload Kit', 'price': 600, 'desc': 'PTC relay and thermal overload protector for fridge compressor.'},
        {'name': 'Filter Dryer', 'price': 350, 'desc': 'Copper filter dryer for refrigerant line, 1/4" connection.'},
        {'name': 'Defrost Timer', 'price': 900, 'desc': 'Mechanical defrost timer for frost-free refrigerators.'},
      ],
    },
    'solar_parts': {
      'name': 'Solar Parts',
      'icon': Icons.wb_sunny_rounded,
      'items': [
        {'name': 'MC4 Connector Pair', 'price': 150, 'desc': 'MC4 male + female solar panel connector pair, waterproof.'},
        {'name': 'Solar DC Cable 6mm (Per M)', 'price': 120, 'desc': 'UV resistant 6mm² DC solar cable, per meter rate.'},
        {'name': 'Solar Panel Mounting Brackets', 'price': 3500, 'desc': 'L-foot aluminum mounting bracket set for 4 panels.'},
        {'name': 'DC Breaker 32A', 'price': 1200, 'desc': '2-pole 600V DC circuit breaker for solar panel protection.'},
        {'name': 'Solar Charge Controller 30A', 'price': 3500, 'desc': 'PWM 30A solar charge controller with LCD display, 12V/24V.'},
        {'name': 'MPPT Charge Controller 60A', 'price': 15000, 'desc': '60A MPPT solar charge controller with Bluetooth monitoring.'},
      ],
    },
    'inverter_parts': {
      'name': 'Inverter Parts',
      'icon': Icons.power_rounded,
      'items': [
        {'name': 'Inverter Motherboard', 'price': 5500, 'desc': 'Universal replacement PCB board for 1000-2000VA inverters.'},
        {'name': 'Transformer Coil', 'price': 4500, 'desc': 'Copper wound step-up transformer for 1500VA UPS/inverter.'},
        {'name': 'Battery Terminal Clamps', 'price': 250, 'desc': 'Heavy duty brass battery terminal clamps pair with bolts.'},
        {'name': 'Cooling Fan 120mm', 'price': 450, 'desc': '120mm 12V DC cooling fan for inverter/UPS cabinet.'},
        {'name': 'Battery Water (5L)', 'price': 300, 'desc': 'Distilled battery water for tubular/lead acid batteries, 5 liters.'},
        {'name': 'Fuse & Holder Set', 'price': 200, 'desc': 'Glass fuse 30A with inline holder for battery line protection.'},
      ],
    },
    'electrician_parts': {
      'name': 'Electrical Parts',
      'icon': Icons.cable_rounded,
      'items': [
        {'name': 'Switch Board (6-Gang)', 'price': 800, 'desc': 'Modular 6-gang switch board with cover plate, white finish.'},
        {'name': 'Socket Outlet (3-Pin)', 'price': 250, 'desc': 'Heavy duty 3-pin 15A socket outlet for wall mounting.'},
        {'name': 'LED Bulb 12W (Pack of 4)', 'price': 600, 'desc': 'Philips/Osaka 12W LED bulb pack of 4, cool daylight.'},
        {'name': 'Cable Clip Nail (100pcs)', 'price': 150, 'desc': 'Plastic cable clips with nail for wire fixing, pack of 100.'},
        {'name': 'PVC Conduit Pipe 1" (Per 10ft)', 'price': 180, 'desc': '1 inch PVC conduit pipe for concealed wiring, 10 feet.'},
        {'name': 'Voltage Stabilizer 3000VA', 'price': 8500, 'desc': 'Automatic voltage stabilizer 3000VA for AC/Fridge protection.'},
      ],
    },
    'cctv_parts': {
      'name': 'CCTV Parts',
      'icon': Icons.settings_input_composite_rounded,
      'items': [
        {'name': 'BNC Connector (Pack of 10)', 'price': 300, 'desc': 'Male BNC crimp connectors for RG59 coaxial cable, 10 pieces.'},
        {'name': 'CCTV Power Supply 12V 5A', 'price': 1200, 'desc': 'Centralized CCTV power supply adapter 12V 5A for 4 cameras.'},
        {'name': 'RG59 Cable (Per 100m)', 'price': 3500, 'desc': 'Coaxial RG59 cable with power core, 100 meter roll.'},
        {'name': 'CCTV Camera Bracket', 'price': 350, 'desc': 'Metal wall/ceiling mount bracket for bullet/dome cameras.'},
        {'name': 'Video Balun Pair', 'price': 200, 'desc': 'Passive video balun pair for CCTV over UTP cable.'},
        {'name': 'HDMI Splitter 1x4', 'price': 1500, 'desc': '1 input 4 output HDMI splitter for DVR monitor display.'},
      ],
    },
    'washing_machine_parts': {
      'name': 'Washer Parts',
      'icon': Icons.settings_rounded,
      'items': [
        {'name': 'Washing Machine Motor', 'price': 4500, 'desc': 'High quality copper winding replacement motor for top and front load washers.'},
        {'name': 'Water Inlet Solenoid Valve', 'price': 1200, 'desc': 'Dual water inlet valve replacement for automatic washing machines.'},
        {'name': 'Drain Pump Motor Assembly', 'price': 1500, 'desc': 'Universal replacement drain pump motor for automatic washers.'},
        {'name': 'Washing Machine PCB Control Board', 'price': 3000, 'desc': 'Universal automatic washing machine control board with display panel.'},
        {'name': 'Drum Bearing Kit', 'price': 2500, 'desc': 'Premium quality double ball bearing and water seal kit for front loader drum.'},
        {'name': 'Rubber Door Boot Gasket Seal', 'price': 1800, 'desc': 'Replacement door rubber gasket seal for front loader washing machines.'},
      ],
    },
  };

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;

  IconData _getItemIcon(String categoryId) {
    final data = ProductDetailScreen.productData[categoryId];
    if (data != null) return data['icon'] as IconData;
    return Icons.inventory_2_rounded;
  }

  String _getProductId(String categoryId, String itemName) {
    return "${categoryId}_${itemName.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}";
  }

  @override
  void initState() {
    super.initState();
    _loadInitialItems();
    _fetchDbPriceOverrides();
  }

  void _loadInitialItems() {
    final currentCat = ProductDetailScreen.productData[widget.categoryId] ?? 
        ProductDetailScreen.productData['ac_products']!;
    
    final List<Map<String, dynamic>> defaultItems = List<Map<String, dynamic>>.from(
      currentCat['items'] as List
    );

    _items = defaultItems.map((item) {
      return {
        'name': item['name'],
        'price': item['price'],
        'originalPrice': 0, 
        'desc': item['desc'],
      };
    }).toList();
  }

  Future<void> _fetchDbPriceOverrides() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    final overrides = await ProductPriceService.fetchPrices();
    if (overrides.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        // 1. Apply overrides to existing default items
        for (var item in _items) {
          final generatedId = _getProductId(widget.categoryId, item['name']);
          final match = overrides.firstWhere(
            (element) => element.id == generatedId,
            orElse: () => ProductPriceModel(id: '', price: -1, originalPrice: -1),
          );

          if (match.id.isNotEmpty && match.price >= 0) {
            item['price'] = match.price;
            item['originalPrice'] = match.originalPrice;
            if (match.name != null && match.name!.trim().isNotEmpty) {
              item['name'] = match.name;
            }
            if (match.desc != null && match.desc!.trim().isNotEmpty) {
              item['desc'] = match.desc;
            }
          }
        }

        // 2. Append new dynamic custom items belonging to this category
        for (var custom in overrides) {
          if (custom.categoryId == widget.categoryId) {
            final matchedByDefault = _items.any((item) {
              final generatedId = _getProductId(widget.categoryId, item['name']);
              return generatedId == custom.id;
            });
            
            final alreadyAdded = _items.any((item) => item['id'] == custom.id);

            if (!matchedByDefault && !alreadyAdded) {
              _items.add({
                'id': custom.id,
                'name': custom.name ?? 'Custom Product',
                'desc': custom.desc ?? 'Dynamic custom product item.',
                'price': custom.price,
                'originalPrice': custom.originalPrice,
              });
            }
          }
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCat = ProductDetailScreen.productData[widget.categoryId] ?? 
        ProductDetailScreen.productData['ac_products']!;
    final String categoryName = currentCat['name'] as String;
    final IconData categoryIcon = currentCat['icon'] as IconData;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)], // Matching Store card slate gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => widget.onNavigate('products'),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
            )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Header banner
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(categoryIcon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_items.length} products available',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final product = _items[index - 1];
          final String name = product['name'] as String;
          final int price = product['price'] as int;
          final int originalPrice = product['originalPrice'] as int;
          final String desc = product['desc'] as String;

          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (originalPrice > price)
                                  Text(
                                    'Rs. ${_formatPrice(originalPrice)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade400,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                Text(
                                  'Rs. ${_formatPrice(price)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            // Enquire button
                            SizedBox(
                              height: 32,
                              child: OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ZEETECH Store launching soon! Contact us for pricing.'),
                                      backgroundColor: AppColors.primary,
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'ENQUIRE',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count == 3 && i > 0) {
        buffer.write(',');
        count = 0;
      } else if (count > 3 && (count - 3) % 2 == 0 && i > 0) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }
}
