import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../models/membership_application_model.dart';
import '../services/membership_application_service.dart';

class MembershipFormScreen extends StatefulWidget {
  final String category; // 'Domestic' or 'Commercial'
  final String planName; // 'Silver', 'Gold', 'Premium'
  final String discount; // '10%', '20%', '30%'
  final String validity; // '3 Months', '6 Months', '1 Year'

  const MembershipFormScreen({
    super.key,
    required this.category,
    required this.planName,
    required this.discount,
    required this.validity,
  });

  @override
  State<MembershipFormScreen> createState() => _MembershipFormScreenState();
}

class _MembershipFormScreenState extends State<MembershipFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Applicant Information
  final _fullNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();

  // Contact Information
  final _mobileController = TextEditingController();
  final _altContactController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  // Membership Detail
  final _preferredServicesController = TextEditingController();

  bool _declarationAccepted = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _cnicController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    _mobileController.dispose();
    _altContactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _preferredServicesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_declarationAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the declaration to submit.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final application = MembershipApplicationModel(
      category: widget.category,
      planName: widget.planName,
      discount: widget.discount,
      validity: widget.validity,
      createdAt: DateTime.now(),
      fullName: _fullNameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      cnic: _cnicController.text.trim(),
      dob: _dobController.text.trim(),
      occupation: _occupationController.text.trim(),
      mobile: _mobileController.text.trim(),
      altContact: _altContactController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      preferredServices: _preferredServicesController.text.trim(),
    );

    final errorMessage = await MembershipApplicationService.submitApplication(application);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (errorMessage == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membership application submitted successfully!'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Registration Error',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
              ),
            ],
          ),
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textDark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String today =
        '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}';

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
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
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Membership Registration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ZEETECH 26 (PVT) LTD',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Plan badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getPlanColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getPlanColor().withOpacity(0.3)),
                  ),
                  child: Text(
                    '${widget.planName} • ${widget.discount} OFF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getPlanColor(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scrollable Form
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // ── Auto-selected Membership Info ──
                  _buildSectionHeader('Membership Detail', Icons.card_membership_rounded),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildReadOnlyField(
                          label: 'Category',
                          value: widget.category,
                          icon: Icons.category_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildReadOnlyField(
                          label: 'Plan',
                          value: widget.planName,
                          icon: _getPlanIcon(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildReadOnlyField(
                          label: 'Duration',
                          value: widget.validity,
                          icon: Icons.schedule_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildReadOnlyField(
                          label: 'Date',
                          value: today,
                          icon: Icons.calendar_today_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Applicant Information ──
                  _buildSectionHeader('Applicant Information', Icons.person_rounded),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    icon: Icons.person_outline_rounded,
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _fatherNameController,
                    label: "Father's / Spouse's Name",
                    icon: Icons.people_outline_rounded,
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _cnicController,
                    label: 'CNIC / Passport No.',
                    icon: Icons.badge_rounded,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: _dobController,
                        label: 'Date of Birth',
                        icon: Icons.cake_rounded,
                        required: true,
                        hint: 'Tap to select',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _occupationController,
                    label: 'Occupation / Organization',
                    icon: Icons.work_outline_rounded,
                  ),
                  const SizedBox(height: 24),

                  // ── Contact Information ──
                  _buildSectionHeader('Contact Information', Icons.phone_rounded),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    icon: Icons.phone_android_rounded,
                    keyboardType: TextInputType.phone,
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _altContactController,
                    label: 'Alternate Contact Number',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Residential / Office Address',
                    icon: Icons.location_on_outlined,
                    maxLines: 2,
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _preferredServicesController,
                    label: 'Preferred Services (if any)',
                    icon: Icons.checklist_rounded,
                    maxLines: 2,
                    hint: 'e.g. AC, Solar, CCTV...',
                  ),
                  const SizedBox(height: 24),

                  // ── Declaration ──
                  _buildSectionHeader('Declaration by Applicant', Icons.verified_user_rounded),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _declarationAccepted
                            ? AppColors.primary.withOpacity(0.4)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I hereby declare that the information provided in this membership application is true and correct to the best of my knowledge. I understand and agree that membership approval shall remain subject to verification and acceptance by ZEETECH26 (Pvt.) Ltd.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'I further acknowledge that the membership discount shall apply only to eligible services provided directly by ZEETECH26 (Pvt.) Ltd. and shall remain subject to the company\'s official policies, revisions, and service availability.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _declarationAccepted = !_declarationAccepted;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: _declarationAccepted
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _declarationAccepted
                                        ? AppColors.primary
                                        : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                ),
                                child: _declarationAccepted
                                    ? const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'I accept and agree to the terms above',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Submit Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (_declarationAccepted && !_isSubmitting) ? _submitForm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _declarationAccepted
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Submit Application',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper Widgets ──

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.lock_rounded, color: Colors.grey.shade400, size: 14),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        labelStyle: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade500,
        ),
        hintStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
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

  Color _getPlanColor() {
    switch (widget.planName) {
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

  IconData _getPlanIcon() {
    switch (widget.planName) {
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
}
