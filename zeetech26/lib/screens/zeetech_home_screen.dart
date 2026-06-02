import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/user_auth_service.dart';
import '../widgets/zeetech_logo.dart';
import '../widgets/membership_form_screen.dart';
import '../models/membership_application_model.dart';
import '../services/membership_application_service.dart';

class ZeetechHomeScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;

  const ZeetechHomeScreen({super.key, required this.onNavigate});

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
      if (email != null) {
        final list = await MembershipApplicationService.fetchApplications(email: email);
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
  Widget build(BuildContext context) {
    final String greetingName = _currentUserFullName ?? "Usman";

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
          children: [
            // 1. Top Header Area (Location, Greeting, Icons)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                            size: 40,
                            hasBorder: false,
                            hasShadow: false,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ZEETECH',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Technical Services',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textGray.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // 24/7 Support Pill Button
                      GestureDetector(
                        onTap: () => widget.onNavigate('contact'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F5FA),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFD0E0F0),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.headset_mic_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '24/7 Support',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
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

            // 2. Main Content Area (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                children: [
                  // Bold Greeting - moved inside ListView so it scrolls up and hides when scrolling
                  Text(
                    'Hello, $greetingName',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Premium Marketing Banner replacing Coins & Wallet Badges
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/home_banner.jpg',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 1. ZEETECH FOR BUSINESS (Directly below banner)
                  GestureDetector(
                    onTap: () => widget.onNavigate('business'),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.darkBg, Color(0xFF0F3A60)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkBg.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.business_center_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'ZEETECH for Business',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Complete corporate maintenance solution, office installations, security systems & CCTV grids.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.7),
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
                  const SizedBox(height: 16),

                  // 2. HOME SERVICES & PRODUCTS Row
                  Row(
                    children: [
                      // Home Services Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onNavigate('services'),
                          child: Container(
                            height: 180,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: AppGradients.primary,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
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
                                    Icons.build_rounded,
                                    color: AppColors.primary,
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'AC, CCTV & more',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Products Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onNavigate('products'),
                          child: Container(
                            height: 180,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.storefront_rounded,
                                    color: Colors.teal.shade700,
                                    size: 22,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Products',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark.withOpacity(0.9),
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'CCTV, Solar, AC parts & more',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                        height: 1.2,
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
                  const SizedBox(height: 24),

                  // 3. ZEETECH MEMBERSHIP SECTION (Simple Grid Card Styled)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ZEETECH MEMBERSHIP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Select a plan to start saving on technical services',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      // Domestic Simple Card
                      _buildSimpleGridCard(
                        cardType: 'DOMESTIC',
                        memberTitle: 'Save 30% on Home Care',
                        memberId: 'ZEE-4820-DOM',
                        gradientColors: const [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                        onTap: () => _showMembershipPlans(context, 'Domestic'),
                      ),
                      const SizedBox(width: 12),
                      // Commercial Simple Card
                      _buildSimpleGridCard(
                        cardType: 'COMMERCIAL',
                        memberTitle: 'Save 30% on Corporate',
                        memberId: 'ZEE-9021-COM',
                        gradientColors: const [
                          AppColors.darkBg,
                          Color(0xFF0F3A60),
                        ],
                        onTap: () => _showMembershipPlans(context, 'Commercial'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // "WHY CHOOSE ZEETECH" Section Header
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'WHY CHOOSE ZEETECH',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 80,
                          height: 3,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Our commitment to excellence',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Grid/Row of why choose cards - static layout (2 in grid, 1 below)
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
                                subtitle: 'Services customers can trust, every time.',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildWhyChooseCard(
                                icon: Icons.construction_rounded,
                                title: 'QUALITY WORKMANSHIP',
                                subtitle: 'Skilled technicians with attention to detail.',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildWhyChooseCard(
                              icon: Icons.sentiment_satisfied_alt_rounded,
                              title: 'CUSTOMER SATISFACTION',
                              subtitle: 'Long-term relationships & dependable service.',
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1),
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
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              height: 1.3,
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
          height: 150,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Brand name & arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ZEETECH',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    memberTitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              // Bottom: Member ID
              Text(
                memberId,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'Courier',
                  letterSpacing: 0.8,
                ),
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
    final Color accentColor = isDomestic ? AppColors.primary : const Color(0xFF0F3A60);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                '$category Membership',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose a plan that suits your needs',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 20),
              // Plan Cards
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildPlanCard(
                      sheetContext: context,
                      planName: 'Silver',
                      discount: '10%',
                      validity: '3 Months',
                      accentColor: const Color(0xFF9E9E9E),
                      bgGradient: [const Color(0xFFF5F5F5), const Color(0xFFE0E0E0)],
                      iconColor: const Color(0xFF757575),
                      features: [
                        'All ${isDomestic ? "home" : "commercial"} services covered',
                        'Priority booking',
                        '10% off on every service',
                      ],
                      category: category,
                    ),
                    const SizedBox(height: 14),
                    _buildPlanCard(
                      sheetContext: context,
                      planName: 'Gold',
                      discount: '20%',
                      validity: '6 Months',
                      accentColor: const Color(0xFFFF8F00),
                      bgGradient: [const Color(0xFFFFF8E1), const Color(0xFFFFE082)],
                      iconColor: const Color(0xFFF57F17),
                      features: [
                        'All ${isDomestic ? "home" : "commercial"} services covered',
                        'Priority booking + free inspection',
                        '20% off on every service',
                      ],
                      category: category,
                    ),
                    const SizedBox(height: 14),
                    _buildPlanCard(
                      sheetContext: context,
                      planName: 'Premium',
                      discount: '30%',
                      validity: '1 Year',
                      accentColor: accentColor,
                      bgGradient: isDomestic
                          ? [const Color(0xFFE3F2FD), const Color(0xFF90CAF9)]
                          : [const Color(0xFFE8EAF6), const Color(0xFF9FA8DA)],
                      iconColor: accentColor,
                      features: [
                        'All ${isDomestic ? "home" : "commercial"} services covered',
                        'VIP priority + free inspection + dedicated support',
                        '30% off on every service',
                      ],
                      category: category,
                    ),
                    const SizedBox(height: 24),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$planName Plan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: accentColor == const Color(0xFF9E9E9E)
                                ? AppColors.textDark
                                : accentColor,
                          ),
                        ),
                        Text(
                          validity,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
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
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Divider
            Container(
              height: 1,
              color: accentColor.withOpacity(0.15),
            ),
            const SizedBox(height: 14),
            // Features list
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            // Subscribe button
            SizedBox(
              width: double.infinity,
              height: 42,
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
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Subscribe Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
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

