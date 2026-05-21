import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/user_auth_service.dart';
import '../services/booking_repository.dart';
import '../models/booking_model.dart';

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

  Future<void> _handleLogout() async {
    await UserAuthService.logoutUser();
    widget.onLogout();
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

  Widget _buildTabButton(String tabName) {
    final isSelected = _selectedStatusTab == tabName;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedStatusTab = tabName;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            tabName,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
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

          // Booking History Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Booking History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),

                  // Sub-tabs Row
                  Row(
                    children: [
                      _buildTabButton('Active'),
                      const SizedBox(width: 8),
                      _buildTabButton('Completed'),
                      const SizedBox(width: 8),
                      _buildTabButton('Cancelled'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ValueListenableBuilder<List<BookingModel>>(
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

                        if (filteredBookings.isEmpty) {
                          IconData placeholderIcon = Icons.calendar_today_outlined;
                          String placeholderText = 'No bookings found';
                          if (_selectedStatusTab == 'Active') {
                            placeholderIcon = Icons.pending_actions;
                            placeholderText = 'No active bookings';
                          } else if (_selectedStatusTab == 'Completed') {
                            placeholderIcon = Icons.task_alt;
                            placeholderText = 'No completed bookings yet';
                          } else if (_selectedStatusTab == 'Cancelled') {
                            placeholderIcon = Icons.cancel_presentation_outlined;
                            placeholderText = 'No cancelled bookings';
                          }

                          return Center(
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey.shade100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(placeholderIcon, size: 48, color: Colors.grey.shade300),
                                    const SizedBox(height: 16),
                                    Text(
                                      placeholderText,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Your ${_selectedStatusTab.toLowerCase()} bookings will appear here.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                    ),
                                    if (_selectedStatusTab == 'Active') ...[
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (widget.onNavigate != null) {
                                            widget.onNavigate!('services');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: const Text('Book Services'),
                                      )
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredBookings.length,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.grey.shade100),
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
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
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
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
                                    const Divider(height: 20),
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
