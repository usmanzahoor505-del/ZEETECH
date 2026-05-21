import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ZeetechAboutScreen extends StatefulWidget {
  const ZeetechAboutScreen({super.key});

  @override
  State<ZeetechAboutScreen> createState() => _ZeetechAboutScreenState();
}

class _ZeetechAboutScreenState extends State<ZeetechAboutScreen> {
  static const List<Map<String, String>> _stats = [
    {'value': '2500+', 'label': 'Happy Clients', 'icon': '👥'},
    {'value': '98%', 'label': 'Satisfaction Rate', 'icon': '⭐'},
    {'value': '24/7', 'label': 'Support Available', 'icon': '🕐'},
    {'value': '50+', 'label': 'Expert Technicians', 'icon': '👨‍🔧'},
  ];

  static const List<Map<String, String>> _timeline = [
    {'year': '2015', 'event': 'Founded in Islamabad', 'desc': 'Started with a small team'},
    {'year': '2018', 'event': 'Expanded Services', 'desc': 'Added solar & HVAC'},
    {'year': '2021', 'event': '1000+ Clients', 'desc': 'Milestone achievement'},
    {'year': '2024', 'event': 'Leading Service Provider', 'desc': 'Recognized across Pakistan'},
  ];

  static const List<Map<String, dynamic>> _values = [
    {'icon': Icons.shield_outlined, 'title': 'Reliability', 'desc': 'Always on time, every time'},
    {'icon': Icons.emoji_events_outlined, 'title': 'Quality', 'desc': 'Premium parts & workmanship'},
    {'icon': Icons.favorite_border, 'title': 'Customer Satisfaction', 'desc': 'Your happiness is our goal'},
    {'icon': Icons.business_center_outlined, 'title': 'Professionalism', 'desc': 'Trained & certified experts'},
    {'icon': Icons.lightbulb_outline, 'title': 'Innovation', 'desc': 'Latest tools & techniques'},
    {'icon': Icons.check_circle_outline, 'title': 'Integrity', 'desc': 'Honest & transparent pricing'},
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
                'About ZEETECH',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Powering comfort, repairing trust since 2015',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // Scrollable Body
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Company Intro Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "ZEETECH Technical Services is Islamabad's premier home and commercial repair company. With over 8 years of experience, we provide professional AC, refrigerator, solar, electrical, and carpentry services. Our certified technicians ensure quality workmanship and customer satisfaction in every job.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGray,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Stats Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.25,
                ),
                itemCount: _stats.length,
                itemBuilder: (context, index) {
                  final stat = _stats[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
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
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat['value']!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stat['label']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xE6FFFFFF),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Our Journey Timeline
              const Text(
                'Our Journey',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              _buildTimeline(),

              const SizedBox(height: 32),

              // Core Values
              const Text(
                'Our Core Values',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemCount: _values.length,
                itemBuilder: (context, index) {
                  final value = _values[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: AppGradients.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            value['icon'],
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          value['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value['desc'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
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

              // Mission & Vision
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Mission',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'To provide reliable, professional, and affordable technical services that enhance the comfort and safety of homes and businesses across Islamabad.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xE6FFFFFF),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppGradients.header,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBg.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Vision',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "To be Pakistan's most trusted technical services company, recognized for excellence, innovation, and unwavering commitment to customer satisfaction.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xE6FFFFFF),
                        height: 1.4,
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
    );
  }

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
            // Timeline line & year circle
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: AppGradients.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item['year']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (index < _timeline.length - 1)
                  Container(
                    width: 2,
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Content Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['event']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['desc']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
