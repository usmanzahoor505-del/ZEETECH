import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// ZEETECH PREMIUM ENTERPRISE ABOUT SCREEN
/// Upgraded with modern high-contrast cards, visual depth timelines,
/// glassmorphic grid displays, and gradient mission panels.
class ZeetechAboutScreen extends StatefulWidget {
  const ZeetechAboutScreen({super.key});

  @override
  State<ZeetechAboutScreen> createState() => _ZeetechAboutScreenState();
}

class _ZeetechAboutScreenState extends State<ZeetechAboutScreen> {
  // ── Existing Stats Definition preserved 100% ──
  static const List<Map<String, String>> _stats = [
    {'value': '2500+', 'label': 'Happy Clients', 'icon': '👥'},
    {'value': '98%', 'label': 'Satisfaction Rate', 'icon': '⭐'},
    {'value': '24/7', 'label': 'Support Available', 'icon': '🕐'},
    {'value': '50+', 'label': 'Expert Technicians', 'icon': '👨‍🔧'},
  ];

  // ── Existing Timeline preserved 100% ──
  static const List<Map<String, String>> _timeline = [
    {'year': '2015', 'event': 'Founded in Islamabad', 'desc': 'Started with a small team'},
    {'year': '2018', 'event': 'Expanded Services', 'desc': 'Added solar & HVAC'},
    {'year': '2021', 'event': '1000+ Clients', 'desc': 'Milestone achievement'},
    {'year': '2024', 'event': 'Leading Service Provider', 'desc': 'Recognized across Pakistan'},
  ];

  // ── Existing Core Values preserved 100% ──
  static const List<Map<String, dynamic>> _values = [
    {'icon': Icons.shield_outlined, 'title': 'Reliability', 'color': Color(0xFF0066FF), 'desc': 'Always on time, every time'},
    {'icon': Icons.emoji_events_outlined, 'title': 'Quality', 'color': Color(0xFFF59E0B), 'desc': 'Premium parts & workmanship'},
    {'icon': Icons.favorite_border, 'title': 'Customer Satisfaction', 'color': Color(0xFFEF4444), 'desc': 'Your happiness is our goal'},
    {'icon': Icons.business_center_outlined, 'title': 'Professionalism', 'color': Color(0xFF10B981), 'desc': 'Trained & certified experts'},
    {'icon': Icons.lightbulb_outline, 'title': 'Innovation', 'color': Color(0xFF8B5CF6), 'desc': 'Latest tools & techniques'},
    {'icon': Icons.check_circle_outline, 'title': 'Integrity', 'color': Color(0xFFEC4899), 'desc': 'Honest & transparent pricing'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: Column(
        children: [
          // ── PREMIUM BRAND HEADER AREA ──
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade100,
                  width: 1.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.012),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: const SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About ZEETECH',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.6,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Powering comfort, repairing trust since 2015',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── SCROLLABLE BRAND EXPLORATION CONTENT ──
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                // 1. Sleek Modern Company Intro Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade100, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.015),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.corporate_fare_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Who We Are',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "ZEETECH Technical Services is Islamabad's premier home and commercial repair company. With over 8 years of experience, we provide professional AC, refrigerator, solar, electrical, and carpentry services. Our certified technicians ensure quality workmanship and customer satisfaction in every job.",
                        style: TextStyle(
                          fontSize: 13.5,
                          color: AppColors.textGray,
                          fontWeight: FontWeight.w500,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. High-contrast Interactive Stats Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.20,
                  ),
                  itemCount: _stats.length,
                  itemBuilder: (context, index) {
                    final stat = _stats[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0066FF), Color(0xFF00A3FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0066FF).withOpacity(0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            stat['icon']!,
                            style: const TextStyle(fontSize: 26),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            stat['value']!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            stat['label']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // 3. Premium Interactive Journey Timeline
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_graph_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Our Historical Journey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTimeline(),

                const SizedBox(height: 24),

                // 4. Core Values Grid Layout
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Our Pillars of Value',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _values.length,
                  itemBuilder: (context, index) {
                    final value = _values[index];
                    final itemColor = value['color'] as Color;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade100, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.015),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: itemColor.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              value['icon'],
                              color: itemColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            value['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            value['desc'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // 5. Dual Mission & Vision Creative Gradient Blocks
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.rocket_launch_rounded, color: Color(0xFF00A3FF), size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Our Mission',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'To provide reliable, professional, and affordable technical services that enhance the comfort and safety of homes and businesses across Islamabad.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0066FF), Color(0xFF00A3FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0066FF).withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Our Vision',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "To be Pakistan's most trusted technical services company, recognized for excellence, innovation, and unwavering commitment to customer satisfaction.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Premium UI Component: Journey Timeline builder
  Widget _buildTimeline() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _timeline.length,
      itemBuilder: (context, index) {
        final item = _timeline[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Node circle with dynamic timeline vertical connectors
            Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0066FF), Color(0xFF00A3FF)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0066FF).withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item['year']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (index < _timeline.length - 1)
                  Container(
                    width: 2.5,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0066FF),
                          const Color(0xFF0066FF).withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Timeline Content card
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey.shade100, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['event']!,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['desc']!,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
