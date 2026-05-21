import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ZeetechHomeScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;

  const ZeetechHomeScreen({super.key, required this.onNavigate});

  @override
  State<ZeetechHomeScreen> createState() => _ZeetechHomeScreenState();
}

class _ZeetechHomeScreenState extends State<ZeetechHomeScreen> {
  // Countdown Timer state
  late Timer _countdownTimer;
  Duration _timeLeft = const Duration(days: 2, hours: 15, minutes: 30, seconds: 45);

  // Carousel state
  final PageController _pageController = PageController();
  late Timer _carouselTimer;
  int _currentSlide = 0;

  final List<Map<String, dynamic>> _carouselImages = [
    {'title': 'AC Services', 'gradient': AppGradients.ac},
    {'title': 'Refrigerator Repair', 'gradient': AppGradients.refrigerator},
    {'title': 'Solar Energy', 'gradient': AppGradients.solar},
    {'title': 'Electrical Work', 'gradient': AppGradients.electrician},
    {'title': 'Carpentry', 'gradient': AppGradients.carpenter},
  ];

  final List<Map<String, String>> _stats = [
    {'value': '2500+', 'label': 'Clients'},
    {'value': '98%', 'label': 'Satisfaction'},
    {'value': '24/7', 'label': 'Support'},
    {'value': '50+', 'label': 'Technicians'},
  ];

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.shield_outlined,
      'title': 'Reliability',
      'description': 'Professional service you can trust',
      'gradient': AppGradients.primary,
    },
    {
      'icon': Icons.emoji_events_outlined,
      'title': 'Quality Workmanship',
      'description': 'Expert technicians, quality parts',
      'gradient': AppGradients.primary,
    },
    {
      'icon': Icons.favorite_border,
      'title': 'Customer Satisfaction',
      'description': 'Your comfort is our priority',
      'gradient': const LinearGradient(
        colors: [Color(0xFF22C55E), AppColors.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  @override
  void initState() {
    super.initState();

    // Start countdown timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      }
    });

    // Start auto-sliding carousel
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextSlide = (_currentSlide + 1) % _carouselImages.length;
        _pageController.animateToPage(
          nextSlide,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _carouselTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _formatTimeValue(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    // Format countdown units
    int days = _timeLeft.inDays;
    int hours = _timeLeft.inHours % 24;
    int minutes = _timeLeft.inMinutes % 60;
    int seconds = _timeLeft.inSeconds % 60;

    return Column(
      children: [
        // Sticky Offer Banner
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    '🔥 30% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '· Limited Offer',
                    style: TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildTimerUnit(_formatTimeValue(days) + 'd'),
                  const SizedBox(width: 4),
                  _buildTimerUnit(_formatTimeValue(hours) + 'h'),
                  const SizedBox(width: 4),
                  _buildTimerUnit(_formatTimeValue(minutes) + 'm'),
                  const SizedBox(width: 4),
                  _buildTimerUnit(_formatTimeValue(seconds) + 's'),
                ],
              ),
            ],
          ),
        ),

        // Rest of content scrollable
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Auto-sliding Carousel
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentSlide = index;
                        });
                      },
                      itemCount: _carouselImages.length,
                      itemBuilder: (context, index) {
                        final slide = _carouselImages[index];
                        return Container(
                          decoration: BoxDecoration(
                            gradient: slide['gradient'],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            slide['title'],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    // Indicator dots
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_carouselImages.length, (index) {
                          final isSelected = _currentSlide == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: isSelected ? 24 : 8,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Hero Title & Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const Text(
                      'ZEETECH Technical Services',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Professional home & commercial repair services in Islamabad',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => widget.onNavigate('services'),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: AppGradients.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Explore Services',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => widget.onNavigate('contact'),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.darkBg,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.darkBg.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Contact Us',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Stats Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _stats.map((stat) {
                    return Column(
                      children: [
                        Text(
                          stat['value']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat['label']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Features
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: _features.map((feature) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: feature['gradient'],
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              feature['icon'],
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feature['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  feature['description'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerUnit(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
