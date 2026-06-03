import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/user_auth_service.dart';
import '../models/membership_application_model.dart';
import '../services/membership_application_service.dart';

/// ZEETECH PREMIUM ENTERPRISE PROFILE & ACCOUNT SCREEN
/// Upgraded with modern high-contrast cards, dual-gradient avatar ring highlights,
/// credit-card aspect-ratio active memberships, glassmorphic fields, and micro-interactive quick action tabs.
class ZeetechAccountScreen extends StatefulWidget {
  final ValueChanged<String>? onNavigate; // To allow redirection to services/orders/contact tab
  final VoidCallback onLogout; // Notify main to reset and show login screen
  final bool isGuest; // Flag to indicate guest mode

  const ZeetechAccountScreen({
    super.key, 
    this.onNavigate, 
    required this.onLogout,
    this.isGuest = false,
  });

  @override
  State<ZeetechAccountScreen> createState() => _ZeetechAccountScreenState();
}

class _ZeetechAccountScreenState extends State<ZeetechAccountScreen> {
  String? _currentUserEmail;
  String? _currentUserFullName;
  String _selectedStatusTab = 'Active'; // 'Active', 'Completed', 'Cancelled' (Preserved exactly)

  MembershipApplicationModel? _domesticMembership;
  MembershipApplicationModel? _commercialMembership;
  bool _isLoadingMembershipData = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // ── PRESERVED BUSINESS LOGIC 100% ──
  Future<void> _loadUser() async {
    final email = await UserAuthService.getCurrentUser();
    final details = await UserAuthService.getCurrentUserDetails();
    setState(() {
      _currentUserEmail = email;
      _currentUserFullName = details?['fullName'] ?? email;
    });
    if (email != null) {
      _loadMembershipData(email);
    }
  }

  // ── PRESERVED MEMBERSHIP TIMELIMIT LOGIC ──
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
    
    // Add months safely
    int newMonth = start.month + months;
    int newYear = start.year;
    while (newMonth > 12) {
      newMonth -= 12;
      newYear += 1;
    }
    
