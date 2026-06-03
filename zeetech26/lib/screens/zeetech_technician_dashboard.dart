import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';
import '../models/booking_model.dart';
import '../services/booking_repository.dart';
import '../services/user_auth_service.dart';
import '../services/api_config.dart';

class ZeetechTechnicianDashboard extends StatefulWidget {
  final VoidCallback onLogout;

  const ZeetechTechnicianDashboard({super.key, required this.onLogout});

  @override
  State<ZeetechTechnicianDashboard> createState() => _ZeetechTechnicianDashboardState();
}

class _ZeetechTechnicianDashboardState extends State<ZeetechTechnicianDashboard> {
  Map<String, dynamic>? _techDetails;
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String _selectedTab = 'Active'; // 'Active', 'Completed'

  @override
  void initState() {
    super.initState();
    _loadSessionAndData();
  }

  Future<void> _loadSessionAndData() async {
    setState(() {
      _isLoading = true;
    });
    final details = await UserAuthService.getCurrentUserDetails();
    setState(() {
      _techDetails = details;
    });
    await _refreshBookings();
  }

  Future<void> _refreshBookings() async {
    if (_techDetails == null) return;
    
    setState(() {
      _isLoading = true;
    });
    try {
      final String fullName = _techDetails!['fullName'] ?? 'Unknown';
      final String phone = _techDetails!['phone'] ?? '';
      final String queryName = '$fullName ($phone)';
      
      final list = await BookingRepository().fetchAssignedBookings(queryName);
      setState(() {
        _bookings = list;
      });
    } catch (e) {
      debugPrint("Error loading technician bookings: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    final name = _techDetails?['fullName'] ?? 'Worker';
    final spec = _techDetails?['specialty'] ?? 'General Specialty';
    
    // Filters based on tab
    final filteredList = _bookings.where((b) {
      if (_selectedTab == 'Active') {
        return b.status == 'Assigned' || b.status == 'In Progress';
      } else {
        return b.status == 'Completed';
      }
    }).toList();

    final pendingCount = _bookings.where((b) => b.status == 'Assigned' || b.status == 'In Progress').length;
    final completedCount = _bookings.where((b) => b.status == 'Completed').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // 🌟 Header Profile Card (Aesthetic Slate Neutral with Gold Details)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: AppGradients.header,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Double ringed avatar matching the profile page
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.secondary, AppColors.primary],
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.darkBg,
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.white10,
                            child: Icon(Icons.engineering_rounded, color: Colors.white, size: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                              ),
                              child: Text(
                                spec,
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout_rounded, color: Colors.white),
                        tooltip: 'Logout',
                        onPressed: () async {
                          await UserAuthService.logoutUser();
                          widget.onLogout();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Dashboard quick stat metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickStatCard('Pending Work', pendingCount.toString(), Colors.orange),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickStatCard('Completed Jobs', completedCount.toString(), Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🌟 Selected tab filter tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFilterTabButton('Active', _selectedTab == 'Active', pendingCount),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFilterTabButton('Completed', _selectedTab == 'Completed', completedCount),
                  ),
                ],
              ),
            ),

