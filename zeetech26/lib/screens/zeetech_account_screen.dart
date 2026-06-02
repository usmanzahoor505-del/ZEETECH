import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/user_auth_service.dart';
import '../models/membership_application_model.dart';
import '../services/membership_application_service.dart';

class ZeetechAccountScreen extends StatefulWidget {
  final ValueChanged<String>? onNavigate; // To allow redirection to services tab
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
  String _selectedStatusTab = 'Active'; // 'Active', 'Completed', 'Cancelled'

  MembershipApplicationModel? _domesticMembership;
  MembershipApplicationModel? _commercialMembership;
  bool _isLoadingMembershipData = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

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
    if (widget.isGuest) {
      return Container(
        color: Colors.grey.shade50,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey.shade100),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_circle_outlined,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Join ZEETECH Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
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
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: widget.onLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign In / Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
      color: Colors.grey.shade50,
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppGradients.header,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      child: const Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $_currentUserFullName',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'ZEETECH Valued Customer',
                            style: TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                      tooltip: 'Logout',
                      onPressed: _handleLogout,
                    )
                  ],
                ),
              ],
            ),
          ),

          // Personal Details Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── DYNAMIC MEMBERSHIP DIGITAL CARDS ──
                  const Text(
                    'My Memberships',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
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

                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
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
                            ? 'ZEETECH Active Member'
                            : 'Pending Verification',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
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
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'App Version 2.4.0 (Production Build)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
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
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.textDark, size: 22),
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
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalMembershipCard(String category, MembershipApplicationModel? mem) {
    if (_isLoadingMembershipData) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
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
      // Case 1: No Membership -> Dashed Border Placeholder to join
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Text(
                        'No Active Plan',
                        style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w500),
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
                color: Colors.grey.shade600,
                height: 1.3,
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
      // Case 2: Pending Approval -> Amber alert style card
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade50.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.shade200, width: 1),
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
                          '$category Membership',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textDark),
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
            const Divider(height: 16),
            Text(
              'Your registration for the ${mem.planName} plan is under review. Our team will verify and issue your Member ID shortly.',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade700, height: 1.3),
            ),
            const SizedBox(height: 8),
            Text(
              'Applied: ${mem.createdAt.day}/${mem.createdAt.month}/${mem.createdAt.year}',
              style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    if (mem.status == 'Rejected') {
      // Case 3: Rejected application
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$category Rejected',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Your application for ${mem.planName} membership has been rejected. Please contact support.',
              style: TextStyle(fontSize: 9, color: Colors.grey.shade600, height: 1.3),
            ),
          ],
        ),
      );
    }

    // Case 4: Approved -> GORGEOUS GLOWING COMPACT DIGITAL CARD!
    final bool active = isMembershipActive(mem);
    final planColor = active ? _getPlanCardColor(mem.planName) : const Color(0xFF78909C);
    
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
            color: planColor.withOpacity(active ? 0.25 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circles (scaled down)
          Positioned(
            right: -15,
            top: -15,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            right: 25,
            bottom: -20,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white.withOpacity(0.03),
            ),
          ),
          // Verified/Expired Watermark Stamp (smaller and moved)
          Positioned(
            right: 10,
            bottom: 10,
            child: Opacity(
              opacity: active ? 0.08 : 0.2,
              child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: active ? Colors.white : Colors.red, width: 1.5),
                  ),
                  child: Text(
                    active ? 'VERIFIED' : 'EXPIRED',
                    style: TextStyle(
                      color: active ? Colors.white : Colors.red,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Details layout
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Plan name badge
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
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: active ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        mem.planName.toUpperCase(),
                        style: TextStyle(
                          color: active ? Colors.white : Colors.blueGrey.shade900,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Monospace Member ID
                Text(
                  'MEMBER ID',
                  style: TextStyle(
                    color: active ? Colors.white60 : Colors.blueGrey.shade700,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  mem.membershipId ?? 'ZEE-PENDING',
                  style: TextStyle(
                    color: active ? Colors.white : Colors.blueGrey.shade900,
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                // Footer: Name & Benefit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NAME',
                            style: TextStyle(
                              color: active ? Colors.white60 : Colors.blueGrey.shade700,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            mem.fullName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: active ? Colors.white : Colors.blueGrey.shade900,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'BENEFIT',
                          style: TextStyle(
                            color: active ? Colors.white60 : Colors.blueGrey.shade700,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${mem.discount} OFF',
                          style: TextStyle(
                            color: active ? Colors.white : Colors.blueGrey.shade900,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Expired Renewal button inside compact card
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

