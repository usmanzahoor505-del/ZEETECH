import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/theme.dart';
import '../services/api_config.dart';
import '../services/user_auth_service.dart';
import '../models/corporate_inquiry_model.dart';
import '../services/corporate_inquiry_service.dart';

class ZeetechBusinessScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;

  const ZeetechBusinessScreen({super.key, required this.onNavigate});

  @override
  State<ZeetechBusinessScreen> createState() => _ZeetechBusinessScreenState();
}

class _ZeetechBusinessScreenState extends State<ZeetechBusinessScreen> {
  String? _selectedCategory; // Null shows grid, non-null shows form
  String? _selectedCity; // Selected city from dropdown
  bool _isSubmitting = false; // Loading indicator flag for submissions

  bool _showingUserInquiries = false; // True shows the user's submitted inquiries
  List<CorporateInquiryModel> _userInquiries = [];
  bool _loadingUserInquiries = false;

  static const List<String> _pakistanCities = [
    'Karachi',
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Gujranwala',
    'Hyderabad',
    'Sargodha',
    'Bahawalpur',
    'Sukkur',
    'Larkana',
    'Sheikhupura',
    'Mirpur',
    'Gujrat',
    'Jhelum',
    'Mardan',
  ];

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _repNameController = TextEditingController();
  final TextEditingController _repNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _repNameController.dispose();
    _repNumberController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  static const List<Map<String, dynamic>> _businessCategories = [
    {
      'id': 'office',
      'icon': Icons.corporate_fare_rounded,
      'color': Color(0xFF1E88E5), // Premium Blue
      'name': 'Corporate Office',
    },
    {
      'id': 'restaurant',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFFB8C00), // Premium Orange
      'name': 'Restaurants',
    },
    {
      'id': 'school',
      'icon': Icons.school_rounded,
      'color': Color(0xFF3949AB), // Premium Indigo
      'name': 'Colleges & Schools',
    },
    {
      'id': 'housing',
      'icon': Icons.home_work_rounded,
      'color': Color(0xFF43A047), // Premium Green
      'name': 'Housing Society',
    },
    {
      'id': 'warehouse',
      'icon': Icons.warehouse_rounded,
      'color': Color(0xFFFFB300), // Premium Amber
      'name': 'Warehouse',
    },
    {
      'id': 'bpo',
      'icon': Icons.headset_mic_rounded,
      'color': Color(0xFF8E24AA), // Premium Purple
      'name': 'BPO Center',
    },
    {
      'id': 'supermarket',
      'icon': Icons.local_grocery_store_rounded,
      'color': Color(0xFF00ACC1), // Premium Cyan/Teal
      'name': 'Supermarket',
    },
    {
      'id': 'software',
      'icon': Icons.developer_mode_rounded,
      'color': Color(0xFF039BE5), // Light Blue
      'name': 'Software House',
    },
    {
      'id': 'others',
      'icon': Icons.zoom_in_rounded,
      'color': Color(0xFF757575), // Grey
      'name': 'Others',
    },
  ];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.backendUrl}/api/corporate-inquiries'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'businessType': _selectedCategory,
            'businessName': _businessNameController.text.trim(),
            'repName': _repNameController.text.trim(),
            'repNumber': _repNumberController.text.trim(),
            'email': _emailController.text.trim(),
            'city': _selectedCity,
            'message': _messageController.text.trim(),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Corporate inquiry for "${_businessNameController.text}" submitted successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );

          // Clear controllers
          _businessNameController.clear();
          _repNameController.clear();
          _repNumberController.clear();
          _emailController.clear();
          _cityController.clear();
          _messageController.clear();

          // Navigate back to grid
          setState(() {
            _selectedCategory = null;
            _selectedCity = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit corporate inquiry. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildFormView(String categoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom App Bar for Form matching screenshot header style
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
              ),
              const SizedBox(width: 8),
              Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Scrollable Form
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                // Business Type Row matching screenshot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Business Type',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Business Name*
                _buildFormLabel('Business Name*'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _businessNameController,
                  decoration: _buildInputDecoration('Enter business name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Business Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Representative Name*
                _buildFormLabel('Representative Name*'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _repNameController,
                  decoration: _buildInputDecoration('Full Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Representative Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Representative Number*
                _buildFormLabel('Representative Number*'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _repNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration('Phone Number'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Representative Number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Email
                _buildFormLabel('Email'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration('example@email.com'),
                ),
                const SizedBox(height: 18),

                 // City*
                _buildFormLabel('City*'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: _buildInputDecoration('Select City'),
                  items: _pakistanCities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(
                        city,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                      _cityController.text = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(height: 18),

                // Message
                _buildFormLabel('Message'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: _buildInputDecoration('Message Here'),
                ),
                const SizedBox(height: 28),

                // Submit Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit Inquiry',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormLabel(String labelText) {
    return Text(
      labelText,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }

  Widget _buildGridView() {
    return Column(
      children: [
        _buildHeaderRow(),
        const Divider(height: 1),

        // Main Content Area
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const Text(
                'Select Your Business Below',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),

              // 3x3 Grid Layout
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _businessCategories.length,
                itemBuilder: (context, index) {
                  final category = _businessCategories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category['name'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.025),
                            blurRadius: 10,
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
                              color: category['color'].withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              category['icon'],
                              color: category['color'],
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              category['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
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
      case 'Approved':
      case 'In Progress':
        return Icons.check_circle_outline;
      case 'Completed':
        return Icons.check_circle_outline;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outlined;
    }
  }

  Future<void> _loadUserInquiries() async {
    setState(() {
      _showingUserInquiries = true;
      _loadingUserInquiries = true;
    });

    try {
      final details = await UserAuthService.getCurrentUserDetails();
      final userEmail = details?['email'] ?? '';
      final userPhone = details?['phone'] ?? '';

      final list = await CorporateInquiryService.fetchInquiries(
        email: userEmail,
        repNumber: userPhone,
      );

      setState(() {
        _userInquiries = list;
      });
    } catch (e) {
      debugPrint("Error loading user inquiries: $e");
    } finally {
      setState(() {
        _loadingUserInquiries = false;
      });
    }
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
            onPressed: () {
              if (_showingUserInquiries) {
                setState(() {
                  _showingUserInquiries = false;
                });
              } else {
                widget.onNavigate('home');
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _showingUserInquiries ? 'My Business Inquiries' : 'ZEETECH For Business',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (!_showingUserInquiries && _selectedCategory == null)
            TextButton.icon(
              onPressed: _loadUserInquiries,
              icon: const Icon(Icons.history_rounded, size: 16, color: AppColors.primary),
              label: const Text(
                'My Inquiries',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.15)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInquiriesView() {
    if (_loadingUserInquiries) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_userInquiries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.business_center_outlined, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text(
                'No Corporate Inquiries Found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Submit inquiries using the categories below to see them tracked here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showingUserInquiries = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Back to Categories'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUserInquiries,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: _userInquiries.length,
        itemBuilder: (context, index) {
          final inquiry = _userInquiries[index];
          final statusColor = _getStatusColor(inquiry.status);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              inquiry.businessType,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_getStatusIcon(inquiry.status), color: statusColor, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              inquiry.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, size: 14, color: Colors.grey.shade400),
                      const SizedBox(width: 6),
                      Text(
                        inquiry.city,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  if (inquiry.message.isNotEmpty) ...[
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
                        inquiry.message,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Submitted: ${inquiry.createdAt.day}-${inquiry.createdAt.month}-${inquiry.createdAt.year}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _showingUserInquiries
            ? Column(
                children: [
                  _buildHeaderRow(),
                  const Divider(height: 1),
                  Expanded(child: _buildUserInquiriesView()),
                ],
              )
            : _selectedCategory == null 
                ? _buildGridView() 
                : _buildFormView(_selectedCategory!),
      ),
    );
  }
}
