import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';
import '../services/user_auth_service.dart';
import '../services/booking_repository.dart';
import '../models/booking_model.dart';
import '../widgets/feedback_bottom_sheet.dart';

/// ZEETECH PREMIUM ENTERPRISE ORDERS SCREEN
/// Upgraded with modern SaaS aesthetics, smooth micro-interactions, pull-to-refresh,
/// order status progress timelines, and summary analytics cards.
class ZeetechOrdersScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;
  final bool isGuest;

  const ZeetechOrdersScreen({
    super.key,
    required this.onNavigate,
    this.isGuest = false,
  });

  @override
  State<ZeetechOrdersScreen> createState() => _ZeetechOrdersScreenState();
}

class _ZeetechOrdersScreenState extends State<ZeetechOrdersScreen> {
  // Existing state variables preserved 100%
  String? _currentUserEmail;
  String? _currentUserFullName;
  String _selectedStatusTab = 'Active'; // 'Active', 'Completed', 'Cancelled'

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Existing auth loading logic preserved exactly
  Future<void> _loadUser() async {
    final email = await UserAuthService.getCurrentUser();
    final details = await UserAuthService.getCurrentUserDetails();
    setState(() {
      _currentUserEmail = email;
      _currentUserFullName = details?['fullName'] ?? email;
    });
  }

