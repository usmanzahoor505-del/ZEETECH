import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/user_auth_service.dart';
import '../services/booking_repository.dart';
import '../models/booking_model.dart';
import '../widgets/feedback_bottom_sheet.dart';

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
  String? _currentUserEmail;
  String? _currentUserFullName;
  String _selectedStatusTab = 'Active'; // 'Active', 'Completed', 'Cancelled'

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
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.amber.shade700;
      case 'In Progress':
        return AppColors.secondary;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return AppColors.textGray;
    }
  }

  void _confirmCancelBooking(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text(
              'Cancel Booking?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel your ${booking.serviceName} booking? This action cannot be undone.',
          style: TextStyle(color: Colors.grey.shade600, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No, Keep It',
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Show loading overlay or snackbar
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

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
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tabName,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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

    return ValueListenableBuilder<List<BookingModel>>(
      valueListenable: BookingRepository().bookingsNotifier,
      builder: (context, bookings, child) {
        // 1. Filter by current user
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

        // Calculate counts for each tab
        final activeCount = userBookings.where((b) => b.status == 'Pending' || b.status == 'In Progress').length;
        final completedCount = userBookings.where((b) => b.status == 'Completed').length;
        final cancelledCount = userBookings.where((b) => b.status == 'Cancelled').length;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text(
              'My Bookings',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    _buildTabButton('Active', activeCount),
                    const SizedBox(width: 8),
                    _buildTabButton('Completed', completedCount),
                    const SizedBox(width: 8),
                    _buildTabButton('Cancelled', cancelledCount),
                  ],
                ),
              ),
            ),
          ),
          body: filteredBookings.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _selectedStatusTab == 'Active'
                              ? Icons.pending_actions
                              : _selectedStatusTab == 'Completed'
                                  ? Icons.task_alt
                                  : Icons.cancel_presentation_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedStatusTab == 'Active'
                              ? 'No active bookings'
                              : _selectedStatusTab == 'Completed'
                                  ? 'No completed bookings yet'
                                  : 'No cancelled bookings',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your ${_selectedStatusTab.toLowerCase()} bookings will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                        ),
                        if (_selectedStatusTab == 'Active') ...[
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => widget.onNavigate('home'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Book Services Now', style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    booking.serviceName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(booking.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    booking.status,
                                    style: TextStyle(
                                      color: _getStatusColor(booking.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Scheduled: ${booking.preferredDate} | ${booking.preferredTime}',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                            if (booking.problemImagePath.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.image_outlined, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Diagnostic picture uploaded',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ],
                            if (booking.status == 'Pending' || booking.status == 'In Progress') ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => _confirmCancelBooking(context, booking),
                                    icon: const Icon(Icons.cancel_outlined, size: 16, color: Colors.red),
                                    label: const Text(
                                      'Cancel Booking',
                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.red.shade200),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (booking.status == 'Completed') ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (booking.rating != null && booking.rating! > 0) ...[
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Rated: ${booking.rating}.0/5.0',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (booking.feedbackComment != null && booking.feedbackComment!.isNotEmpty)
                                      Expanded(
                                        child: Text(
                                          ' - "${booking.feedbackComment}"',
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ] else ...[
                                    const Spacer(),
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
                                      icon: const Icon(Icons.rate_review_outlined, size: 16),
                                      label: const Text(
                                        'Rate Service',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ID: #${booking.id.substring(0, 8).toUpperCase()}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontFamily: 'monospace'),
                                ),
                                Text(
                                  'Status updated: ${booking.createdAt.toString().split(' ')[0]}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
