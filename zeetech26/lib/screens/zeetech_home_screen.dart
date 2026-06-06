import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/user_auth_service.dart';
import '../widgets/zeetech_logo.dart';
import '../widgets/membership_form_screen.dart';
import '../models/membership_application_model.dart';
import '../services/membership_application_service.dart';

class ZeetechHomeScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;
  final int? refreshTrigger;

  const ZeetechHomeScreen({super.key, required this.onNavigate, this.refreshTrigger});

  @override
  State<ZeetechHomeScreen> createState() => _ZeetechHomeScreenState();
}

class _ZeetechHomeScreenState extends State<ZeetechHomeScreen> {
  String? _currentUserFullName;
  bool _hasActiveOrPendingDomestic = false;
  bool _hasActiveOrPendingCommercial = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void didUpdateWidget(covariant ZeetechHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshTrigger != oldWidget.refreshTrigger) {
      _loadMembershipStatus();
    }
  }

  bool isMembershipActive(MembershipApplicationModel application) {
    if (application.status != 'Approved' || application.processedAt == null) {
      return false;
    }
    
    final start = application.processedAt!;
    int months = 3;
    if (application.validity == '6 Months') {
      months = 6;
    } else if (application.validity == '1 Year') {
      months = 12;
    }
    
    int newMonth = start.month + months;
    int newYear = start.year;
    while (newMonth > 12) {
      newMonth -= 12;
      newYear += 1;
    }
    
    final expirationDate = DateTime(newYear, newMonth, start.day, start.hour, start.minute);
    return DateTime.now().isBefore(expirationDate);
  }

  Future<void> _loadMembershipStatus() async {
    try {
      final email = await UserAuthService.getCurrentUser();
      final details = await UserAuthService.getCurrentUserDetails();
      if (email != null) {
        final mobile = details?['phone'];
        final list = await MembershipApplicationService.fetchApplications(email: email, mobile: mobile);
        bool hasDomestic = false;
        bool hasCommercial = false;

        for (var app in list) {
          final isPending = app.status == 'Pending';
          final isActiveApproved = app.status == 'Approved' && isMembershipActive(app);
          
          if (app.category.toLowerCase() == 'domestic' && (isPending || isActiveApproved)) {
            hasDomestic = true;
          }
          if (app.category.toLowerCase() == 'commercial' && (isPending || isActiveApproved)) {
            hasCommercial = true;
          }
        }
        
        if (mounted) {
          setState(() {
            _hasActiveOrPendingDomestic = hasDomestic;
            _hasActiveOrPendingCommercial = hasCommercial;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading membership status on Home: $e");
    }
  }

  Future<void> _loadUser() async {
    try {
      final details = await UserAuthService.getCurrentUserDetails();
      if (details != null && mounted) {
        setState(() {
          _currentUserFullName = details['fullName'];
        });
      }
      _loadMembershipStatus();
    } catch (e) {
      debugPrint("Error loading user: $e");
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final String greetingName = _currentUserFullName ?? "Usman";

    // Premium SaaS Modern UI Design Palette
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very clean neutral gray bg for visual contrast
      body: Column(
        children: [
          // ── PREMIUM BRAND HEADER AREA ──
          Container(
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
            padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 14.0),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Brand Logo & Identity
                      Row(
                        children: [
                          const ZeetechLogo(
                            size: 42,
                            hasBorder: false,
                            hasShadow: false,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ZEETECH',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textDark,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Technical Services',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textGray.withOpacity(0.85),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // 24/7 Support Pill Button - Upgraded design
                      GestureDetector(
                        onTap: () => widget.onNavigate('contact'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.15),
                              width: 1.2,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.headset_mic_rounded,
                                color: AppColors.primary,
                                size: 15,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '24/7 Support',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── SCROLLABLE LIST CONTENT ──
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 28.0),
              children: [
                // Welcome Back Title Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $greetingName 👋',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Welcome back! What service do you need today?',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Premium Marketing Banner with soft shadow border
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/home_banner.jpg',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Section 1: ZEETECH FOR BUSINESS - Sleek corporate premium dark card
                GestureDetector(
                  onTap: () => widget.onNavigate('business'),
                  child: Container(
                    height: 145,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)], // Gorgeous modern slate gradient
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withOpacity(0.18),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.all(22.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.business_center_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'ZEETECH for Business',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Complete corporate maintenance solutions, office installations, smart CCTV grids & custom plans.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.75),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section 2: HOME SERVICES & PRODUCTS Side-by-side Upgraded Grid Row
                Row(
                  children: [
                    // Home Services Card with rich primary gradient styling
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onNavigate('services'),
                        child: Container(
                          height: 190,
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0066FF), Color(0xFF00A3FF)], // Pure rich blue gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0066FF).withOpacity(0.24),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.construction_rounded,
                                  color: Color(0xFF0066FF),
                                  size: 22,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Home Services',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'AC, Electrician, CCTV, Carpenters & more',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 11,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Products Card with premium dark corporate slate aesthetics matching Business card
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onNavigate('products'),
                        child: Container(
                          height: 190,
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F172A), Color(0xFF1E293B)], // Premium slate gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withOpacity(0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.storefront_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ZEETECH Store',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'CCTV Systems, Solar Panel Packs, AC Spares & Parts',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.8),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Section 3: ZEETECH MEMBERSHIP HEADER
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ZEETECH MEMBERSHIP',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select a dedicated plan to save 30% on services instantly',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textGray.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    // Premium Domestic Card Grid
                    _buildSimpleGridCard(
                      cardType: 'DOMESTIC',
                      memberTitle: 'Save 30% on Home Care',
                      memberId: 'ZEE-4820-DOM',
                      gradientColors: const [
                        Color(0xFF0052D4),
                        Color(0xFF4364F7),
                        Color(0xFF6FB1FC),
                      ],
                      onTap: () => _showMembershipPlans(context, 'Domestic'),
                    ),
                    const SizedBox(width: 14),
                    // Premium Commercial Card Grid
                    _buildSimpleGridCard(
                      cardType: 'COMMERCIAL',
                      memberTitle: 'Save 30% on Corporate',
                      memberId: 'ZEE-9021-COM',
                      gradientColors: const [
                        Color(0xFF141E30),
                        Color(0xFF243B55),
                      ],
                      onTap: () => _showMembershipPlans(context, 'Commercial'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── "WHY CHOOSE ZEETECH" BRAND TRUST AREA ──
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'WHY CHOOSE ZEETECH',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 60,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our core commitments to you',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Grid of Trust Cards
                Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildWhyChooseCard(
                              icon: Icons.handshake_rounded,
                              title: 'RELIABILITY',
                              subtitle: 'Dependable services you can count on, every single time.',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildWhyChooseCard(
                              icon: Icons.construction_rounded,
                              title: 'EXPERT QUALITY',
                              subtitle: 'Highly skilled professionals using state-of-the-art tools.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildWhyChooseCard(
                            icon: Icons.sentiment_satisfied_alt_rounded,
                            title: 'SATISFACTION GUARANTEED',
                            subtitle: 'Building lifelong customer trust through excellence & transparent bookings.',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleGridCard({
    required String cardType,
    required String memberTitle,
    required String memberId,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 155,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Brand name & Card Smart Chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ZEETECH',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  // Realistic credit-card EMV smart chip
                  CustomPaint(
                    painter: _EmvChipPainter(),
                    size: const Size(26, 19),
                  ),
                ],
              ),
              // Middle: Card Type & Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardType,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    memberTitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Bottom Row: Member ID & Redirect Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    memberId,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.65),
                      fontFamily: 'Courier',
                      letterSpacing: 0.8,
                ),
              ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Membership Plans Bottom Sheet ──────────────────────────────────
  void _showMembershipPlans(BuildContext context, String category) {
    final bool hasExisting = category.toLowerCase() == 'domestic'
        ? _hasActiveOrPendingDomestic
        : _hasActiveOrPendingCommercial;

    if (hasExisting) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You already have an active or pending $category Membership! Check your Profile tab.'),
          backgroundColor: Colors.amber.shade900,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final bool isDomestic = category == 'Domestic';
    final Color accentColor = isDomestic ? AppColors.primary : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Premium handle bar
              Container(
                margin: const EdgeInsets.only(top: 14),
                width: 36,
                height: 4.5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),
              // Title Header
              Text(
                '$category Membership',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose a plan that fits your servicing requirements',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              // Plan Cards
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildPlanCard(
                      sheetContext: context,
                      planName: 'Silver',
                      discount: '10%',
                      validity: '3 Months',
                      accentColor: const Color(0xFF6B7280),
                      bgGradient: [const Color(0xFFF9FAFB), const Color(0xFFF3F4F6)],
                      iconColor: const Color(0xFF4B5563),
                      features: [
                        'All ${isDomestic ? "home" : "commercial"} services covered',
                        'Priority booking and callout service',
                        '10% off flat on every single booking',
                      ],
                      category: category,
                    ),
                    const SizedBox(height: 16),
                    _buildPlanCard(
                      sheetContext: context,
                      planName: 'Gold',
                      discount: '20%',
                      validity: '6 Months',
                      accentColor: const Color(0xFFD97706),
                      bgGradient: [const Color(0xFFFFFBEB), const Color(0xFFFEF3C7)],
                      iconColor: const Color(0xFFB45309),
                      features: [
                        'All ${isDomestic ? "home" : "commercial"} services covered',
                        'Priority booking + completely free inspection visits',
                        '20% off flat on every single booking',
                      ],
                      category: category,
                    ),
                    const SizedBox(height: 16),
                    _buildPlanCard(
                      sheetContext: context,
                      planName: 'Premium',
                      discount: '30%',
                      validity: '1 Year',
                      accentColor: accentColor,
                      bgGradient: isDomestic
                          ? [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)]
                          : [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
                      iconColor: accentColor,
                      features: [
                        'All ${isDomestic ? "home" : "commercial"} services covered',
                        'VIP top-tier priority + free inspection + dedicated 24/7 account support manager',
                        '30% off flat on every single booking',
                      ],
                      category: category,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanCard({
    required BuildContext sheetContext,
    required String planName,
    required String discount,
    required String validity,
    required Color accentColor,
    required List<Color> bgGradient,
    required Color iconColor,
    required List<String> features,
    required String category,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(0.24), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: plan name + discount badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        planName == 'Silver'
                            ? Icons.workspace_premium_rounded
                            : planName == 'Gold'
                                ? Icons.stars_rounded
                                : Icons.diamond_rounded,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$planName Plan',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w900,
                            color: accentColor == const Color(0xFF6B7280)
                                ? AppColors.textDark
                                : accentColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          validity,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Discount badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$discount OFF',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1.2,
              color: accentColor.withOpacity(0.12),
            ),
            const SizedBox(height: 16),
            // Features list
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: accentColor,
                        size: 17,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            // Subscribe button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  final parentContext = this.context;
                  Navigator.pop(sheetContext);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (!mounted) return;
                    showModalBottomSheet(
                      context: parentContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => MembershipFormScreen(
                        category: category,
                        planName: planName,
                        discount: discount,
                        validity: validity,
                      ),
                    ).then((_) {
                      _loadMembershipStatus();
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Subscribe Now',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── PREMIUM EMV METALLIC CHIP PAINTER ──
class _EmvChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the metallic gold gradient background
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(5),
    );

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFE9A6), // Premium light gold
          Color(0xFFEBC55E), // Metallic medium gold
          Color(0xFFC79E3A), // Antique gold bronze
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rect, fillPaint);

    // 2. Draw the exact dark golden brown EMV split tracks matching vector
    final trackPaint = Paint()
      ..color = const Color(0xFF654A07).withOpacity(0.85)
      ..strokeWidth = 0.95
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw outer border outline
    canvas.drawRRect(rect, trackPaint);

    // Drawing the Left Path
    final leftPath = Path()
      ..moveTo(size.width * 0.42, 0)
      ..lineTo(size.width * 0.30, size.height * 0.20)
      ..lineTo(size.width * 0.30, size.height * 0.35)
      ..lineTo(size.width * 0.18, size.height * 0.50)
      ..lineTo(size.width * 0.30, size.height * 0.65)
      ..lineTo(size.width * 0.30, size.height * 0.80)
      ..lineTo(size.width * 0.42, size.height);
    canvas.drawPath(leftPath, trackPaint);

    // Left horizontal segment lines
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width * 0.30, size.height * 0.35), trackPaint);
    canvas.drawLine(Offset(0, size.height * 0.50), Offset(size.width * 0.18, size.height * 0.50), trackPaint);
    canvas.drawLine(Offset(0, size.height * 0.65), Offset(size.width * 0.30, size.height * 0.65), trackPaint);

    // Drawing the Center-Right Loop/Paths matching the exact vector
    final rightPath = Path()
      ..moveTo(size.width * 0.58, 0)
      ..lineTo(size.width * 0.58, size.height * 0.20)
      ..lineTo(size.width * 0.45, size.height * 0.35)
      ..lineTo(size.width * 0.45, size.height * 0.65)
      ..lineTo(size.width * 0.58, size.height * 0.80)
      ..lineTo(size.width * 0.58, size.height);
    canvas.drawPath(rightPath, trackPaint);

    // Top loop right line
    canvas.drawLine(Offset(size.width * 0.58, size.height * 0.20), Offset(size.width * 0.78, size.height * 0.20), trackPaint);
    canvas.drawLine(Offset(size.width * 0.78, size.height * 0.20), Offset(size.width * 0.78, size.height * 0.45), trackPaint);
    canvas.drawLine(Offset(size.width * 0.78, size.height * 0.45), Offset(size.width * 0.45, size.height * 0.45), trackPaint);

    // Bottom loop right line
    canvas.drawLine(Offset(size.width * 0.58, size.height * 0.80), Offset(size.width * 0.78, size.height * 0.80), trackPaint);
    canvas.drawLine(Offset(size.width * 0.78, size.height * 0.80), Offset(size.width * 0.78, size.height * 0.55), trackPaint);
    canvas.drawLine(Offset(size.width * 0.78, size.height * 0.55), Offset(size.width * 0.45, size.height * 0.55), trackPaint);

    // Right-most horizontal splitters
    canvas.drawLine(Offset(size.width * 0.78, size.height * 0.30), Offset(size.width, size.height * 0.30), trackPaint);
    canvas.drawLine(Offset(size.width * 0.78, size.height * 0.70), Offset(size.width, size.height * 0.70), trackPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


