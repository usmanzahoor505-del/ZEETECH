import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';
import '../models/booking_model.dart';
import '../services/booking_repository.dart';
import '../services/api_config.dart';
import '../services/admin_auth_service.dart';
import '../models/corporate_inquiry_model.dart';
import '../services/corporate_inquiry_service.dart';
import '../models/membership_application_model.dart';
import '../services/membership_application_service.dart';
import '../models/service_price_model.dart';
import '../services/service_price_service.dart';
import '../models/product_price_model.dart';
import '../services/product_price_service.dart';
import '../services/user_auth_service.dart';
import 'product_detail_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const AdminDashboardScreen({super.key, this.onLogout});

  @override
  State<AdminDashboardScreen> createState() => _AppAdminDashboardScreenState();
}

class _AppAdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedFilter = 'All'; // 'All', 'Pending', 'In Progress', 'Completed'
  String _currentView = 'home'; // 'home', 'bookings', 'feedback', 'inquiries', 'memberships'

  int _inquiryCount = 0;
  List<CorporateInquiryModel> _inquiries = [];
  bool _isLoadingInquiries = false;

  int _membershipCount = 0;
  List<MembershipApplicationModel> _memberships = [];
  bool _isLoadingMemberships = false;
  String _selectedMembershipFilter = 'All'; // 'All', 'Pending', 'Approved', 'Rejected'
  String _selectedCategoryTab = 'Domestic'; // 'Domestic', 'Commercial'
  String _selectedCategoryTabPrice = 'ac';
  List<ServicePriceModel> _dbServicePrices = [];
  bool _isLoadingDbPrices = false;

  List<ProductPriceModel> _dbProductPrices = [];
  bool _isLoadingDbProductPrices = false;
  String _selectedCategoryTabProductPrice = 'ac_products';

  // Active technicians state
  List<Map<String, dynamic>> _activeTechnicians = [];
  bool _isLoadingTechnicians = false;

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
      case 'Approved':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.hourglass_empty;
      case 'In Progress':
        return Icons.engineering_outlined;
      case 'Approved':
        return Icons.check_circle_outline;
      case 'Completed':
        return Icons.check_circle_outline;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outlined;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInquiries();
    _loadMemberships();
    _loadTechnicians();
  }

  Future<void> _loadInquiries() async {
    if (!mounted) return;
    setState(() {
      _isLoadingInquiries = true;
    });
    try {
      final list = await CorporateInquiryService.fetchInquiries();
      if (!mounted) return;
      setState(() {
        _inquiries = list;
        _inquiryCount = list.length;
      });
    } catch (e) {
      debugPrint("Error loading inquiries: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingInquiries = false;
        });
      }
    }
  }

  Future<void> _loadMemberships() async {
    if (!mounted) return;
    setState(() {
      _isLoadingMemberships = true;
    });
    try {
      final list = await MembershipApplicationService.fetchApplications();
      if (!mounted) return;
      setState(() {
        _memberships = list;
        _membershipCount = list.length;
      });
    } catch (e) {
      debugPrint("Error loading memberships: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMemberships = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          _currentView == 'home'
              ? 'Admin Dashboard'
              : _currentView == 'bookings'
                  ? 'Manage Bookings'
                  : _currentView == 'feedback'
                      ? 'Customer Feedbacks'
                      : _currentView == 'memberships'
                          ? 'Membership Applications'
                          : _currentView == 'prices'
                              ? 'Service Price Manager'
                              : _currentView == 'product_prices'
                                  ? 'Product Price Manager'
                                  : _currentView == 'technicians'
                                      ? 'Manage Technicians'
                                      : 'Corporate Inquiries',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: _currentView != 'home'
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () {
                  setState(() {
                    _currentView = 'home';
                  });
                },
              )
            : null,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.header,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Developer Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30),
            ),
            child: const Row(
              children: [
                Icon(Icons.developer_mode, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Developer Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () async {
              await AdminAuthService.logoutAdmin();
              if (widget.onLogout != null) {
                widget.onLogout!();
              } else if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder<List<BookingModel>>(
        valueListenable: BookingRepository().bookingsNotifier,
        builder: (context, bookings, child) {
          if (_currentView == 'home') {
            return _buildHomeView(bookings);
          }

          if (_currentView == 'feedback') {
            return _buildFeedbackView(bookings);
          }

          if (_currentView == 'inquiries') {
            return _buildCorporateInquiriesView();
          }

          if (_currentView == 'memberships') {
            return _buildMembershipsView();
          }

          if (_currentView == 'prices') {
            return _buildPriceManagerView();
          }

          if (_currentView == 'product_prices') {
            return _buildProductPriceManagerView();
          }

          if (_currentView == 'technicians') {
            return _buildTechniciansView();
          }

          // Otherwise, show 'bookings' manager view
          // Calculate Stats
          final pendingCount = bookings.where((b) => b.status == 'Pending').length;
          final inProgressCount = bookings.where((b) => b.status == 'In Progress').length;
          final completedCount = bookings.where((b) => b.status == 'Completed').length;
          final cancelledCount = bookings.where((b) => b.status == 'Cancelled').length;

          // Filter bookings
          final filteredBookings = bookings.where((b) {
            if (_selectedFilter == 'All') return true;
            return b.status == _selectedFilter;
          }).toList();

          return Column(
            children: [
              // Stats Row
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    _buildStatCard('Pending', pendingCount, Colors.orange),
                    const SizedBox(width: 6),
                    _buildStatCard('In Progress', inProgressCount, Colors.blue),
                    const SizedBox(width: 6),
                    _buildStatCard('Completed', completedCount, Colors.green),
                    const SizedBox(width: 6),
                    _buildStatCard('Cancelled', cancelledCount, Colors.red),
                  ],
                ),
              ),

              // Filter Tabs
              Container(
                height: 50,
                color: Colors.white,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  children: ['All', 'Pending', 'In Progress', 'Completed', 'Cancelled'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          }
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Divider(height: 1),

              // Bookings List
              Expanded(
                child: filteredBookings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No bookings found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];
                          return _buildBookingCard(booking);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    final statusColor = _getStatusColor(booking.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.serviceName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge with Dropdown Trigger
                PopupMenuButton<String>(
                  onSelected: (newStatus) {
                    BookingRepository().updateStatus(booking.id, newStatus);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Status updated to $newStatus'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: _getStatusColor(newStatus),
                      ),
                    );
                  },
                   itemBuilder: (context) => ['Pending', 'In Progress', 'Completed', 'Cancelled']
                      .map((status) => PopupMenuItem<String>(
                            value: status,
                            child: Row(
                              children: [
                                Icon(_getStatusIcon(status), color: _getStatusColor(status), size: 18),
                                const SizedBox(width: 8),
                                Text(status),
                              ],
                            ),
                          ))
                      .toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getStatusIcon(booking.status), color: statusColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          booking.status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.arrow_drop_down, color: statusColor, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Body Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.phone_outlined, booking.customerPhone),
                if (booking.customerEmail.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.mail_outline, booking.customerEmail),
                ],
                const SizedBox(height: 8),
                _buildInfoRow(Icons.place_outlined, booking.customerAddress),
                if (booking.preferredDate.isNotEmpty || booking.preferredTime.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (booking.preferredDate.isNotEmpty) ...[
                        Expanded(
                          child: _buildInfoRow(Icons.calendar_today_outlined, 'Date: ${booking.preferredDate}'),
                        ),
                      ],
                      if (booking.preferredTime.isNotEmpty) ...[
                        Expanded(
                          child: _buildInfoRow(Icons.access_time_outlined, 'Time: ${booking.preferredTime}'),
                        ),
                      ],
                    ],
                  ),
                ],
                if (booking.message.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      booking.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
                if (booking.problemImagePath.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Problem Picture:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.all(10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              InteractiveViewer(
                                child: booking.problemImagePath.startsWith('http') || booking.problemImagePath.startsWith('/uploads')
                                    ? Image.network(
                                        booking.problemImagePath.startsWith('http') ? booking.problemImagePath : '${ApiConfig.backendUrl}${booking.problemImagePath}',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50)),
                                      )
                                    : Image.file(
                                        File(booking.problemImagePath),
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50)),
                                      ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: booking.problemImagePath.startsWith('http') || booking.problemImagePath.startsWith('/uploads')
                              ? NetworkImage(booking.problemImagePath.startsWith('http') ? booking.problemImagePath : '${ApiConfig.backendUrl}${booking.problemImagePath}')
                              : FileImage(File(booking.problemImagePath)) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (booking.assignedWorker != null && booking.assignedWorker!.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.engineering_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Technician: ${booking.assignedWorker}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (booking.status != 'Completed' && booking.status != 'Cancelled')
                        _buildAssignDropdown(booking),
                    ],
                  ),
                  if (booking.startedAt != null && booking.startedAt!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.play_circle_outline_rounded, size: 14, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          'Started: ${_formatDateTime(booking.startedAt!)}',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                  if (booking.workSummary != null && booking.workSummary!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.1)),
                      ),
                      child: Text(
                        'Work Summary: ${booking.workSummary}',
                        style: const TextStyle(fontSize: 11, color: Colors.green, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            if (booking.status != 'Completed' && booking.status != 'Cancelled') ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.engineering_rounded, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'No Technician Assigned',
                        style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ),
                    _buildAssignDropdown(booking),
                  ],
                ),
              ),
            ],
          ],

          const Divider(height: 1),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Quick Call Button
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _launchUrl('tel:${booking.customerPhone}'),
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call Client'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                // Quick WhatsApp Button
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      final cleanPhone = booking.customerPhone.replaceAll(RegExp(r'[^\d+]'), '');
                      _launchUrl('https://wa.me/$cleanPhone?text=Hello%20${booking.customerName}!%20This%20is%20ZEETECH%20Admin.');
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('WhatsApp'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeView(List<BookingModel> bookings) {
    final totalBookings = bookings.length;
    final totalFeedbacks = bookings.where((b) => b.rating != null && b.rating! > 0).length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome, Admin',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Manage ZeeTech operations and track customer satisfaction.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 28),
          
          Expanded(
            child: ListView(
              children: [
                _buildDashboardMenuCard(
                  icon: Icons.assignment_rounded,
                  iconColor: AppColors.primary,
                  title: 'Manage Bookings',
                  subtitle: '$totalBookings Total Orders',
                  description: 'View active service requests, update status, and contact clients.',
                  onTap: () {
                    setState(() {
                      _currentView = 'bookings';
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDashboardMenuCard(
                  icon: Icons.rate_review_rounded,
                  iconColor: Colors.amber.shade700,
                  title: 'Customer Feedbacks',
                  subtitle: '$totalFeedbacks Reviews Received',
                  description: 'Read reviews, see service ratings and customer feedback comments.',
                  onTap: () {
                    setState(() {
                      _currentView = 'feedback';
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDashboardMenuCard(
                  icon: Icons.business_center_rounded,
                  iconColor: Colors.deepPurple,
                  title: 'Corporate Inquiries',
                  subtitle: '$_inquiryCount Requests Received',
                  description: 'View corporate requests, details, business types, and contacts.',
                  onTap: () {
                    setState(() {
                      _currentView = 'inquiries';
                    });
                    _loadInquiries();
                  },
                ),
                const SizedBox(height: 20),
                _buildDashboardMenuCard(
                  icon: Icons.badge_rounded,
                  iconColor: Colors.teal.shade700,
                  title: 'Membership Applications',
                  subtitle: '$_membershipCount Applications Received',
                  description: 'Manage silver, gold, and premium memberships and process official approvals.',
                  onTap: () {
                    setState(() {
                      _currentView = 'memberships';
                    });
                    _loadMemberships();
                  },
                ),
                const SizedBox(height: 20),
                _buildDashboardMenuCard(
                  icon: Icons.price_change_rounded,
                  iconColor: Colors.pink.shade700,
                  title: 'Service Price Manager',
                  subtitle: 'Update service pricing dynamically',
                  description: 'Configure and update service and package prices without making code changes.',
                  onTap: () {
                    setState(() {
                      _currentView = 'prices';
                    });
                    _loadDbPrices();
                  },
                ),
                const SizedBox(height: 20),
                _buildDashboardMenuCard(
                  icon: Icons.shopping_bag_rounded,
                  iconColor: Colors.green.shade700,
                  title: 'Product Price Manager',
                  subtitle: 'Update product pricing dynamically',
                  description: 'Configure and update product and spare part prices without making code changes.',
                  onTap: () {
                    setState(() {
                      _currentView = 'product_prices';
                    });
                    _loadDbProductPrices();
                  },
                ),
                const SizedBox(height: 20),
                _buildDashboardMenuCard(
                  icon: Icons.engineering_rounded,
                  iconColor: Colors.blueAccent.shade700,
                  title: 'Manage Technicians',
                  subtitle: 'Register and assign field staff',
                  description: 'Add new technicians, configure their expertise specialties, and view active personnel.',
                  onTap: () {
                    setState(() {
                      _currentView = 'technicians';
                    });
                    _loadTechnicians();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardMenuCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackView(List<BookingModel> bookings) {
    final feedbackBookings = bookings.where((b) => b.rating != null && b.rating! > 0).toList();

    if (feedbackBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Reviews from completed services will appear here.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: feedbackBookings.length,
      itemBuilder: (context, index) {
        final booking = feedbackBookings[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.customerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking.serviceName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(5, (starIndex) {
                        final starValue = starIndex + 1;
                        final isFilled = starValue <= (booking.rating ?? 0);
                        return Icon(
                          Icons.star_rounded,
                          color: isFilled ? Colors.amber : Colors.grey.shade200,
                          size: 20,
                        );
                      }),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (booking.feedbackComment != null && booking.feedbackComment!.isNotEmpty) ...[
                  const Text(
                    'Client Review:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      '"${booking.feedbackComment}"',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textDark,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking ID: #${booking.id.substring(0, 8).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                        fontFamily: 'monospace',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone_outlined, color: Colors.green, size: 20),
                      onPressed: () => _launchUrl('tel:${booking.customerPhone}'),
                      tooltip: 'Call Client',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCorporateInquiriesView() {
    if (_isLoadingInquiries) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_inquiries.isEmpty) {
      return Center(
        child: RefreshIndicator(
          onRefresh: _loadInquiries,
          color: AppColors.primary,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              Icon(Icons.business_center_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'No Corporate Inquiries yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Pull down to refresh or check later.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInquiries,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _inquiries.length,
        itemBuilder: (context, index) {
          final inquiry = _inquiries[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inquiry.businessName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              inquiry.businessType,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              inquiry.city,
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Status Badge with Dropdown Trigger
                          PopupMenuButton<String>(
                            onSelected: (newStatus) async {
                              if (inquiry.id == null) return;
                              final success = await CorporateInquiryService.updateStatus(inquiry.id!, newStatus);
                              if (success) {
                                setState(() {
                                  inquiry.status = newStatus;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Status updated to $newStatus'),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: _getStatusColor(newStatus),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to update status'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) => ['Pending', 'Approved', 'Completed', 'Cancelled']
                                .map((status) => PopupMenuItem<String>(
                                      value: status,
                                      child: Row(
                                        children: [
                                          Icon(_getStatusIcon(status), color: _getStatusColor(status), size: 18),
                                          const SizedBox(width: 8),
                                          Text(status),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusColor(inquiry.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_getStatusIcon(inquiry.status), color: _getStatusColor(inquiry.status), size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    inquiry.status,
                                    style: TextStyle(
                                      color: _getStatusColor(inquiry.status),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(Icons.arrow_drop_down, color: _getStatusColor(inquiry.status), size: 14),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.person_outline, 'Rep Name: ${inquiry.repName}'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.phone_outlined, 'Rep Number: ${inquiry.repNumber}'),
                  if (inquiry.email.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.mail_outline, 'Email: ${inquiry.email}'),
                  ],
                  if (inquiry.message.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Requirements / Details:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Text(
                        inquiry.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: ${inquiry.createdAt.day}-${inquiry.createdAt.month}-${inquiry.createdAt.year}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: AppColors.primary, size: 20),
                            onPressed: () => _launchUrl('tel:${inquiry.repNumber}'),
                            tooltip: 'Call Representative',
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline, color: Colors.green, size: 20),
                            onPressed: () {
                              final cleanPhone = inquiry.repNumber.replaceAll(RegExp(r'[^\d+]'), '');
                              _launchUrl('https://wa.me/$cleanPhone?text=Hello%20${inquiry.repName}!%20This%20is%20ZEETECH%20Admin%20regarding%20your%20corporate%20inquiry%20for%20${inquiry.businessName}.');
                            },
                            tooltip: 'WhatsApp Representative',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTabButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryTab = label;
        });
      },
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$label Memberships',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipsView() {
    if (_isLoadingMemberships) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // Filter memberships by category first
    final categoryApps = _memberships.where((m) => m.category.toLowerCase() == _selectedCategoryTab.toLowerCase()).toList();

    // Filter memberships based on status selection
    final filteredMemberships = categoryApps.where((m) {
      if (_selectedMembershipFilter == 'All') return true;
      return m.status.toLowerCase() == _selectedMembershipFilter.toLowerCase();
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadMemberships,
      color: AppColors.primary,
      child: Column(
        children: [
          // Category Selector Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: _buildCategoryTabButton('Domestic', _selectedCategoryTab == 'Domestic'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCategoryTabButton('Commercial', _selectedCategoryTab == 'Commercial'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Sub-stats bar for selected category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatsIndicator('Pending', categoryApps.where((m) => m.status == 'Pending').length, Colors.orange),
                _buildStatsIndicator('Approved', categoryApps.where((m) => m.status == 'Approved').length, Colors.green),
                _buildStatsIndicator('Rejected', categoryApps.where((m) => m.status == 'Rejected').length, Colors.red),
              ],
            ),
          ),
          // Filter Chips
          Container(
            height: 48,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: ['All', 'Pending', 'Approved', 'Rejected'].map((filter) {
                final isSelected = _selectedMembershipFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedMembershipFilter = filter;
                        });
                      }
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // Applications List
          Expanded(
            child: filteredMemberships.isEmpty
                ? ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 80),
                      Icon(Icons.badge_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'No Membership Applications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'Pull down to refresh or check later.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMemberships.length,
                    itemBuilder: (context, index) {
                      final app = filteredMemberships[index];
                      final planColor = _getPlanBadgeColor(app.planName);
                      final planIcon = _getPlanBadgeIcon(app.planName);

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 16),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Bar: Plan Info & Status
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: planColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: planColor.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(planIcon, color: planColor, size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${app.planName} • ${app.discount} OFF',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: planColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quick status dropdown trigger or static status badge
                                  PopupMenuButton<String>(
                                    onSelected: (newStatus) async {
                                      if (app.id == null) return;
                                      if (newStatus == 'Approved') {
                                        _showApprovalDialog(app);
                                        return;
                                      }
                                      final success = await MembershipApplicationService.updateStatus(app.id!, newStatus);
                                      if (success) {
                                        _loadMemberships();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Status updated to $newStatus'),
                                            backgroundColor: _getStatusColor(newStatus),
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => ['Pending', 'Approved', 'Rejected']
                                        .map((status) => PopupMenuItem<String>(
                                              value: status,
                                              child: Row(
                                                children: [
                                                  Icon(_getStatusIcon(status), color: _getStatusColor(status), size: 18),
                                                  const SizedBox(width: 8),
                                                  Text(status),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(app.status).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(_getStatusIcon(app.status), color: _getStatusColor(app.status), size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            app.status,
                                            style: TextStyle(
                                              color: _getStatusColor(app.status),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Icon(Icons.arrow_drop_down, color: _getStatusColor(app.status), size: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Applicant Name & Category
                              Text(
                                app.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${app.category} Membership Application',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Divider(height: 24),

                              // Applicant Details Grid
                              _buildInfoRow(Icons.people_outline_rounded, 'Father/Spouse: ${app.fatherName}'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildInfoRow(Icons.badge_outlined, 'CNIC: ${app.cnic}')),
                                  Expanded(child: _buildInfoRow(Icons.cake_outlined, 'DOB: ${app.dob}')),
                                ],
                              ),
                              if (app.occupation.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.work_outline, 'Occupation: ${app.occupation}'),
                              ],
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.phone_android_outlined, 'Mobile: ${app.mobile}'),
                              if (app.altContact.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.phone_outlined, 'Alt Contact: ${app.altContact}'),
                              ],
                              if (app.email.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.mail_outline_rounded, 'Email: ${app.email}'),
                              ],
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.location_on_outlined, 'Address: ${app.address}'),
                              if (app.preferredServices.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade100),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Preferred Services:',
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        app.preferredServices,
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              // Approved Section - Show Membership Card ID, Active Date, and Expiry Date
                              if (app.status == 'Approved' && app.membershipId != null) ...[
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.teal.shade50, Colors.teal.shade50.withOpacity(0.3)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.teal.shade200.withOpacity(0.5)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.verified_user_rounded, color: Colors.teal, size: 24),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'REGISTERED MEMBER ID',
                                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.teal),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  app.membershipId!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.teal,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (app.processedAt != null) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Divider(height: 1, color: Colors.teal.shade100),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.calendar_today_rounded, color: Colors.teal, size: 14),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        'ACTIVE DATE',
                                                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.teal),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        '${app.processedAt!.day}/${app.processedAt!.month}/${app.processedAt!.year}',
                                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.teal),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Builder(
                                                builder: (context) {
                                                  final start = app.processedAt!;
                                                  int months = 3;
                                                  if (app.validity == '6 Months') {
                                                    months = 6;
                                                  } else if (app.validity == '1 Year') {
                                                    months = 12;
                                                  }
                                                  int newMonth = start.month + months;
                                                  int newYear = start.year;
                                                  while (newMonth > 12) {
                                                    newMonth -= 12;
                                                    newYear += 1;
                                                  }
                                                  final expiry = DateTime(newYear, newMonth, start.day);
                                                  return Row(
                                                    children: [
                                                      const Icon(Icons.event_busy_rounded, color: Colors.redAccent, size: 14),
                                                      const SizedBox(width: 8),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text(
                                                            'EXPIRY DATE',
                                                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.redAccent),
                                                          ),
                                                          const SizedBox(height: 2),
                                                          Text(
                                                            '${expiry.day}/${expiry.month}/${expiry.year}',
                                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.redAccent),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],

                              // Display Office Use Block if available
                              if (app.officerName != null && app.officerName!.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.corporate_fare_rounded, size: 14, color: Colors.grey),
                                          SizedBox(width: 6),
                                          Text(
                                            'OFFICIAL USE DATA',
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 16),
                                      if (app.remarks != null && app.remarks!.isNotEmpty) ...[
                                        Text(
                                          'Remarks: "${app.remarks}"',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                      Text(
                                        'Initiated By: ${app.initiatedBy}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Officer: ${app.officerName} (${app.officerDesignation}) - Emp ID: ${app.officerEmpId}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              // Action Section
                              const Divider(height: 32),
                              Row(
                                children: [
                                  // Call
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () => _launchUrl('tel:${app.mobile}'),
                                      icon: const Icon(Icons.phone, size: 16),
                                      label: const Text('Call'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    ),
                                  ),
                                  // WhatsApp
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () {
                                        final cleanPhone = app.mobile.replaceAll(RegExp(r'[^\d+]'), '');
                                        _launchUrl('https://wa.me/$cleanPhone?text=Hello%20${app.fullName}!%20This%20is%20ZEETECH%20Admin%20regarding%20your%20membership%20application.');
                                      },
                                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                                      label: const Text('WhatsApp'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    ),
                                  ),
                                  // Process Button
                                  if (app.status == 'Pending')
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton.icon(
                                        onPressed: () => _showApprovalDialog(app),
                                        icon: const Icon(Icons.gavel_rounded, size: 16),
                                        label: const Text('Process'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    ),
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
    );
  }

  Widget _buildStatsIndicator(String title, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 6),
              Text(
                '$title: ',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
              ),
              Text(
                count.toString(),
                style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPlanBadgeColor(String planName) {
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

  IconData _getPlanBadgeIcon(String planName) {
    switch (planName) {
      case 'Silver':
        return Icons.workspace_premium_rounded;
      case 'Gold':
        return Icons.stars_rounded;
      case 'Premium':
        return Icons.diamond_rounded;
      default:
        return Icons.card_membership_rounded;
    }
  }

  void _showApprovalDialog(MembershipApplicationModel application) {
    final formKey = GlobalKey<FormState>();
    final membershipIdController = TextEditingController(text: 'ZEE-MEM-${1000 + (application.id ?? 1)}');
    final initiatedByController = TextEditingController(text: 'ZEETECH Admin');
    final remarksController = TextEditingController();
    final officerNameController = TextEditingController();
    final officerDesignationController = TextEditingController(text: 'Manager Operations');
    final officerEmpIdController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Handle Bar
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.corporate_fare_rounded, color: Colors.teal, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Official Membership Approval',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'FOR OFFICIAL USE ONLY',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.teal, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 24),
                  // Form Fields
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          const Text(
                            'Assign Membership Credentials',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          _buildModalTextField(
                            controller: membershipIdController,
                            label: 'Membership ID',
                            icon: Icons.vpn_key_outlined,
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          _buildModalTextField(
                            controller: initiatedByController,
                            label: 'Initiated By',
                            icon: Icons.person_outline,
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          _buildModalTextField(
                            controller: remarksController,
                            label: 'Remarks / Comments',
                            icon: Icons.comment_bank_outlined,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Issuing Authority Credentials',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          _buildModalTextField(
                            controller: officerNameController,
                            label: 'Officer Name',
                            icon: Icons.shield_outlined,
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildModalTextField(
                                  controller: officerDesignationController,
                                  label: 'Designation',
                                  icon: Icons.assignment_ind_outlined,
                                  required: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildModalTextField(
                                  controller: officerEmpIdController,
                                  label: 'Employee ID',
                                  icon: Icons.badge_outlined,
                                  required: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Confirm Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) return;
                                final details = {
                                  'membershipId': membershipIdController.text.trim(),
                                  'initiatedBy': initiatedByController.text.trim(),
                                  'remarks': remarksController.text.trim(),
                                  'officerName': officerNameController.text.trim(),
                                  'officerDesignation': officerDesignationController.text.trim(),
                                  'officerEmpId': officerEmpIdController.text.trim(),
                                };
                                
                                Navigator.pop(context); // Close modal
                                
                                final success = await MembershipApplicationService.approveApplication(application.id!, details);
                                if (success) {
                                  _loadMemberships();
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Membership successfully approved & registered!'),
                                      backgroundColor: Colors.teal,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to approve membership application'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                              label: const Text(
                                'Approve & Register Member',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red, width: 1)),
      ),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            }
          : null,
    );
  }

  // ── SERVICE PRICE MANAGER METHODS ──────────────────────────────────
  
  static const List<Map<String, dynamic>> _priceCategories = [
    {'id': 'ac', 'name': 'Air Conditioner', 'icon': Icons.ac_unit_rounded},
    {'id': 'refrigerator', 'name': 'Refrigerator', 'icon': Icons.kitchen_rounded},
    {'id': 'solar', 'name': 'Solar Energy', 'icon': Icons.wb_sunny_rounded},
    {'id': 'inverter', 'name': 'Inverter Services', 'icon': Icons.battery_charging_full_rounded},
    {'id': 'carpenter', 'name': 'Carpenter', 'icon': Icons.handyman_rounded},
    {'id': 'electrician', 'name': 'Electrician', 'icon': Icons.electrical_services_rounded},
    {'id': 'cctv', 'name': 'CCTV Installation', 'icon': Icons.videocam_rounded},
    {'id': 'washing_machine', 'name': 'Automatic washing machine', 'icon': Icons.local_laundry_service_rounded},
  ];

  static const Map<String, List<Map<String, dynamic>>> _priceItems = {
    'ac': [
      {'id': 'ac_1', 'name': 'AC Dismounting', 'defaultPrice': 1200, 'defaultOriginalPrice': 1500, 'desc': 'Per AC (1 to 2.5 tons)'},
      {'id': 'ac_2', 'name': 'AC General Service', 'defaultPrice': 2500, 'defaultOriginalPrice': 3300, 'desc': 'Per AC (1 to 2.5 tons)'},
      {'id': 'ac_3', 'name': 'AC Installation', 'defaultPrice': 3200, 'defaultOriginalPrice': 5100, 'desc': 'Installation with 10 Feet pipe (1 to 2.5 tons)'},
      {'id': 'ac_4', 'name': 'AC Mounting and Dismounting', 'defaultPrice': 4000, 'defaultOriginalPrice': 6400, 'desc': 'Per AC (1 to 2.5 tons)'},
      {'id': 'ac_5', 'name': 'AC Mounting and Dismounting + AC General Service', 'defaultPrice': 5500, 'defaultOriginalPrice': 8500, 'desc': 'Per AC (1 to 2.5 tons)'},
      {'id': 'ac_6', 'name': 'AC Repairing', 'defaultPrice': 800, 'defaultOriginalPrice': 1000, 'desc': 'Visit and Inspection Charges'},
    ],
    'refrigerator': [
      {'id': 'ref_1', 'name': 'Cooling System Repair', 'defaultPrice': 3000, 'defaultOriginalPrice': 4200, 'desc': 'Thermostat, relay, capacitor or fan repair to restore cold cycles.'},
      {'id': 'ref_2', 'name': 'Gas Charging & Leak Fix', 'defaultPrice': 4000, 'defaultOriginalPrice': 5500, 'desc': 'Flushing lines, filter dryer change, pressure test and pure R134a/R600 charging.'},
      {'id': 'ref_3', 'name': 'Compressor Replacement', 'defaultPrice': 9000, 'defaultOriginalPrice': 12500, 'desc': 'Branded compressor installation with filter dryer and pressure test.'},
      {'id': 'ref_4', 'name': 'Door Seal Replacement', 'defaultPrice': 1200, 'defaultOriginalPrice': 1800, 'desc': 'Replacing damaged or magnetic rubber lining to stop cooling loss.'},
      {'id': 'ref_5', 'name': 'Thermostat Repair', 'defaultPrice': 1800, 'defaultOriginalPrice': 2500, 'desc': 'Replacing faulty temperature control thermostat switches.'},
      {'id': 'ref_6', 'name': 'Ice Maker Repair', 'defaultPrice': 2500, 'defaultOriginalPrice': 3500, 'desc': 'Fixing supply lines, valves, and control board of automatic ice dispensers.'},
    ],
    'solar': [
      {'id': 'sol_1', 'name': 'Solar Panel Installation', 'defaultPrice': 12000, 'defaultOriginalPrice': 16500, 'desc': 'Mounting solar panels on standard structures with secure electrical connections.'},
      {'id': 'sol_2', 'name': 'Inverter Installation', 'defaultPrice': 8000, 'defaultOriginalPrice': 11000, 'desc': 'Wall mounting solar inverter, DC/AC breaker boxes and cable routing.'},
      {'id': 'sol_3', 'name': 'System Maintenance', 'defaultPrice': 5000, 'defaultOriginalPrice': 7000, 'desc': 'Cleaning panels, inspecting MC4 connectors, and verifying output current.'},
      {'id': 'sol_4', 'name': 'Battery Replacement', 'defaultPrice': 25000, 'defaultOriginalPrice': 32000, 'desc': 'Upgrading to high-capacity tubular batteries or Lithium battery packs.'},
      {'id': 'sol_5', 'name': 'Net Metering Setup', 'defaultPrice': 15000, 'defaultOriginalPrice': 20000, 'desc': 'Three-phase green meter application process, documentation, and install.'},
      {'id': 'sol_6', 'name': 'Solar Water Heater Installation', 'defaultPrice': 10000, 'defaultOriginalPrice': 14000, 'desc': 'Assembling glass vacuum tubes, hot water tank, and plumbing connections.'},
    ],
    'inverter': [
      {'id': 'inv_1', 'name': 'Inverter Installation', 'defaultPrice': 4000, 'defaultOriginalPrice': 5500, 'desc': 'Setting up UPS with battery connections.'},
      {'id': 'inv_2', 'name': 'UPS Repair & Maintenance', 'defaultPrice': 3000, 'defaultOriginalPrice': 4200, 'desc': 'Replacing motherboard components, capacitors, or cooling fan.'},
      {'id': 'inv_3', 'name': 'Battery Replacement', 'defaultPrice': 22000, 'defaultOriginalPrice': 29000, 'desc': 'Installing new deep cycle tubular battery with terminal greasing.'},
      {'id': 'inv_4', 'name': 'Circuit & Wiring Check', 'defaultPrice': 1500, 'defaultOriginalPrice': 2200, 'desc': 'Verifying load separation, input neutral lines and output circuits.'},
      {'id': 'inv_5', 'name': 'Load Calculation', 'defaultPrice': 1000, 'defaultOriginalPrice': 1500, 'desc': 'Professional system loading check to prevent overload.'},
      {'id': 'inv_6', 'name': 'Automatic Transfer Switch Setup', 'defaultPrice': 3500, 'defaultOriginalPrice': 4800, 'desc': 'Installing ATS breaker panel for automated shifting.'},
    ],
    'carpenter': [
      {'id': 'carp_1', 'name': 'Carpenter Work', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit & Inspection Charges'},
      {'id': 'carp_2', 'name': 'Catcher Replacement', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Per Catcher'},
      {'id': 'carp_3', 'name': 'Door Installation', 'defaultPrice': 1000, 'defaultOriginalPrice': 1500, 'desc': 'Starting From'},
      {'id': 'carp_4', 'name': 'Door Repairing', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit & Inspection Charges'},
      {'id': 'carp_5', 'name': 'Drawer Lock installation', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Per Lock'},
      {'id': 'carp_6', 'name': 'Drawer Repairing', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Vary After Inspection'},
      {'id': 'carp_7', 'name': 'Furniture Repairing', 'defaultPrice': 500, 'defaultOriginalPrice': 500, 'desc': 'Visit & Inspection Charges'},
      {'id': 'carp_8', 'name': 'Room Door Lock installation', 'defaultPrice': 1200, 'defaultOriginalPrice': 1500, 'desc': 'Vary After inspection'},
      {'id': 'carp_9', 'name': 'Wardrobe Repairing', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit & Inspection Charges'},
    ],
    'electrician': [
      {'id': 'elec_1', 'name': '32-42 Inch LED TV or LCD Mounting', 'defaultPrice': 1250, 'defaultOriginalPrice': 1500, 'desc': 'Vary After Inspection'},
      {'id': 'elec_2', 'name': '43-65 Inch LED TV or LCD Mounting', 'defaultPrice': 1600, 'defaultOriginalPrice': 2000, 'desc': 'Starting from Per LED/LCD'},
      {'id': 'elec_3', 'name': 'Automatic Washing Machine Repairing', 'defaultPrice': 800, 'defaultOriginalPrice': 1000, 'desc': 'Visit and Inspection Charges'},
      {'id': 'elec_4', 'name': 'Ceiling Fan Installation', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Per Fan'},
      {'id': 'elec_5', 'name': 'Ceiling Fan Repairing', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit & Inspection Charges'},
      {'id': 'elec_6', 'name': 'Change Over Switch Installation', 'defaultPrice': 1200, 'defaultOriginalPrice': 1700, 'desc': 'Vary After Inspection'},
      {'id': 'elec_7', 'name': 'Door Pillar Lights', 'defaultPrice': 600, 'defaultOriginalPrice': 800, 'desc': 'Vary After inspection'},
      {'id': 'elec_8', 'name': 'Electrical Wiring', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit and Inspection charges'},
      {'id': 'elec_9', 'name': 'Exhaust Fan Installation', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Per Fan (Fit in existing hole)'},
      {'id': 'elec_10', 'name': 'Fan Dimmer Switch Installation', 'defaultPrice': 600, 'defaultOriginalPrice': 800, 'desc': 'Vary After Inspection'},
      {'id': 'elec_11', 'name': 'Fancy Light Installation (With Wiring)', 'defaultPrice': 1000, 'defaultOriginalPrice': 1200, 'desc': 'Per Light (Discount on more then 2)'},
      {'id': 'elec_12', 'name': 'Fancy Light Installation (Without Wiring)', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Per Light (Discount on more then 2)'},
      {'id': 'elec_13', 'name': 'House Electric Work', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Visit and Inspection Charges'},
      {'id': 'elec_14', 'name': 'Kitchen Hood Installation', 'defaultPrice': 500, 'defaultOriginalPrice': 900, 'desc': 'Visit and Inspection charges'},
      {'id': 'elec_15', 'name': 'Kitchen Hood Repairing', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Visit and Inspection charges'},
      {'id': 'elec_16', 'name': 'LED TV Dismounting', 'defaultPrice': 700, 'defaultOriginalPrice': 900, 'desc': 'Per LED/LCD'},
      {'id': 'elec_17', 'name': 'Light Plug (With Wiring)', 'defaultPrice': 700, 'defaultOriginalPrice': 800, 'desc': 'Vary After Inspection'},
      {'id': 'elec_18', 'name': 'Light Plug (Without Wiring)', 'defaultPrice': 650, 'defaultOriginalPrice': 800, 'desc': 'Per Plug'},
      {'id': 'elec_19', 'name': 'Manual Washing machine repairing', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Visit and Inspection charges'},
      {'id': 'elec_20', 'name': 'New House Wiring', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit and Inspection charges'},
      {'id': 'elec_21', 'name': 'Power Plug Installation (With Wiring)', 'defaultPrice': 900, 'defaultOriginalPrice': 1000, 'desc': 'Vary After Inspection'},
      {'id': 'elec_22', 'name': 'Power Plug Installation (Without Wiring)', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Per Plug'},
      {'id': 'elec_23', 'name': 'Pressure Motor Installation', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit and Inspection charges'},
      {'id': 'elec_24', 'name': 'Single Phase Breaker Replacement', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Starting From'},
      {'id': 'elec_25', 'name': 'Single Phase Distribution Box Installation', 'defaultPrice': 2000, 'defaultOriginalPrice': 2200, 'desc': 'Starting From'},
      {'id': 'elec_26', 'name': 'SMD Lights Installation (With Wiring)', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Per Light (Discount on more then 2)'},
      {'id': 'elec_27', 'name': 'SMD Lights Installation (Without Wiring)', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Per Light (Discount on more then 2)'},
      {'id': 'elec_28', 'name': 'Sub-Meter Installation', 'defaultPrice': 1000, 'defaultOriginalPrice': 1200, 'desc': 'Starting From'},
      {'id': 'elec_29', 'name': 'Switchboard Button Replacement', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Vary After Inspection'},
      {'id': 'elec_30', 'name': 'Tube light Installation', 'defaultPrice': 600, 'defaultOriginalPrice': 800, 'desc': 'Per Tube Light'},
      {'id': 'elec_31', 'name': 'Tube Light Repairing', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit & Inspection Charges'},
      {'id': 'elec_32', 'name': 'Tube Light Replacement', 'defaultPrice': 650, 'defaultOriginalPrice': 800, 'desc': 'Per Tube Light'},
      {'id': 'elec_33', 'name': 'UPS installation (Without Wiring)', 'defaultPrice': 1500, 'defaultOriginalPrice': 1800, 'desc': 'Vary After Inspection'},
      {'id': 'elec_34', 'name': 'UPS Repairing', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Visit and Inspection charges'},
      {'id': 'elec_35', 'name': 'UPS Wiring', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit and Inspection charges'},
      {'id': 'elec_36', 'name': 'Water Pump Repairing', 'defaultPrice': 500, 'defaultOriginalPrice': 800, 'desc': 'Visit and Inspection Charges'},
      {'id': 'elec_37', 'name': 'Water Tank Automatic Switch Installation', 'defaultPrice': 800, 'defaultOriginalPrice': 900, 'desc': 'Vary After Inspection'},
    ],
    'cctv': [
      {'id': 'cctv_1', 'name': 'CCTV Camera Setup (Single Unit)', 'defaultPrice': 1200, 'defaultOriginalPrice': 1800, 'desc': 'Camera mounting, DVR BNC wiring, and focus check.'},
      {'id': 'cctv_2', 'name': 'DVR/NVR 4-Channel Program', 'defaultPrice': 2500, 'defaultOriginalPrice': 3500, 'desc': 'Hard drive recording and mobile view configuration.'},
      {'id': 'cctv_3', 'name': 'CCTV Security Cabling (Per RFT)', 'defaultPrice': 400, 'defaultOriginalPrice': 600, 'desc': 'Durable protective PVC pipe duct cabling.'},
      {'id': 'cctv_4', 'name': 'Complete 4-Camera Security Pack', 'defaultPrice': 15000, 'defaultOriginalPrice': 22000, 'desc': 'Includes 4 HD dome cameras, DVR, cabling, power supply, and complete setup.'},
    ],
    'washing_machine': [
      {'id': 'wm_1', 'name': 'Auto Washing Machine Repairing', 'defaultPrice': 800, 'defaultOriginalPrice': 1000, 'desc': 'Visit and Inspection Charges for automatic washing machine.'},
      {'id': 'wm_2', 'name': 'Auto Washing Machine Installation', 'defaultPrice': 1500, 'defaultOriginalPrice': 2000, 'desc': 'New automatic washing machine setup with water inlet, drain pipe, and power connection.'},
      {'id': 'wm_3', 'name': 'Drum Bearing Replacement', 'defaultPrice': 2500, 'defaultOriginalPrice': 3500, 'desc': 'Fixing drum bearing, spider arm, or shaft noise and vibration issues.'},
      {'id': 'wm_4', 'name': 'Motor Replacement', 'defaultPrice': 4500, 'defaultOriginalPrice': 6000, 'desc': 'Replacing faulty drive motor for front or top loader automatic machines.'},
      {'id': 'wm_5', 'name': 'Water Inlet Valve Repair', 'defaultPrice': 1200, 'defaultOriginalPrice': 1800, 'desc': 'Fixing water fill issues, solenoid valve replacement for proper water flow.'},
      {'id': 'wm_6', 'name': 'Drain Pump Repair', 'defaultPrice': 1500, 'defaultOriginalPrice': 2200, 'desc': 'Fixing drainage problems, pump motor or filter blockage replacement.'},
      {'id': 'wm_7', 'name': 'PCB / Control Board Repair', 'defaultPrice': 3000, 'defaultOriginalPrice': 4500, 'desc': 'Electronic control board diagnosis, component-level repair or replacement.'},
      {'id': 'wm_8', 'name': 'Door Lock & Seal Replacement', 'defaultPrice': 1000, 'defaultOriginalPrice': 1500, 'desc': 'Replacing damaged door gasket rubber seal or faulty lock mechanism.'},
      {'id': 'wm_9', 'name': 'General Service & Deep Cleaning', 'defaultPrice': 1500, 'defaultOriginalPrice': 2000, 'desc': 'Full drum deep cleaning, descaling, filter clean, and maintenance check.'},
      {'id': 'wm_10', 'name': 'Spin Cycle Problem Fix', 'defaultPrice': 1800, 'defaultOriginalPrice': 2500, 'desc': 'Fixing spin issues including clutch assembly, lid switch, or motor coupler.'},
    ],
  };

  Future<void> _loadDbPrices() async {
    if (!mounted) return;
    setState(() {
      _isLoadingDbPrices = true;
    });
    try {
      final prices = await ServicePriceService.fetchPrices();
      if (mounted) {
        setState(() {
          _dbServicePrices = prices;
        });
      }
    } catch (e) {
      debugPrint("Error loading service prices: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDbPrices = false;
        });
      }
    }
  }

  Widget _buildPriceManagerView() {
    if (_isLoadingDbPrices) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final List<Map<String, dynamic>> defaultItems = List<Map<String, dynamic>>.from(
      _priceItems[_selectedCategoryTabPrice] ?? []
    );

    final List<Map<String, dynamic>> activeItems = defaultItems.map((item) {
      return {
        'id': item['id'],
        'name': item['name'],
        'desc': item['desc'],
        'defaultPrice': item['defaultPrice'],
        'defaultOriginalPrice': item['defaultOriginalPrice'],
        'onSale': false,
        'salePercent': 0,
      };
    }).toList();

    for (var custom in _dbServicePrices) {
      final index = activeItems.indexWhere((item) => item['id'] == custom.id);
      if (index != -1) {
        activeItems[index]['defaultPrice'] = custom.price;
        activeItems[index]['defaultOriginalPrice'] = custom.originalPrice;
        if (custom.name != null && custom.name!.trim().isNotEmpty) {
          activeItems[index]['name'] = custom.name;
        }
        if (custom.desc != null && custom.desc!.trim().isNotEmpty) {
          activeItems[index]['desc'] = custom.desc;
        }
        activeItems[index]['onSale'] = custom.onSale;
        activeItems[index]['salePercent'] = custom.salePercent;
      } else if (custom.categoryId == _selectedCategoryTabPrice) {
        activeItems.add({
          'id': custom.id,
          'name': custom.name ?? 'Custom Service',
          'desc': custom.desc ?? 'Dynamic custom service package.',
          'defaultPrice': custom.price,
          'defaultOriginalPrice': custom.originalPrice,
          'onSale': custom.onSale,
          'salePercent': custom.salePercent,
        });
      }
    }

    return RefreshIndicator(
      onRefresh: _loadDbPrices,
      color: AppColors.primary,
      child: Column(
        children: [
          // Horizontal Category Chips
          Container(
            height: 52,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _priceCategories.length,
              itemBuilder: (context, index) {
                final cat = _priceCategories[index];
                final isSelected = _selectedCategoryTabPrice == cat['id'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    avatar: Icon(
                      cat['icon'],
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      size: 14,
                    ),
                    label: Text(cat['name']),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategoryTabPrice = cat['id'];
                        });
                      }
                    },
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Add New Package Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service Packages Catalog',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddServiceDialog,
                  icon: const Icon(Icons.add_rounded, size: 14, color: Colors.white),
                  label: const Text(
                    'Add Service',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Packages List
          Expanded(
            child: activeItems.isEmpty
                ? const Center(
                    child: Text('No Service Packages Available'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activeItems.length,
                    itemBuilder: (context, index) {
                      final item = activeItems[index];

                      int activePrice = item['defaultPrice'];
                      int activeOriginalPrice = item['defaultOriginalPrice'];

                      final hasOverride = _dbServicePrices.any((p) => p.id == item['id']);

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['name'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ),
                                        if (item['onSale'] as bool? ?? false) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.red.shade300, width: 0.8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.local_offer_rounded, color: Colors.red.shade700, size: 10),
                                                const SizedBox(width: 3),
                                                Text(
                                                  (item['salePercent'] as int? ?? 0) > 0
                                                      ? '${item['salePercent']}% OFF'
                                                      : 'SALE',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (hasOverride) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.pink.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Custom DB',
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['desc'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Rs. $activePrice',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Rs. $activeOriginalPrice',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _showEditPriceDialog(
                                      item,
                                      activePrice,
                                      activeOriginalPrice,
                                      item['onSale'] as bool? ?? false,
                                      item['salePercent'] as int? ?? 0,
                                    ),
                                    icon: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                                    label: const Text(
                                      'Edit Details',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
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
    );
  }

  void _showEditPriceDialog(Map<String, dynamic> item, int currentPrice, int currentOriginalPrice, bool initialOnSale, int initialSalePercent) {
    final nameController = TextEditingController(text: item['name'] ?? '');
    final descController = TextEditingController(text: item['desc'] ?? '');
    final priceController = TextEditingController(text: currentPrice.toString());
    final originalPriceController = TextEditingController(text: currentOriginalPrice.toString());
    final salePercentController = TextEditingController(text: initialSalePercent > 0 ? initialSalePercent.toString() : '');
    final formKey = GlobalKey<FormState>();
    bool onSaleVal = initialOnSale;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Edit Service Details\n${item['name']}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Service Name',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Active Price (Rs.)',
                          prefixText: 'Rs. ',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          if (int.tryParse(value) == null) return 'Must be a number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: originalPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Original Price (Rs.)',
                          prefixText: 'Rs. ',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          if (int.tryParse(value) == null) return 'Must be a number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text(
                          'Put this service on sale',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        subtitle: const Text(
                          'Show red SALE badge on client side',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        activeColor: Colors.red.shade700,
                        activeTrackColor: Colors.red.shade100,
                        value: onSaleVal,
                        onChanged: (bool value) {
                          setStateDialog(() {
                            onSaleVal = value;
                          });
                        },
                      ),
                      if (onSaleVal) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: salePercentController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Discount Percentage',
                            hintText: 'e.g. 20',
                            suffixText: '%',
                            filled: true,
                            fillColor: Colors.red.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.percent_rounded, color: Colors.red.shade400, size: 20),
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final parsed = int.tryParse(value.trim());
                              if (parsed == null) return 'Must be a number';
                              if (parsed < 1 || parsed > 99) return '1-99 range only';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newPrice = int.parse(priceController.text.trim());
                      final newOriginal = int.parse(originalPriceController.text.trim());
                      
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Updating service details...'),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      final success = await ServicePriceService.updatePrice(
                        id: item['id'],
                        price: newPrice,
                        originalPrice: newOriginal,
                        name: nameController.text.trim(),
                        desc: descController.text.trim(),
                        categoryId: _selectedCategoryTabPrice,
                        onSale: onSaleVal,
                        salePercent: onSaleVal && salePercentController.text.trim().isNotEmpty
                            ? int.parse(salePercentController.text.trim())
                            : 0,
                      );

                      if (success) {
                        _loadDbPrices(); // Reload
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Service details updated successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to update details.'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddServiceDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final originalPriceController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool onSaleVal = false;
    final salePercentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Add New Service Package',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Service Name',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Active Price (Rs.)',
                          prefixText: 'Rs. ',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          if (int.tryParse(value) == null) return 'Must be a number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: originalPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Original Price (Rs.)',
                          prefixText: 'Rs. ',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          if (int.tryParse(value) == null) return 'Must be a number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text(
                          'Put this service on sale',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        subtitle: const Text(
                          'Show red SALE badge on client side',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        activeColor: Colors.red.shade700,
                        activeTrackColor: Colors.red.shade100,
                        value: onSaleVal,
                        onChanged: (bool value) {
                          setStateDialog(() {
                            onSaleVal = value;
                          });
                        },
                      ),
                      if (onSaleVal) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: salePercentController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Discount Percentage',
                            hintText: 'e.g. 20',
                            suffixText: '%',
                            filled: true,
                            fillColor: Colors.red.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.percent_rounded, color: Colors.red.shade400, size: 20),
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final parsed = int.tryParse(value.trim());
                              if (parsed == null) return 'Must be a number';
                              if (parsed < 1 || parsed > 99) return '1-99 range only';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newPrice = int.parse(priceController.text.trim());
                      final newOriginal = int.parse(originalPriceController.text.trim());
                      
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Adding new service package...'),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      final uniqueId = "service_custom_${DateTime.now().millisecondsSinceEpoch}";

                      final success = await ServicePriceService.updatePrice(
                        id: uniqueId,
                        price: newPrice,
                        originalPrice: newOriginal,
                        name: nameController.text.trim(),
                        desc: descController.text.trim(),
                        categoryId: _selectedCategoryTabPrice,
                        onSale: onSaleVal,
                        salePercent: onSaleVal && salePercentController.text.trim().isNotEmpty
                            ? int.parse(salePercentController.text.trim())
                            : 0,
                      );

                      if (success) {
                        _loadDbPrices(); // Reload
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Service package added successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to add service package.'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static const List<Map<String, String>> _productPriceCategories = [
    {'id': 'ac_products', 'name': 'ACs'},
    {'id': 'refrigerator_products', 'name': 'Fridges'},
    {'id': 'solar_products', 'name': 'Solar'},
    {'id': 'inverter_products', 'name': 'Inverters'},
    {'id': 'wood_products', 'name': 'Wood'},
    {'id': 'electrician_products', 'name': 'Electrician'},
    {'id': 'cctv_products', 'name': 'CCTV'},
    {'id': 'washing_machine_products', 'name': 'Washers'},
    {'id': 'ac_parts', 'name': 'AC Parts'},
    {'id': 'refrigerator_parts', 'name': 'Fridge Parts'},
    {'id': 'solar_parts', 'name': 'Solar Parts'},
    {'id': 'inverter_parts', 'name': 'Inverter Parts'},
    {'id': 'electrician_parts', 'name': 'Electrical Parts'},
    {'id': 'cctv_parts', 'name': 'CCTV Parts'},
    {'id': 'washing_machine_parts', 'name': 'Washer Parts'},
  ];

  Future<void> _loadDbProductPrices() async {
    if (!mounted) return;
    setState(() {
      _isLoadingDbProductPrices = true;
    });
    try {
      final prices = await ProductPriceService.fetchPrices();
      if (mounted) {
        setState(() {
          _dbProductPrices = prices;
        });
      }
    } catch (e) {
      debugPrint("Error loading product prices: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDbProductPrices = false;
        });
      }
    }
  }

  Widget _buildProductPriceManagerView() {
    if (_isLoadingDbProductPrices) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    final catData = ProductDetailScreen.productData[_selectedCategoryTabProductPrice];
    final List<Map<String, dynamic>> defaultItems = catData != null 
        ? List<Map<String, dynamic>>.from(catData['items'] as List)
        : [];

    final List<Map<String, dynamic>> items = defaultItems.map((item) {
      final String itemName = item['name'] as String;
      final generatedId = "${_selectedCategoryTabProductPrice}_${itemName.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}";
      return {
        'id': generatedId,
        'name': itemName,
        'desc': item['desc'] ?? '',
        'price': item['price'] as int,
        'originalPrice': 0,
      };
    }).toList();

    for (var custom in _dbProductPrices) {
      final index = items.indexWhere((item) => item['id'] == custom.id);
      if (index != -1) {
        items[index]['price'] = custom.price;
        items[index]['originalPrice'] = custom.originalPrice;
        if (custom.name != null && custom.name!.trim().isNotEmpty) {
          items[index]['name'] = custom.name;
        }
        if (custom.desc != null && custom.desc!.trim().isNotEmpty) {
          items[index]['desc'] = custom.desc;
        }
      } else if (custom.categoryId == _selectedCategoryTabProductPrice) {
        final matchedByDefault = defaultItems.any((item) {
          final String itemName = item['name'] as String;
          final generatedId = "${_selectedCategoryTabProductPrice}_${itemName.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}";
          return generatedId == custom.id;
        });

        if (!matchedByDefault) {
          items.add({
            'id': custom.id,
            'name': custom.name ?? 'Custom Product',
            'desc': custom.desc ?? 'Dynamic custom product item.',
            'price': custom.price,
            'originalPrice': custom.originalPrice,
          });
        }
      }
    }

    return RefreshIndicator(
      onRefresh: _loadDbProductPrices,
      color: Colors.green,
      child: Column(
        children: [
          Container(
            height: 52,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _productPriceCategories.length,
              itemBuilder: (context, index) {
                final cat = _productPriceCategories[index];
                final isSelected = _selectedCategoryTabProductPrice == cat['id'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    avatar: Icon(
                      Icons.shopping_bag_rounded,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      size: 14,
                    ),
                    label: Text(cat['name']!),
                    selected: isSelected,
                    selectedColor: Colors.green.shade700,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategoryTabProductPrice = cat['id']!;
                        });
                      }
                    },
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Add New Product Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Product Catalog Manager',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddProductDialog,
                  icon: const Icon(Icons.add_rounded, size: 14, color: Colors.white),
                  label: const Text(
                    'Add Product',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('No Products Available'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final generatedId = item['id'] as String;

                      int activePrice = item['price'] as int;
                      int activeOriginalPrice = item['originalPrice'] as int;

                      final hasOverride = _dbProductPrices.any((p) => p.id == generatedId);

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  if (hasOverride)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Custom DB',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['desc'] ?? '',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Rs. $activePrice',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      if (activeOriginalPrice > activePrice) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          'Rs. $activeOriginalPrice',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade400,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _showEditProductPriceDialog(
                                      item,
                                      activePrice,
                                      activeOriginalPrice,
                                    ),
                                    icon: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                                    label: const Text(
                                      'Edit Details',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade700,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
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
    );
  }

  void _showEditProductPriceDialog(Map<String, dynamic> item, int currentPrice, int currentOriginalPrice) {
    final nameController = TextEditingController(text: item['name'] ?? '');
    final descController = TextEditingController(text: item['desc'] ?? '');
    final priceController = TextEditingController(text: currentPrice.toString());
    final originalPriceController = TextEditingController(text: currentOriginalPrice.toString());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Edit Product Details\n${item['name']}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Active Price (Rs.)',
                      prefixText: 'Rs. ',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      if (int.tryParse(value) == null) return 'Must be a number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: originalPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Original Price (Rs.)',
                      prefixText: 'Rs. ',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      if (int.tryParse(value) == null) return 'Must be a number';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newPrice = int.parse(priceController.text.trim());
                  final newOriginal = int.parse(originalPriceController.text.trim());
                  
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Updating product details...'),
                      duration: Duration(seconds: 1),
                    ),
                  );

                  final success = await ProductPriceService.updatePrice(
                    id: item['id'],
                    price: newPrice,
                    originalPrice: newOriginal,
                    name: nameController.text.trim(),
                    desc: descController.text.trim(),
                    categoryId: _selectedCategoryTabProductPrice,
                  );

                  if (success) {
                    _loadDbProductPrices(); // Reload
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Product details updated successfully!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update details.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final originalPriceController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Add New Product Item',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Active Price (Rs.)',
                      prefixText: 'Rs. ',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      if (int.tryParse(value) == null) return 'Must be a number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: originalPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Original Price (Rs.)',
                      prefixText: 'Rs. ',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      if (int.tryParse(value) == null) return 'Must be a number';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newPrice = int.parse(priceController.text.trim());
                  final newOriginal = int.parse(originalPriceController.text.trim());
                  
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Adding new product item...'),
                      duration: Duration(seconds: 1),
                    ),
                  );

                  final uniqueId = "product_custom_${DateTime.now().millisecondsSinceEpoch}";

                  final success = await ProductPriceService.updatePrice(
                    id: uniqueId,
                    price: newPrice,
                    originalPrice: newOriginal,
                    name: nameController.text.trim(),
                    desc: descController.text.trim(),
                    categoryId: _selectedCategoryTabProductPrice,
                  );

                  if (success) {
                    _loadDbProductPrices(); // Reload
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Product item added successfully!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add product item.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Technician Vetting and Management Flow
  Future<void> _loadTechnicians() async {
    setState(() {
      _isLoadingTechnicians = true;
    });
    try {
      final list = await UserAuthService.fetchActiveTechnicians();
      setState(() {
        _activeTechnicians = list;
      });
    } catch (e) {
      debugPrint("Error loading technicians: $e");
    } finally {
      setState(() {
        _isLoadingTechnicians = false;
      });
    }
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

  Widget _buildAssignDropdown(BookingModel booking) {
    return PopupMenuButton<String>(
      tooltip: 'Assign Technician',
      icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary, size: 20),
      onSelected: (workerName) async {
        final success = await BookingRepository().assignWorker(booking.id, workerName);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Assigned to $workerName'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      },
      itemBuilder: (context) {
        if (_activeTechnicians.isEmpty) {
          return [
            const PopupMenuItem<String>(
              enabled: false,
              value: '',
              child: Text('No active technicians. Create one first!'),
            ),
          ];
        }
        return _activeTechnicians.map((tech) {
          final String name = tech['fullName'] ?? 'Unknown';
          final String spec = tech['specialty'] ?? '';
          return PopupMenuItem<String>(
            value: '$name (${tech['phone'] ?? "No Phone"})',
            child: Row(
              children: [
                const Icon(Icons.engineering_outlined, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text('$name (${spec.isNotEmpty ? spec : "General"})'),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildTechniciansView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTechnicianDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Technician'),
      ),
      body: _isLoadingTechnicians
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadTechnicians,
              color: AppColors.primary,
              child: _activeTechnicians.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.engineering_rounded, color: AppColors.primary, size: 60),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No Technicians Registered',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add worker profiles to assign service jobs.',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _showAddTechnicianDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Create Technician'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 136,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _activeTechnicians.length,
                        itemBuilder: (context, index) {
                          final tech = _activeTechnicians[index];
                          final id = tech['id'] as int?;
                          final name = tech['fullName'] ?? '';
                          final email = tech['email'] ?? '';
                          final phone = tech['phone'] ?? '';
                          final spec = tech['specialty'] ?? 'General';

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.engineering_rounded, color: AppColors.primary, size: 32),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name,
                                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.08),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              spec,
                                              style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.phone_outlined, size: 14, color: Colors.grey.shade500),
                                          const SizedBox(width: 6),
                                          Text(phone, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.mail_outline_rounded, size: 14, color: Colors.grey.shade500),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              email,
                                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (id != null)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                                    onPressed: () => _confirmDeleteTechnician(id, name),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
    );
  }

  void _confirmDeleteTechnician(int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Technician?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to remove technician $name? They will not be able to log in or handle bookings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade500)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await UserAuthService.deleteTechnician(id);
              if (success) {
                _loadTechnicians();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Technician removed successfully!'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddTechnicianDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedSpec = 'AC Specialist';

    final specialtiesList = [
      'AC Specialist',
      'Electrician',
      'Solar Expert',
      'Washing Machine Tech',
      'Refrigerator Tech',
      'Plumber',
      'Carpenter',
      'General Technician'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Row(
                children: [
                  Icon(Icons.engineering_rounded, color: AppColors.primary),
                  SizedBox(width: 10),
                  Text('Add New Technician', style: TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Usman Ali',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter full name' : null,
                      ),
                      const SizedBox(height: 14),
                      const Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'e.g. usman@gmail.com',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 14),
                      const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'e.g. 03001234567',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter phone number' : null,
                      ),
                      const SizedBox(height: 14),
                      const Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Min 6 characters',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
                      ),
                      const SizedBox(height: 14),
                      const Text('Specialty Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSpec,
                            isExpanded: true,
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() {
                                  selectedSpec = val;
                                });
                              }
                            },
                            items: specialtiesList.map((s) {
                              return DropdownMenuItem<String>(
                                value: s,
                                child: Text(s),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey.shade500)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      final result = await UserAuthService.createTechnician(
                        fullName: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phone: phoneController.text.trim(),
                        password: passwordController.text,
                        specialty: selectedSpec,
                      );

                      if (result['success'] == true) {
                        _loadTechnicians();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Technician registered successfully!'), backgroundColor: Colors.green),
                          );
                        }
                      } else {
                        if (mounted) {
                          final errMsg = result['message'] ?? 'Failed to create technician account.';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errMsg), backgroundColor: Colors.red),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Register'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

