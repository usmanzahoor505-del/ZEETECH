import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';
import '../models/booking_model.dart';
import '../services/booking_repository.dart';
import '../services/admin_auth_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const AdminDashboardScreen({super.key, this.onLogout});

  @override
  State<AdminDashboardScreen> createState() => _AppAdminDashboardScreenState();
}

class _AppAdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedFilter = 'All'; // 'All', 'Pending', 'In Progress', 'Completed'

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
      case 'Completed':
        return Icons.check_circle_outline;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
                                child: Image.file(
                                  File(booking.problemImagePath),
                                  fit: BoxFit.contain,
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
                          image: FileImage(File(booking.problemImagePath)),
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
}