            // 🌟 Tasks List View
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : RefreshIndicator(
                      onRefresh: _refreshBookings,
                      color: AppColors.primary,
                      child: filteredList.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                                Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _selectedTab == 'Active' ? Icons.assignment_turned_in_rounded : Icons.check_circle_outline_rounded,
                                          color: Colors.grey.shade400,
                                          size: 56,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        _selectedTab == 'Active' ? 'All caught up!' : 'No completed jobs yet',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _selectedTab == 'Active' ? 'No active service jobs assigned to you.' : 'Your finished requests will appear here.',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return _buildJobCard(filteredList[index]);
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabButton(String label, bool isSelected, int count) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.grey.shade700,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(BookingModel job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  job.serviceName,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (job.status == 'In Progress' ? Colors.blue : (job.status == 'Completed' ? Colors.green : Colors.orange)).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  job.status,
                  style: TextStyle(
                    color: job.status == 'In Progress' ? Colors.blue : (job.status == 'Completed' ? Colors.green : Colors.orange),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          
          // Customer details
          _buildInfoField(Icons.person_outline_rounded, 'Client', job.customerName),
          const SizedBox(height: 8),
          _buildInfoField(Icons.phone_outlined, 'Contact', job.customerPhone),
          const SizedBox(height: 8),
          _buildInfoField(Icons.place_outlined, 'Address', job.customerAddress),
          const SizedBox(height: 8),
          _buildInfoField(Icons.calendar_today_outlined, 'Scheduled Slot', '${job.preferredDate} | ${job.preferredTime}'),
          
          if (job.message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Text(
                'Notes: ${job.message}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.3),
              ),
            ),
          ],

          if (job.problemImagePath.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: job.problemImagePath.startsWith('http') || job.problemImagePath.startsWith('/uploads')
                  ? Image.network(
                      job.problemImagePath.startsWith('http') ? job.problemImagePath : '${ApiConfig.backendUrl}${job.problemImagePath}',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                  : Image.file(
                      File(job.problemImagePath),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
            ),
          ],

          if (job.startedAt != null && job.startedAt!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.play_circle_outline_rounded, size: 14, color: Colors.blue),
                const SizedBox(width: 6),
                Text(
                  'Job Started: ${_formatDateTime(job.startedAt!)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],

          if (job.completedAt != null && job.completedAt!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 14, color: Colors.green),
                const SizedBox(width: 6),
                Text(
                  'Completed: ${_formatDateTime(job.completedAt!)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],

          if (job.workSummary != null && job.workSummary!.isNotEmpty) ...[
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
                'My Completion Summary: ${job.workSummary}',
                style: const TextStyle(fontSize: 11, color: Colors.green, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Action row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 📞 Direct Call Button
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), shape: BoxShape.circle),
                      child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 18),
                    ),
                    tooltip: 'Call Customer',
                    onPressed: () => _launchUrl('tel:${job.customerPhone}'),
                  ),
                  const SizedBox(width: 8),
                  // 💬 Direct WhatsApp Communication
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.08), shape: BoxShape.circle),
                      child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.green, size: 18),
                    ),
                    tooltip: 'WhatsApp Customer',
                    onPressed: () {
                      final cleanPhone = job.customerPhone.replaceAll(RegExp(r'[^\d]'), '');
                      final workerName = _techDetails?['fullName'] ?? 'Worker';
                      final templateText = 'Hello ${job.customerName}, I am $workerName from ZeeTech. I have been assigned to your ${job.serviceName} booking. I am on my way to your address.';
                      _launchUrl('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(templateText)}');
                    },
                  ),
                  const SizedBox(width: 8),
                  // 📍 Maps Navigation Address
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.08), shape: BoxShape.circle),
                      child: const Icon(Icons.near_me_outlined, color: Colors.orange, size: 18),
                    ),
                    tooltip: 'Navigate via Google Maps',
                    onPressed: () {
                      final addressEncoded = Uri.encodeComponent(job.customerAddress);
                      _launchUrl('https://www.google.com/maps/search/?api=1&query=$addressEncoded');
                    },
                  ),
                ],
              ),
              if (job.status == 'Assigned') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => _startJob(job.id),
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('Start Job', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
              if (job.status == 'In Progress') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => _showCompletionDialog(job.id),
                    icon: const Icon(Icons.done_all_rounded, size: 20),
                    label: const Text('Complete Job', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(IconData icon, String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textDark, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Future<void> _startJob(String id) async {
    final success = await BookingRepository().startWork(id);
    if (success) {
      await _refreshBookings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job started successfully! Stay safe.'), backgroundColor: Colors.blue),
        );
      }
    }
  }

  void _showCompletionDialog(String id) {
    final remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              SizedBox(width: 8),
              Text('Mark Job Completed', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Provide details of the service work completed:',
                style: TextStyle(fontSize: 13, color: AppColors.textGray),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Cleared AC filters, refilled R32 refrigerant gas, and checked wiring.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade500)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final summary = remarksController.text.trim();
                final success = await BookingRepository().completeWork(id, summary.isNotEmpty ? summary : "Completed successfully");
                if (success) {
                  await _refreshBookings();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Job completed successfully! Outstanding work.'), backgroundColor: Colors.green),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Complete'),
            ),
          ],
        );
      },
    );
  }
}