    final expirationDate = DateTime(newYear, newMonth, start.day, start.hour, start.minute);
    return DateTime.now().isBefore(expirationDate);
  }

  // ── PRESERVED DATA FETCH PATTERNS 100% ──
  Future<void> _loadMembershipData(String email) async {
    if (!mounted) return;
    setState(() {
      _isLoadingMembershipData = true;
    });
    try {
      final list = await MembershipApplicationService.fetchApplications(email: email);
      if (mounted) {
        MembershipApplicationModel? domestic;
        MembershipApplicationModel? commercial;

        final domesticApps = list.where((app) => app.category.toLowerCase() == 'domestic').toList();
        final commercialApps = list.where((app) => app.category.toLowerCase() == 'commercial').toList();

        MembershipApplicationModel? selectBest(List<MembershipApplicationModel> apps) {
          if (apps.isEmpty) return null;
          
          // 1. Prioritize active approved memberships
          for (var app in apps) {
            if (app.status == 'Approved' && isMembershipActive(app)) {
              return app;
            }
          }
          
          // 2. Then prioritize pending memberships
          for (var app in apps) {
            if (app.status == 'Pending') {
              return app;
            }
          }
          
          // 3. Then prioritize expired memberships (Approved but not active)
          for (var app in apps) {
            if (app.status == 'Approved') {
              return app;
            }
          }
          
          // 4. Fallback to the latest application (e.g. Rejected)
          return apps.first;
        }

        domestic = selectBest(domesticApps);
        commercial = selectBest(commercialApps);

        setState(() {
          _domesticMembership = domestic;
          _commercialMembership = commercial;
        });
      }
    } catch (e) {
      debugPrint("Error loading user membership: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMembershipData = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    await UserAuthService.logoutUser();
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    // ── GUEST MODE MODERN PROMO CARD UPGRADE ──
    if (widget.isGuest) {
      return Container(
        color: const Color(0xFFF9FAFB),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing circular ring around branded profile icon
                Container(
                  width: 110,
                  height: 110,
                  margin: const EdgeInsets.only(bottom: 28),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.04),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.12),
                            width: 2,
                          ),
                        ),
                      ),
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x2B1E3A8A),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_circle_outlined,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: Colors.grey.shade100, width: 1.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Join ZEETECH Services',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in or sign up to manage your profile, book premium services, and view your booking history.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: widget.onLogout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign In / Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.5,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 16),
                              ],
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
        ),
      );
    }

    if (_currentUserEmail == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Container(
      color: const Color(0xFFF9FAFB),
      child: Column(
        children: [
          // ── UPGRADED HIGH-CONTRAST HEADER CARD ──
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
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Dual-ringed glowing avatar structure
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 25.5,
                            backgroundColor: AppColors.primary.withOpacity(0.06),
                            child: const Icon(
                              Icons.person_rounded, 
                              color: AppColors.primary, 
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Hello, $_currentUserFullName',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 19.5, 
                                      fontWeight: FontWeight.w900, 
                                      color: AppColors.textDark,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 9,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.stars_rounded, 
                                    color: AppColors.primary, 
                                    size: 11,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (_domesticMembership?.status == 'Approved' || _commercialMembership?.status == 'Approved')
                                        ? 'VIP MEMBER'
                                        : 'ZEETECH VALUED CUSTOMER',
                                    style: const TextStyle(
                                      fontSize: 8.5, 
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textDark,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFEE2E2)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                          tooltip: 'Logout',
                          onPressed: _handleLogout,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Main Profile Content Scroller
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── MEMBERSHIP CARDS ROW ──
                  const Text(
                    'My Memberships',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDigitalMembershipCard('Domestic', _domesticMembership),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDigitalMembershipCard('Commercial', _commercialMembership),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── PERSONAL DETAILS ──
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProfileField(
                    icon: Icons.person_outline_rounded,
                    label: 'Full Name',
                    value: _currentUserFullName ?? 'Valued Customer',
                  ),
                  const SizedBox(height: 12),
                  _buildProfileField(
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: _currentUserEmail ?? '',
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: UserAuthService.getCurrentUserDetails(),
                    builder: (context, snapshot) {
                      final phone = snapshot.data?['phone'] ?? '+92 300 1234567';
                      return _buildProfileField(
                        icon: Icons.phone_android_outlined,
                        label: 'Mobile Number',
                        value: phone,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileField(
                    icon: Icons.verified_user_outlined,
                    label: 'Membership Status',
                    value: (_domesticMembership == null && _commercialMembership == null)
                        ? 'ZEETECH Standard Account'
                        : (_domesticMembership?.status == 'Approved' || _commercialMembership?.status == 'Approved')
                            ? 'ZEETECH Active VIP Member'
                            : 'Pending Verification',
                  ),
                  const SizedBox(height: 28),

                  // ── QUICK ACTIONS ──
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'Track My Bookings',
                    subtitle: 'View, update, or check status of active orders',
                    onTap: () {
                      if (widget.onNavigate != null) {
                        widget.onNavigate!('orders');
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.support_agent_rounded,
                    title: 'Contact Support Team',
                    subtitle: 'Get help with standard or custom bookings',
                    onTap: () {
                      if (widget.onNavigate != null) {
                        widget.onNavigate!('contact');
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'App Version 2.4.0 (Production Build)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── PREMIUM PROFILE FIELD COMPONENT ──
  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.006),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── MICRO-INTERACTIVE ACTION CARD ──
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.006),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Icon(icon, color: AppColors.textDark, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade300,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ── PREMIUM VIP MEMBERSHIP CARD BUILDER ──
  Widget _buildDigitalMembershipCard(String category, MembershipApplicationModel? mem) {
    if (_isLoadingMembershipData) {
      return Container(
        height: 155,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.006),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
          ),
        ),
      );
    }

    if (mem == null) {
      // Case 1: No Membership -> Premium VIP promo card
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.008),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Text(
                        'No VIP Active Plan',
                        style: TextStyle(fontSize: 8.5, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Get flat VIP discounts up to 30% on all standard & custom maintenance services.',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.onNavigate != null) {
                    widget.onNavigate!('home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Join VIP Plan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (mem.status == 'Pending') {
      // Case 2: Pending Approval -> Beautiful Amber state card
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.hourglass_empty_rounded, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$category VIP',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Pending',
                    style: TextStyle(color: Colors.orange, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: Color(0xFFFDE68A)),
            Text(
              'Your registration for the ${mem.planName} plan is under review. Our team will verify and issue your Member ID shortly.',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.35, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'Applied: ${mem.createdAt.day}/${mem.createdAt.month}/${mem.createdAt.year}',
              style: const TextStyle(fontSize: 8.5, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    if (mem.status == 'Rejected') {
      // Case 3: Rejected application
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFEE2E2), width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$category Rejected',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.textDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Your application for ${mem.planName} membership has been rejected. Please contact support.',
              style: TextStyle(fontSize: 9.5, color: Colors.grey.shade500, height: 1.35, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    // Case 4: Approved -> PRESTIGE GLOWING DIGITAL CARD!
    final bool active = isMembershipActive(mem);
    final planColor = active ? _getPlanCardColor(mem.planName) : const Color(0xFF78909C);
    
    // Dynamic Expiry date calculation for User Card
    final DateTime? activationDate = mem.processedAt;
    String expiryText = 'N/A';
    if (activationDate != null) {
      int months = 3;
      if (mem.validity == '6 Months') {
        months = 6;
      } else if (mem.validity == '1 Year') {
        months = 12;
      }
      int newMonth = activationDate.month + months;
      int newYear = activationDate.year;
      while (newMonth > 12) {
        newMonth -= 12;
        newYear += 1;
      }
      final expiry = DateTime(newYear, newMonth, activationDate.day);
      expiryText = '${expiry.day}/${expiry.month}/${expiry.year % 100}';
    }
    
    final planGradient = active 
        ? _getPlanCardGradient(mem.planName) 
        : const LinearGradient(
            colors: [Color(0xFF90A4AE), Color(0xFFB0BEC5), Color(0xFFCFD8DC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: planGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: planColor.withOpacity(active ? 0.25 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Graphic accents (Subtle transparent circles for credit-card style finish)
          Positioned(
            right: -15,
            top: -15,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            right: 25,
            bottom: -20,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white.withOpacity(0.04),
            ),
          ),
          
          // Expired watermark badge overlay
          Positioned(
            right: 12,
            bottom: 12,
            child: Opacity(
              opacity: active ? 0.08 : 0.25,
              child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: active ? Colors.white : Colors.redAccent, width: 1.5),
                  ),
                  child: Text(
                    active ? 'VERIFIED' : 'EXPIRED',
                    style: TextStyle(
                      color: active ? Colors.white : Colors.redAccent,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Card contents
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: active ? Colors.white : Colors.blueGrey.shade800,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: active ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        mem.planName.toUpperCase(),
                        style: TextStyle(
                          color: active ? Colors.white : Colors.blueGrey.shade900,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Realistic credit-card EMV smart chip
                CustomPaint(
                  painter: _EmvChipPainter(),
                  size: const Size(26, 19),
                ),
                const SizedBox(height: 14),
                Text(
                  'MEMBER ID',
                  style: TextStyle(
                    color: active ? Colors.white60 : Colors.blueGrey.shade700,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  mem.membershipId ?? 'ZEE-PENDING',
                  style: TextStyle(
                    color: active ? Colors.white : Colors.blueGrey.shade900,
                    fontSize: 13,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'CARDHOLDER NAME',
                  style: TextStyle(
                    color: active ? Colors.white60 : Colors.blueGrey.shade700,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  mem.fullName,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.blueGrey.shade900,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXPIRY',
                          style: TextStyle(
                            color: active ? Colors.white60 : Colors.blueGrey.shade700,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          expiryText,
                          style: TextStyle(
                            color: active ? Colors.white : Colors.blueGrey.shade900,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'BENEFIT',
                          style: TextStyle(
                            color: active ? Colors.white60 : Colors.blueGrey.shade700,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${mem.discount} OFF',
                          style: TextStyle(
                            color: active ? Colors.white : Colors.blueGrey.shade900,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (!active) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.onNavigate != null) {
                          widget.onNavigate!('home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Renew Now',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── DYNAMIC COLOR MAPS FOR TIER CARDS ──
  Color _getPlanCardColor(String planName) {
    switch (planName) {
      case 'Silver':
        return const Color(0xFF757575);
      case 'Gold':
        return const Color(0xFFFF8F00);
      case 'Premium':
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  LinearGradient _getPlanCardGradient(String planName) {
    switch (planName) {
      case 'Silver':
        return const LinearGradient(
          colors: [Color(0xFF8E9EAB), Color(0xFFEEF2F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Gold':
        return const LinearGradient(
          colors: [Color(0xFFFFB74D), Color(0xFFFFA000), Color(0xFFFF6F00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Premium':
        return const LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF1E88E5), Color(0xFF00D2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
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