  // Visual Palette: Premium harmonic status indicators
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFF59E0B); // Amber Yellow
      case 'In Progress':
        return const Color(0xFF0066FF); // Vibrant Electric Blue
      case 'Completed':
        return const Color(0xFF10B981); // Emerald Green
      case 'Cancelled':
        return const Color(0xFFEF4444); // Sunset Red
      default:
        return const Color(0xFF6B7280); // Neutral Slate Gray
    }
  }

  // Category Icon Resolver: Gives contextual icons based on service names
  IconData _getServiceIcon(String serviceName) {
    final lowerName = serviceName.toLowerCase();
    if (lowerName.contains('ac') || lowerName.contains('air')) {
      return Icons.ac_unit_rounded;
    } else if (lowerName.contains('fridge') || lowerName.contains('refrigerator')) {
      return Icons.kitchen_rounded;
    } else if (lowerName.contains('washing') || lowerName.contains('laundry')) {
      return Icons.local_laundry_service_rounded;
    } else if (lowerName.contains('solar')) {
      return Icons.solar_power_rounded;
    } else if (lowerName.contains('electric')) {
      return Icons.electrical_services_rounded;
    } else if (lowerName.contains('carpenter') || lowerName.contains('wood')) {
      return Icons.carpenter_rounded;
    }
    return Icons.settings_suggest_rounded;
  }

  String _getWorkerNameOnly(String fullNameAndPhone) {
    if (fullNameAndPhone.contains('(')) {
      return fullNameAndPhone.split('(')[0].trim();
    }
    return fullNameAndPhone;
  }

  String _getWorkerPhoneOnly(String fullNameAndPhone) {
    final regExp = RegExp(r'\((.*?)\)');
    final match = regExp.firstMatch(fullNameAndPhone);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!.trim();
    }
    return '';
  }

  String _formatDateTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final min = dt.minute.toString().padLeft(2, '0');
      return '${dt.day}/${dt.month}/${dt.year} $hour:$min $period';
    } catch (_) {
      return isoString.replaceAll('T', ' ').substring(0, 16);
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint("Error launching url: $e");
    }
  }

  // Existing cancel booking verification logic preserved 100%
  void _confirmCancelBooking(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Cancel Booking?',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel your ${booking.serviceName} booking? This action cannot be undone.',
          style: TextStyle(color: Colors.grey.shade600, height: 1.4, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No, Keep It',
              style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cancelling your booking...'),
                  duration: Duration(seconds: 1),
                ),
              );

              final success = await BookingRepository().updateStatus(booking.id, 'Cancelled');
              
              if (success) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking cancelled successfully!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to cancel booking. Please try again.'),
                      backgroundColor: Colors.amber,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Modern UI Component: Premium Segmented Navigation Tabs
  Widget _buildTabButton(String tabName, int count) {
    final isSelected = _selectedStatusTab == tabName;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedStatusTab = tabName;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textGray.withOpacity(0.8),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: -0.2,
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.primary,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Premium UI Component: Order Statistics Summary Cards
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.012),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Modern UI Component: Interactive Progress Tracker inside cards
  Widget _buildOrderTimeline(String status) {
    final int currentStep;
    if (status == 'Pending') {
      currentStep = 0;
    } else if (status == 'In Progress') {
      currentStep = 1;
    } else if (status == 'Completed') {
      currentStep = 2;
    } else {
      currentStep = -1; // Cancelled
    }

    if (currentStep == -1) {
      return Container(
        margin: const EdgeInsets.only(top: 14, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade50.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_rounded, color: Colors.red, size: 14),
            SizedBox(width: 6),
            Text(
              'Booking cancelled and inactive',
              style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    final steps = ['Requested', 'In Progress', 'Completed'];

    return Container(
      margin: const EdgeInsets.only(top: 14, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isDone = index <= currentStep;
          final isCurrent = index == currentStep;
          final stepColor = isDone
              ? (index == 2 ? const Color(0xFF10B981) : AppColors.primary)
              : Colors.grey.shade200;

          return Expanded(
            child: Row(
              children: [
                // Step Dot
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isDone ? stepColor : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone ? stepColor : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: stepColor.withOpacity(0.35),
                              blurRadius: 6,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 11)
                      : Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(width: 6),
                // Step Title
                Expanded(
                  child: Text(
                    steps[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: isCurrent ? FontWeight.w900 : FontWeight.bold,
                      color: isCurrent
                          ? AppColors.textDark
                          : (isDone ? AppColors.textGray : Colors.grey.shade400),
                    ),
                  ),
                ),
                // Connector line
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      color: index < currentStep ? AppColors.primary : Colors.grey.shade200,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── GUEST RESTRICTED STATE VIEW ──
    if (widget.isGuest) {
      return Container(
        color: const Color(0xFFF9FAFB),
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
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Access Restricted',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in or sign up to view and track your service bookings.',
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
                        onPressed: () => widget.onNavigate('account'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Go to Account',
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

    // ── MAIN REGISTERED CUSTOMER STATE VIEW ──
    return ValueListenableBuilder<List<BookingModel>>(
      valueListenable: BookingRepository().bookingsNotifier,
      builder: (context, bookings, child) {
        // 1. Filter by current user (name matches preserved 100%)
        final userBookings = bookings.where((b) {
          final nameMatch = b.customerName.trim().toLowerCase() == _currentUserEmail?.trim().toLowerCase() ||
                            b.customerName.trim().toLowerCase() == _currentUserFullName?.trim().toLowerCase();
          return nameMatch;
        }).toList();

        // 2. Filter by selected sub-tab status
        final filteredBookings = userBookings.where((b) {
          if (_selectedStatusTab == 'Active') {
            return b.status == 'Pending' || b.status == 'In Progress';
          } else if (_selectedStatusTab == 'Completed') {
            return b.status == 'Completed';
          } else if (_selectedStatusTab == 'Cancelled') {
            return b.status == 'Cancelled';
          }
          return false;
        }).toList();

        // Calculate counts for tabs
        final activeCount = userBookings.where((b) => b.status == 'Pending' || b.status == 'In Progress').length;
        final completedCount = userBookings.where((b) => b.status == 'Completed').length;
        final cancelledCount = userBookings.where((b) => b.status == 'Cancelled').length;

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            title: const Text(
              'My Bookings',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: -0.6,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(66),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade100,
                      width: 1.2,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9), // Light background for tabs card
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton('Active', activeCount),
                      _buildTabButton('Completed', completedCount),
                      _buildTabButton('Cancelled', cancelledCount),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Simulating Pull-to-Refresh network refresh action
              await Future.delayed(const Duration(milliseconds: 600));
              _loadUser();
            },
            color: AppColors.primary,
            child: Column(
              children: [
                // ── SUMMARY STATS SLIDER ──
                if (userBookings.isNotEmpty)
                  Container(
                    height: 104,
                    margin: const EdgeInsets.only(top: 16),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildStatCard(
                          icon: Icons.pending_actions_rounded,
                          title: 'Active Bookings',
                          value: activeCount.toString(),
                          color: const Color(0xFF0066FF),
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.check_circle_outline_rounded,
                          title: 'Completed Orders',
                          value: completedCount.toString(),
                          color: const Color(0xFF10B981),
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.cancel_outlined,
                          title: 'Cancelled Orders',
                          value: cancelledCount.toString(),
                          color: const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.star_outline_rounded,
                          title: 'Total Reviews',
                          value: userBookings.where((b) => b.rating != null && b.rating! > 0).length.toString(),
                          color: const Color(0xFFF59E0B),
                        ),
                      ],
                    ),
                  ),

                // ── ORDERS LIST AREA ──
                Expanded(
                  child: filteredBookings.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _selectedStatusTab == 'Active'
                                        ? Icons.pending_actions_rounded
                                        : _selectedStatusTab == 'Completed'
                                            ? Icons.task_alt_rounded
                                            : Icons.cancel_presentation_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  _selectedStatusTab == 'Active'
                                      ? 'No active bookings'
                                      : _selectedStatusTab == 'Completed'
                                          ? 'No completed bookings yet'
                                          : 'No cancelled bookings',
                                  style: const TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.w900, 
                                    color: AppColors.textDark,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Your ${_selectedStatusTab.toLowerCase()} bookings will appear here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                ),
                                if (_selectedStatusTab == 'Active') ...[
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    height: 44,
                                    child: ElevatedButton(
                                      onPressed: () => widget.onNavigate('home'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: const Text(
                                        'Book Services Now', 
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                  )
                                ],
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            64 + MediaQuery.of(context).padding.bottom + 16,
                          ),
                          itemCount: filteredBookings.length,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            final statusColor = _getStatusColor(booking.status);

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.grey.shade100, width: 1.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.012),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row 1: Category Icon, Name & Status pill
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.06),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Icon(
                                            _getServiceIcon(booking.serviceName),
                                            color: AppColors.primary,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                booking.serviceName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w900, 
                                                  fontSize: 16, 
                                                  color: AppColors.textDark,
                                                  letterSpacing: -0.4,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'ID: #${booking.id.substring(0, 8).toUpperCase()}',
                                                style: TextStyle(
                                                  fontSize: 11, 
                                                  color: Colors.grey.shade400, 
                                                  fontFamily: 'monospace',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: statusColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                booking.status,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 10.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),
                                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                    const SizedBox(height: 14),

                                    // Row 2: Diagnostic Picture indicator & Time Details
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade400),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Scheduled: ${booking.preferredDate} | ${booking.preferredTime}',
                                            style: TextStyle(
                                              fontSize: 12.5, 
                                              color: AppColors.textGray.withOpacity(0.9),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (booking.problemImagePath.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.04),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.image_outlined, size: 14, color: AppColors.primary),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Diagnostic picture uploaded',
                                              style: TextStyle(
                                                fontSize: 11, 
                                                color: AppColors.primary.withOpacity(0.85), 
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    // Row 3: Modern Progress Tracker timeline
                                    _buildOrderTimeline(booking.status),

                                    // Technician details & Call / WhatsApp communication panel
                                    if (booking.assignedWorker != null && booking.assignedWorker!.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8FAFC),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
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
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.engineering_rounded, color: AppColors.primary, size: 20),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Assigned Technician',
                                                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        _getWorkerNameOnly(booking.assignedWorker!),
                                                        style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Call/WhatsApp icons
                                                if (_getWorkerPhoneOnly(booking.assignedWorker!).isNotEmpty) ...[
                                                  IconButton(
                                                    icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 20),
                                                    tooltip: 'Call Technician',
                                                    onPressed: () {
                                                      final phone = _getWorkerPhoneOnly(booking.assignedWorker!);
                                                      _launchUrl('tel:$phone');
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.green, size: 20),
                                                    tooltip: 'WhatsApp Technician',
                                                    onPressed: () {
                                                      final phone = _getWorkerPhoneOnly(booking.assignedWorker!);
                                                      final name = _getWorkerNameOnly(booking.assignedWorker!);
                                                      final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
                                                      final templateText = 'Hello $name, I am ${booking.customerName}. I would like to coordinate regarding my ${booking.serviceName} service request.';
                                                      _launchUrl('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(templateText)}');
                                                    },
                                                  ),
                                                ],
                                              ],
                                            ),
                                            if (booking.startedAt != null && booking.startedAt!.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              const Divider(height: 1, color: Color(0xFFE2E8F0)),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  const Icon(Icons.play_circle_outline_rounded, size: 14, color: Colors.blue),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Work Started: ${_formatDateTime(booking.startedAt!)}',
                                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            if (booking.completedAt != null && booking.completedAt!.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.check_circle_outline_rounded, size: 14, color: Colors.green),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Completed: ${_formatDateTime(booking.completedAt!)}',
                                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            if (booking.workSummary != null && booking.workSummary!.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withOpacity(0.04),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.green.withOpacity(0.08)),
                                                ),
                                                child: Text(
                                                  'Remarks: ${booking.workSummary}',
                                                  style: const TextStyle(fontSize: 11, color: Colors.green, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],

                                    // Row 4: Pricing/Action row
                                    if (booking.status == 'Pending' || booking.status == 'In Progress' || booking.status == 'Completed') ...[
                                      const SizedBox(height: 14),
                                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                      const SizedBox(height: 12),
                                    ],

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Updated: ${booking.createdAt.toString().split(' ')[0]}',
                                          style: TextStyle(
                                            fontSize: 11, 
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (booking.status == 'Pending' || booking.status == 'In Progress')
                                          OutlinedButton.icon(
                                            onPressed: () => _confirmCancelBooking(context, booking),
                                            icon: const Icon(Icons.cancel_outlined, size: 14, color: Colors.red),
                                            label: const Text(
                                              'Cancel',
                                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11.5),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: Colors.red.shade100, width: 1.2),
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        if (booking.status == 'Completed') ...[
                                          if (booking.rating != null && booking.rating! > 0)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFEF3C7),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 15),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${booking.rating}.0 / 5.0',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      color: Color(0xFF92400E),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => FeedbackBottomSheet(
                                                    bookingId: booking.id,
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.rate_review_outlined, size: 14),
                                              label: const Text(
                                                'Rate Service',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.primary,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
