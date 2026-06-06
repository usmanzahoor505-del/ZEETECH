import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/cart_service.dart';
import '../models/service_price_model.dart';
import '../services/service_price_service.dart';
import '../services/user_auth_service.dart';
import '../services/membership_application_service.dart';
import '../models/membership_application_model.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;
  final ValueChanged<String> onNavigate;
  final void Function(
    String serviceName,
    List<Map<String, dynamic>> selectedServices,
    int totalPrice,
    String paymentMethod,
  ) onBook; // Kept for legacy compatibility

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
  // Icon map for each sub-service based on its ID
  static const Map<String, IconData> _subServiceIcons = {
    // AC
    'ac_1': Icons.ac_unit_rounded,
    'ac_2': Icons.propane_tank_rounded,
    'ac_3': Icons.cleaning_services_rounded,
    'ac_4': Icons.settings_rounded,
    'ac_5': Icons.memory_rounded,
    'ac_6': Icons.flash_on_rounded,
    // Refrigerator
    'ref_1': Icons.thermostat_rounded,
    'ref_2': Icons.propane_tank_rounded,
    'ref_3': Icons.settings_rounded,
    'ref_4': Icons.sensor_door_rounded,
    'ref_5': Icons.device_thermostat_rounded,
    'ref_6': Icons.ice_skating_rounded,
    // Solar
    'sol_1': Icons.solar_power_rounded,
    'sol_2': Icons.electrical_services_rounded,
    'sol_3': Icons.build_circle_rounded,
    'sol_4': Icons.battery_charging_full_rounded,
    'sol_5': Icons.electric_meter_rounded,
    'sol_6': Icons.water_drop_rounded,
    // Inverter
    'inv_1': Icons.power_rounded,
    'inv_2': Icons.handyman_rounded,
    'inv_3': Icons.battery_full_rounded,
    'inv_4': Icons.cable_rounded,
    'inv_5': Icons.calculate_rounded,
    'inv_6': Icons.toggle_on_rounded,
    // Carpenter
    'carp_1': Icons.handyman_rounded,
    'carp_2': Icons.build_rounded,
    'carp_3': Icons.door_sliding_rounded,
    'carp_4': Icons.sensor_door_rounded,
    'carp_5': Icons.lock_rounded,
    'carp_6': Icons.chair_rounded,
    'carp_7': Icons.chair_rounded,
    'carp_8': Icons.lock_outline_rounded,
    'carp_9': Icons.checkroom_rounded,
    // Electrician
    'elec_1': Icons.tv_rounded,
    'elec_2': Icons.tv_rounded,
    'elec_3': Icons.local_laundry_service_rounded,
    'elec_4': Icons.electric_bolt_rounded,
    'elec_5': Icons.handyman_rounded,
    'elec_6': Icons.power_rounded,
    'elec_7': Icons.lightbulb_rounded,
    'elec_8': Icons.cable_rounded,
    'elec_9': Icons.handyman_rounded,
    'elec_10': Icons.toggle_on_rounded,
    'elec_11': Icons.tungsten_rounded,
    'elec_12': Icons.tungsten_rounded,
    'elec_13': Icons.flash_on_rounded,
    'elec_14': Icons.kitchen_rounded,
    'elec_15': Icons.kitchen_rounded,
    'elec_16': Icons.tv_rounded,
    'elec_17': Icons.electrical_services_rounded,
    'elec_18': Icons.electrical_services_rounded,
    'elec_19': Icons.local_laundry_service_rounded,
    'elec_20': Icons.cable_rounded,
    'elec_21': Icons.electrical_services_rounded,
    'elec_22': Icons.electrical_services_rounded,
    'elec_23': Icons.electric_bolt_rounded,
    'elec_24': Icons.offline_bolt_rounded,
    'elec_25': Icons.electric_meter_rounded,
    'elec_26': Icons.lightbulb_rounded,
    'elec_27': Icons.lightbulb_rounded,
    'elec_28': Icons.electric_meter_rounded,
    'elec_29': Icons.power_rounded,
    'elec_30': Icons.lightbulb_rounded,
    'elec_31': Icons.handyman_rounded,
    'elec_32': Icons.lightbulb_rounded,
    'elec_33': Icons.battery_charging_full_rounded,
    'elec_34': Icons.handyman_rounded,
    'elec_35': Icons.cable_rounded,
    'elec_36': Icons.handyman_rounded,
    'elec_37': Icons.water_drop_rounded,
    // CCTV
    'cctv_1': Icons.videocam_rounded,
    'cctv_2': Icons.dns_rounded,
    'cctv_3': Icons.settings_input_composite_rounded,
    'cctv_4': Icons.security_rounded,
    // Washing Machine
    'wm_1': Icons.local_laundry_service_rounded,
    'wm_2': Icons.settings_rounded,
    'wm_3': Icons.memory_rounded,
    'wm_4': Icons.water_drop_rounded,
    'wm_5': Icons.water_rounded,
    'wm_6': Icons.developer_board_rounded,
    'wm_7': Icons.sensor_door_rounded,
    'wm_8': Icons.rotate_right_rounded,
    'wm_9': Icons.cleaning_services_rounded,
    'wm_10': Icons.loop_rounded,
  };

  // Category-level fallback icons
  static const Map<String, IconData> _categoryIcons = {
    'ac': Icons.ac_unit_rounded,
    'refrigerator': Icons.kitchen_rounded,
    'solar': Icons.wb_sunny_rounded,
    'inverter': Icons.battery_charging_full_rounded,
    'carpenter': Icons.handyman_rounded,
    'electrician': Icons.electrical_services_rounded,
    'cctv': Icons.videocam_rounded,
    'washing_machine': Icons.local_laundry_service_rounded,
  };

  IconData _getSubServiceIcon(String itemId) {
    return _subServiceIcons[itemId] ?? _categoryIcons[widget.serviceId] ?? Icons.build_outlined;
  }

  // Static mockup sub-services for all 7 categories
  static const Map<String, Map<String, dynamic>> _categoryData = {
    'ac': {
      'name': 'Air Conditioner',
      'description': 'Expert AC installation, repair, and maintenance services for all major brands.',
      'items': [
        {'id': 'ac_1', 'name': 'AC Dismounting', 'price': 1200, 'originalPrice': 1500, 'desc': 'Per AC (1 to 2.5 tons)', 'imageUrl': 'https://images.unsplash.com/photo-1572981779307-38b8c7bb40d8?w=150&q=80'},
        {'id': 'ac_2', 'name': 'AC General Service', 'price': 2500, 'originalPrice': 3300, 'desc': 'Per AC (1 to 2.5 tons)', 'imageUrl': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=150&q=80'},
        {'id': 'ac_3', 'name': 'AC Installation', 'price': 3200, 'originalPrice': 5100, 'desc': 'Installation with 10 Feet pipe (1 to 2.5 tons)', 'imageUrl': 'https://images.unsplash.com/photo-1572981779307-38b8c7bb40d8?w=150&q=80'},
        {'id': 'ac_4', 'name': 'AC Mounting and Dismounting', 'price': 4000, 'originalPrice': 6400, 'desc': 'Per AC (1 to 2.5 tons)', 'imageUrl': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=150&q=80'},
        {'id': 'ac_5', 'name': 'AC Mounting and Dismounting + AC General Service', 'price': 5500, 'originalPrice': 8500, 'desc': 'Per AC (1 to 2.5 tons)', 'imageUrl': 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=150&q=80'},
        {'id': 'ac_6', 'name': 'AC Repairing', 'price': 800, 'originalPrice': 1000, 'desc': 'Visit and Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1581092162384-8987c1d64726?w=150&q=80'},
      ]
    },
    'refrigerator': {
      'name': 'Refrigerator',
      'description': 'Complete refrigerator repair and maintenance for all brands including Samsung, LG, Haier, PEL, and more.',
      'items': [
        {'id': 'ref_1', 'name': 'Cooling System Repair', 'price': 3000, 'originalPrice': 4200, 'desc': 'Thermostat, relay, capacitor or fan repair to restore cold cycles.', 'imageUrl': 'https://images.unsplash.com/photo-1571175483883-7c1303b71556?w=150&q=80'},
        {'id': 'ref_2', 'name': 'Gas Charging & Leak Fix', 'price': 4000, 'originalPrice': 5500, 'desc': 'Flushing lines, filter dryer change, pressure test and pure R134a/R600 charging.', 'imageUrl': 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=150&q=80'},
        {'id': 'ref_3', 'name': 'Compressor Replacement', 'price': 9000, 'originalPrice': 12500, 'desc': 'Branded compressor installation with filter dryer and pressure test.', 'imageUrl': 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=150&q=80'},
        {'id': 'ref_4', 'name': 'Door Seal Replacement', 'price': 1200, 'originalPrice': 1800, 'desc': 'Replacing damaged or magnetic rubber lining to stop cooling loss.', 'imageUrl': 'https://images.unsplash.com/photo-1581092160562-42c262a63255?w=150&q=80'},
        {'id': 'ref_5', 'name': 'Thermostat Repair', 'price': 1800, 'originalPrice': 2500, 'desc': 'Replacing faulty temperature control thermostat switches.', 'imageUrl': 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=150&q=80'},
        {'id': 'ref_6', 'name': 'Ice Maker Repair', 'price': 2500, 'originalPrice': 3500, 'desc': 'Fixing supply lines, valves, and control board of automatic ice dispensers.', 'imageUrl': 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=150&q=80'},
      ]
    },
    'solar': {
      'name': 'Solar Energy',
      'description': 'Professional solar panel installation and maintenance services. Switch to clean energy and reduce bills.',
      'items': [
        {'id': 'sol_1', 'name': 'Solar Panel Installation', 'price': 12000, 'originalPrice': 16500, 'desc': 'Mounting solar panels on standard structures with secure electrical connections.', 'imageUrl': 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=150&q=80'},
        {'id': 'sol_2', 'name': 'Inverter Installation', 'price': 8000, 'originalPrice': 11000, 'desc': 'Wall mounting solar inverter, DC/AC breaker boxes and cable routing.', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'sol_3', 'name': 'System Maintenance', 'price': 5000, 'originalPrice': 7000, 'desc': 'Cleaning panels, inspecting MC4 connectors, and verifying output current.', 'imageUrl': 'https://images.unsplash.com/photo-1613665813446-82a78c468a1d?w=150&q=80'},
        {'id': 'sol_4', 'name': 'Battery Replacement', 'price': 25000, 'originalPrice': 32000, 'desc': 'Upgrading to high-capacity deep cycle tubular batteries or Lithium battery packs.', 'imageUrl': 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=150&q=80'},
        {'id': 'sol_5', 'name': 'Net Metering Setup', 'price': 15000, 'originalPrice': 20000, 'desc': 'Three-phase green meter application process, documentation, and install.', 'imageUrl': 'https://images.unsplash.com/photo-1581092921461-eab62e97a780?w=150&q=80'},
        {'id': 'sol_6', 'name': 'Solar Water Heater Installation', 'price': 10000, 'originalPrice': 14000, 'desc': 'Assembling glass vacuum tubes, hot water tank, and plumbing connections.', 'imageUrl': 'https://images.unsplash.com/photo-1613665813446-82a78c468a1d?w=150&q=80'},
      ]
    },
    'inverter': {
      'name': 'Inverter Services',
      'description': 'Complete inverter and UPS solutions for homes and businesses. Installation, repair, and battery replacement.',
      'items': [
        {'id': 'inv_1', 'name': 'Inverter Installation', 'price': 4000, 'originalPrice': 5500, 'desc': 'Setting up hybrid/standard home UPS with battery connections.', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'inv_2', 'name': 'UPS Repair & Maintenance', 'price': 3000, 'originalPrice': 4200, 'desc': 'Replacing motherboard components, capacitors, or cooling fan.', 'imageUrl': 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=150&q=80'},
        {'id': 'inv_3', 'name': 'Battery Replacement', 'price': 22000, 'originalPrice': 29000, 'desc': 'Installing new deep cycle tubular battery with terminal greasing.', 'imageUrl': 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=150&q=80'},
        {'id': 'inv_4', 'name': 'Circuit & Wiring Check', 'price': 1500, 'originalPrice': 2200, 'desc': 'Verifying load separation, input neutral lines and output circuits.', 'imageUrl': 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=150&q=80'},
        {'id': 'inv_5', 'name': 'Load Calculation', 'price': 1000, 'originalPrice': 1500, 'desc': 'Professional system loading check to prevent overload and battery drain.', 'imageUrl': 'https://images.unsplash.com/photo-1581092921461-eab62e97a780?w=150&q=80'},
        {'id': 'inv_6', 'name': 'Automatic Transfer Switch Setup', 'price': 3500, 'originalPrice': 4800, 'desc': 'Installing ATS breaker panel for automated shifting between WAPDA and UPS.', 'imageUrl': 'https://images.unsplash.com/photo-1618588507085-c79565432917?w=150&q=80'},
      ]
    },
    'carpenter': {
      'name': 'Carpenter',
      'description': 'Expert carpentry and woodwork services including furniture repair, custom woodwork, and fittings.',
      'items': [
        {'id': 'carp_1', 'name': 'Carpenter Work', 'price': 500, 'originalPrice': 800, 'desc': 'Visit & Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?w=150&q=80'},
        {'id': 'carp_2', 'name': 'Catcher Replacement', 'price': 500, 'originalPrice': 800, 'desc': 'Per Catcher', 'imageUrl': 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=150&q=80'},
        {'id': 'carp_3', 'name': 'Door Installation', 'price': 1000, 'originalPrice': 1500, 'desc': 'Starting From', 'imageUrl': 'https://images.unsplash.com/photo-1507089947368-19c1da9775ae?w=150&q=80'},
        {'id': 'carp_4', 'name': 'Door Repairing', 'price': 500, 'originalPrice': 800, 'desc': 'Visit & Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1507089947368-19c1da9775ae?w=150&q=80'},
        {'id': 'carp_5', 'name': 'Drawer Lock installation', 'price': 500, 'originalPrice': 800, 'desc': 'Per Lock', 'imageUrl': 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=150&q=80'},
        {'id': 'carp_6', 'name': 'Drawer Repairing', 'price': 500, 'originalPrice': 800, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=150&q=80'},
        {'id': 'carp_7', 'name': 'Furniture Repairing', 'price': 500, 'originalPrice': 500, 'desc': 'Visit & Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?w=150&q=80'},
        {'id': 'carp_8', 'name': 'Room Door Lock installation', 'price': 1200, 'originalPrice': 1500, 'desc': 'Vary After inspection', 'imageUrl': 'https://images.unsplash.com/photo-1507089947368-19c1da9775ae?w=150&q=80'},
        {'id': 'carp_9', 'name': 'Wardrobe Repairing', 'price': 500, 'originalPrice': 800, 'desc': 'Visit & Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=150&q=80'},
      ]
    },
    'electrician': {
      'name': 'Electrician',
      'description': 'Professional electrical services for residential and commercial properties. Licensed electricians.',
      'items': [
        {'id': 'elec_1', 'name': '32-42 Inch LED TV or LCD Mounting', 'price': 1250, 'originalPrice': 1500, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1593784991095-a205069470b6?w=150&q=80'},
        {'id': 'elec_2', 'name': '43-65 Inch LED TV or LCD Mounting', 'price': 1600, 'originalPrice': 2000, 'desc': 'Starting from Per LED/LCD', 'imageUrl': 'https://images.unsplash.com/photo-1593784991095-a205069470b6?w=150&q=80'},
        {'id': 'elec_3', 'name': 'Automatic Washing Machine Repairing', 'price': 800, 'originalPrice': 1000, 'desc': 'Visit and Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1581092921461-eab62e97a780?w=150&q=80'},
        {'id': 'elec_4', 'name': 'Ceiling Fan Installation', 'price': 800, 'originalPrice': 900, 'desc': 'Per Fan', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_5', 'name': 'Ceiling Fan Repairing', 'price': 500, 'originalPrice': 800, 'desc': 'Visit & Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1540932239986-30128078f3c5?w=150&q=80'},
        {'id': 'elec_6', 'name': 'Change Over Switch Installation', 'price': 1200, 'originalPrice': 1700, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_7', 'name': 'Door Pillar Lights', 'price': 600, 'originalPrice': 800, 'desc': 'Vary After inspection', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_8', 'name': 'Electrical Wiring', 'price': 500, 'originalPrice': 800, 'desc': 'Visit and Inspection charges', 'imageUrl': 'https://images.unsplash.com/photo-1534224039826-c7a0dea0e66a?w=150&q=80'},
        {'id': 'elec_9', 'name': 'Exhaust Fan Installation', 'price': 500, 'originalPrice': 800, 'desc': 'Per Fan (Fit in existing hole)', 'imageUrl': 'https://images.unsplash.com/photo-1540932239986-30128078f3c5?w=150&q=80'},
        {'id': 'elec_10', 'name': 'Fan Dimmer Switch Installation', 'price': 600, 'originalPrice': 800, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_11', 'name': 'Fancy Light Installation (With Wiring)', 'price': 1000, 'originalPrice': 1200, 'desc': 'Per Light (Discount on more then 2)', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_12', 'name': 'Fancy Light Installation (Without Wiring)', 'price': 800, 'originalPrice': 900, 'desc': 'Per Light (Discount on more then 2)', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_13', 'name': 'House Electric Work', 'price': 800, 'originalPrice': 900, 'desc': 'Visit and Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1618221823713-c980327f3001?w=150&q=80'},
        {'id': 'elec_14', 'name': 'Kitchen Hood Installation', 'price': 500, 'originalPrice': 900, 'desc': 'Visit and Inspection charges', 'imageUrl': 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=150&q=80'},
        {'id': 'elec_15', 'name': 'Kitchen Hood Repairing', 'price': 800, 'originalPrice': 900, 'desc': 'Visit and Inspection charges', 'imageUrl': 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=150&q=80'},
        {'id': 'elec_16', 'name': 'LED TV Dismounting', 'price': 700, 'originalPrice': 900, 'desc': 'Per LED/LCD', 'imageUrl': 'https://images.unsplash.com/photo-1593784991095-a205069470b6?w=150&q=80'},
        {'id': 'elec_17', 'name': 'Light Plug (With Wiring)', 'price': 700, 'originalPrice': 800, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_18', 'name': 'Light Plug (Without Wiring)', 'price': 650, 'originalPrice': 800, 'desc': 'Per Plug', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_19', 'name': 'Manual Washing machine repairing', 'price': 800, 'originalPrice': 900, 'desc': 'Visit and Inspection charges', 'imageUrl': 'https://images.unsplash.com/photo-1581092921461-eab62e97a780?w=150&q=80'},
        {'id': 'elec_20', 'name': 'New House Wiring', 'price': 500, 'originalPrice': 800, 'desc': 'Visit and Inspection charges', 'imageUrl': 'https://images.unsplash.com/photo-1534224039826-c7a0dea0e66a?w=150&q=80'},
        {'id': 'elec_21', 'name': 'Power Plug Installation (With Wiring)', 'price': 900, 'originalPrice': 1000, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_22', 'name': 'Power Plug Installation (Without Wiring)', 'price': 800, 'originalPrice': 900, 'desc': 'Per Plug', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_23', 'name': 'Pressure Motor Installation', 'price': 500, 'originalPrice': 800, 'desc': 'Visit and Inspection charges', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_24', 'name': 'Single Phase Breaker Replacement', 'price': 800, 'originalPrice': 900, 'desc': 'Starting From', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_25', 'name': 'Single Phase Distribution Box Installation', 'price': 2000, 'originalPrice': 2200, 'desc': 'Starting From', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_26', 'name': 'SMD Lights Installation (With Wiring)', 'price': 800, 'originalPrice': 900, 'desc': 'Per Light (Discount on more then 2)', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_27', 'name': 'SMD Lights Installation (Without Wiring)', 'price': 500, 'originalPrice': 800, 'desc': 'Per Light (Discount on more then 2)', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_28', 'name': 'Sub-Meter Installation', 'price': 1000, 'originalPrice': 1200, 'desc': 'Starting From', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_29', 'name': 'Switchboard Button Replacement', 'price': 500, 'originalPrice': 800, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_30', 'name': 'Tube light Installation', 'price': 600, 'originalPrice': 800, 'desc': 'Per Tube Light', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_31', 'name': 'Tube Light Repairing', 'price': 500, 'originalPrice': 800, 'desc': 'Visit & Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_32', 'name': 'Tube Light Replacement', 'price': 650, 'originalPrice': 800, 'desc': 'Per Tube Light', 'imageUrl': 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=150&q=80'},
        {'id': 'elec_33', 'name': 'UPS installation (Without Wiring)', 'price': 1500, 'originalPrice': 1800, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_34', 'name': 'UPS Repairing', 'price': 800, 'originalPrice': 900, 'desc': 'Visit and Inspection charges', 'imageUrl': 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=150&q=80'},
        {'id': 'elec_35', 'name': 'UPS Wiring', 'price': 500, 'originalPrice': 800, 'desc': 'Visit and Inspection charges', 'imageUrl': 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=150&q=80'},
        {'id': 'elec_36', 'name': 'Water Pump Repairing', 'price': 500, 'originalPrice': 800, 'desc': 'Visit and Inspection Charges', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
        {'id': 'elec_37', 'name': 'Water Tank Automatic Switch Installation', 'price': 800, 'originalPrice': 900, 'desc': 'Vary After Inspection', 'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=150&q=80'},
      ]
    },
    'cctv': {
      'name': 'CCTV Installation',
      'description': 'Professional surveillance systems, DVR setups, cabling, and remote viewing configuration.',
      'items': [
        {'id': 'cctv_1', 'name': 'CCTV Camera Setup (Single Unit)', 'price': 1200, 'originalPrice': 1800, 'desc': 'Camera mounting, cable tagging, BNC connection, and focus adjustment.', 'imageUrl': 'https://images.unsplash.com/photo-1557597774-9d273605dfa9?w=150&q=80'},
        {'id': 'cctv_2', 'name': 'DVR/NVR 4-Channel Program', 'price': 2500, 'originalPrice': 3500, 'desc': 'Configuring hard drive recording, motion zones, and mobile screen mirror.', 'imageUrl': 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=150&q=80'},
        {'id': 'cctv_3', 'name': 'CCTV Security Cabling (Per RFT)', 'price': 400, 'originalPrice': 600, 'desc': 'Cabling inside durable high quality protective PVC duct pipes.', 'imageUrl': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=150&q=80'},
        {'id': 'cctv_4', 'name': 'Complete 4-Camera Security Pack', 'price': 15000, 'originalPrice': 22000, 'desc': 'Includes 4 HD dome cameras, DVR, cabling, power supply, and complete setup.', 'imageUrl': 'https://images.unsplash.com/photo-1524413840807-0c3cb6fa808d?w=150&q=80'},
      ]
    },
    'washing_machine': {
      'name': 'Automatic washing machine',
      'description': 'Complete automatic washing machine repair, installation, and maintenance services for all brands including Samsung, LG, Haier, Dawlance, and more.',
      'items': [
        {'id': 'wm_1', 'name': 'Auto Washing Machine Repairing', 'price': 800, 'originalPrice': 1000, 'desc': 'Visit and Inspection Charges for automatic washing machine.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_2', 'name': 'Auto Washing Machine Installation', 'price': 1500, 'originalPrice': 2000, 'desc': 'New automatic washing machine setup with water inlet, drain pipe, and power connection.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_3', 'name': 'Drum Bearing Replacement', 'price': 2500, 'originalPrice': 3500, 'desc': 'Fixing drum bearing, spider arm, or shaft noise and vibration issues.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_4', 'name': 'Motor Replacement', 'price': 4500, 'originalPrice': 6000, 'desc': 'Replacing faulty drive motor for front or top loader automatic machines.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_5', 'name': 'Water Inlet Valve Repair', 'price': 1200, 'originalPrice': 1800, 'desc': 'Fixing water fill issues, solenoid valve replacement for proper water flow.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_6', 'name': 'Drain Pump Repair', 'price': 1500, 'originalPrice': 2200, 'desc': 'Fixing drainage problems, pump motor or filter blockage replacement.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_7', 'name': 'PCB / Control Board Repair', 'price': 3000, 'originalPrice': 4500, 'desc': 'Electronic control board diagnosis, component-level repair or replacement.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_8', 'name': 'Door Lock & Seal Replacement', 'price': 1000, 'originalPrice': 1500, 'desc': 'Replacing damaged door gasket rubber seal or faulty lock mechanism.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_9', 'name': 'General Service & Deep Cleaning', 'price': 1500, 'originalPrice': 2000, 'desc': 'Full drum deep cleaning, descaling, filter clean, and maintenance check.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
        {'id': 'wm_10', 'name': 'Spin Cycle Problem Fix', 'price': 1800, 'originalPrice': 2500, 'desc': 'Fixing spin issues including clutch assembly, lid switch, or motor coupler.', 'imageUrl': 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=150&q=80'},
      ]
    },
  };

  List<Map<String, dynamic>> _items = [];
  bool _isLoadingPrices = false;
  bool _isMembershipActive = false;
  int _membershipDiscountPercent = 0;
  String _membershipPlanName = '';

  @override
  void initState() {
    super.initState();
    _initializeAndLoadPrices();
    _checkMembershipDiscount();
  }

  Future<void> _checkMembershipDiscount() async {
    try {
      final email = await UserAuthService.getCurrentUser();
      if (email != null && email.isNotEmpty) {
        final apps = await MembershipApplicationService.fetchApplications(email: email);
        MembershipApplicationModel? activeApp;
        for (var app in apps) {
          if (app.status.toLowerCase() == 'approved' && app.category.toLowerCase() == 'domestic') {
            activeApp = app;
            break;
          }
        }
        if (activeApp != null && mounted) {
          final clean = activeApp.discount.replaceAll('%', '').trim();
          setState(() {
            _isMembershipActive = true;
            _membershipDiscountPercent = int.tryParse(clean) ?? 0;
            _membershipPlanName = activeApp!.planName;
          });
        }
      }
    } catch (e) {
      debugPrint("Error checking membership: $e");
    }
  }

  @override
  void didUpdateWidget(covariant ServiceDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.serviceId != widget.serviceId) {
      _initializeAndLoadPrices();
    }
  }

  void _initializeAndLoadPrices() {
    final currentCat = _categoryData[widget.serviceId] ?? _categoryData['ac']!;
    final List<Map<String, dynamic>> rawItems = List<Map<String, dynamic>>.from(currentCat['items']);
    _items = rawItems.map((item) => Map<String, dynamic>.from(item)).toList();
    _loadCustomPrices();
  }

  Future<void> _loadCustomPrices() async {
    try {
      final customPrices = await ServicePriceService.fetchPrices();
      if (customPrices.isNotEmpty && mounted) {
        setState(() {
          // 1. Apply overrides to existing default items
          for (var custom in customPrices) {
            final index = _items.indexWhere((item) => item['id'] == custom.id);
            if (index != -1) {
              _items[index]['price'] = custom.price;
              _items[index]['originalPrice'] = custom.originalPrice;
              if (custom.name != null && custom.name!.trim().isNotEmpty) {
                _items[index]['name'] = custom.name;
              }
              if (custom.desc != null && custom.desc!.trim().isNotEmpty) {
                _items[index]['desc'] = custom.desc;
              }
              _items[index]['onSale'] = custom.onSale;
              _items[index]['salePercent'] = custom.salePercent;
            }
          }

          // 2. Append new dynamic custom items belonging to this category
          for (var custom in customPrices) {
            if (custom.categoryId == widget.serviceId) {
              final exists = _items.any((item) => item['id'] == custom.id);
              if (!exists) {
                _items.add({
                  'id': custom.id,
                  'name': custom.name ?? 'Custom Service',
                  'desc': custom.desc ?? 'Dynamic custom service package.',
                  'price': custom.price,
                  'originalPrice': custom.originalPrice,
                  'onSale': custom.onSale,
                  'salePercent': custom.salePercent,
                });
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading custom prices: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fallback if category ID is not mapped
    final currentCat = _categoryData[widget.serviceId] ?? _categoryData['ac']!;
    final String categoryName = currentCat['name'];
    final String categoryDesc = currentCat['description'];
    final List<Map<String, dynamic>> items = _items;

    final cart = CartService();

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
              colors: [Color(0xFF0066FF), Color(0xFF00A3FF)], // Matching home services blue gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => widget.onNavigate('services'),
        ),
      ),
      body: Stack(
        children: [
          // List of Sub-Services
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 180), // Extra bottom padding for floating cart bar
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Return descriptive header banner
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
                      const SizedBox(height: 12),
                      const Text(
                        '100% Satisfied Service Guarantee',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categoryDesc,
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12, height: 1.4),
                      ),
                    ],
                  ),
                );
              }

              final subService = items[index - 1];
              final String itemId = subService['id']!;
              final String itemName = subService['name']!;
              final int itemPrice = subService['price'] as int;
              final int originalPrice = subService['originalPrice'] as int;
              final String itemDesc = subService['desc']!;
              final bool onSale = subService['onSale'] as bool? ?? false;
              final int salePercent = subService['salePercent'] as int? ?? 0;
              final int effectivePrice = _isMembershipActive
                  ? (itemPrice - (itemPrice * _membershipDiscountPercent / 100).round())
                  : itemPrice;

              return ValueListenableBuilder<List<CartItem>>(
                valueListenable: cart.cartNotifier,
                builder: (context, cartItems, child) {
                  final int quantity = cart.getItemQuantity(itemId, itemName);
                  final bool isInCart = quantity > 0;

                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: onSale
                            ? (isInCart ? Colors.red.shade600 : Colors.red.shade200)
                            : (isInCart ? AppColors.primary : Colors.grey.shade200),
                        width: (isInCart || onSale) ? 1.5 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left icon container
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              _getSubServiceIcon(itemId),
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Middle text descriptions
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        itemName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ),
                                    if (onSale) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.red.shade300, width: 0.8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.local_offer_rounded, color: Colors.red.shade700, size: 10),
                                            const SizedBox(width: 3),
                                            Text(
                                              salePercent > 0 ? '$salePercent% OFF' : 'SALE',
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '4.8 (145 reviews)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  itemDesc,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                 // Price displays: Original (slashed) and current active
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Row(
                                       children: [
                                         Text(
                                           'Rs. $effectivePrice',
                                           style: const TextStyle(
                                             fontSize: 15,
                                             fontWeight: FontWeight.w900,
                                             color: AppColors.primary,
                                           ),
                                         ),
                                         const SizedBox(width: 8),
                                         Text(
                                           'Rs. ${_isMembershipActive ? itemPrice : originalPrice}',
                                           style: TextStyle(
                                             fontSize: 12,
                                             color: Colors.grey.shade400,
                                             decoration: TextDecoration.lineThrough,
                                           ),
                                         ),
                                       ],
                                     ),
                                     if (_isMembershipActive) ...[
                                       const SizedBox(height: 2),
                                       Container(
                                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                         decoration: BoxDecoration(
                                           color: Colors.green.shade50,
                                           borderRadius: BorderRadius.circular(4),
                                         ),
                                         child: Text(
                                           '$_membershipPlanName Card Discount Applied (-$_membershipDiscountPercent%)',
                                           style: TextStyle(
                                             color: Colors.green.shade700,
                                             fontSize: 9,
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ],
                                 ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Right reactive selector button
                          Column(
                            children: [
                              !isInCart
                                  ? SizedBox(
                                      height: 32,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          cart.addToCart(itemId, categoryName, itemName, effectivePrice);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('$itemName added to cart!'),
                                              backgroundColor: AppColors.primary,
                                              duration: const Duration(seconds: 1),
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
                                          'ADD +',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => cart.removeFromCart(itemId, itemName),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(
                                                '-',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '$quantity',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                          ),
                                          GestureDetector(
                                            onTap: () => cart.addToCart(itemId, categoryName, itemName, effectivePrice),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(
                                                '+',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Floating Bottom Cart Bar Overlay
          ValueListenableBuilder<List<CartItem>>(
            valueListenable: cart.cartNotifier,
            builder: (context, cartItems, child) {
              if (cartItems.isEmpty) return const SizedBox.shrink();

              return Positioned(
                bottom: 64 + MediaQuery.of(context).padding.bottom + 16,
                left: 16,
                right: 16,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onNavigate('checkout'),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${cart.totalItems} ${cart.totalItems == 1 ? 'item' : 'items'} added',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    Text(
                                      'Estimated Total: Rs. ${cart.totalPrice}',
                                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  'View Checkout',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
