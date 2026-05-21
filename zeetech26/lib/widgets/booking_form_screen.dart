import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';
import '../models/booking_model.dart';
import '../services/booking_repository.dart';
import '../services/user_auth_service.dart';

class BookingFormScreen extends StatefulWidget {
  final String serviceName;
  final List<Map<String, dynamic>> selectedSubServices;
  final int totalPrice;
  final String paymentMethod;

  const BookingFormScreen({
    super.key,
    required this.serviceName,
    this.selectedSubServices = const [],
    this.totalPrice = 0,
    this.paymentMethod = 'Cash on Service',
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _serviceController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String? _problemImagePath;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _problemImagePath = image.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image.')),
        );
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _serviceController = TextEditingController(text: widget.serviceName);
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final details = await UserAuthService.getCurrentUserDetails();
    if (details != null) {
      setState(() {
        _nameController.text = details['fullName'] ?? '';
        _phoneController.text = details['phone'] ?? '';
        _emailController.text = details['email'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _messageController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (mounted) {
          _timeController.text = picked.format(context);
        } else {
          _timeController.text = "${picked.hour}:${picked.minute}";
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Build selected sub-services details string
      String subServicesText = "";
      if (widget.selectedSubServices.isNotEmpty) {
        subServicesText = widget.selectedSubServices
            .map((s) => "- ${s['name']} (Rs. ${s['price']})")
            .join("\n");
      }

      // Show Dialog
      final bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.assignment_turned_in_outlined, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Confirm Booking'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you sure you want to book this service?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('Service: ${widget.serviceName}', style: const TextStyle(fontSize: 13)),
                  if (widget.selectedSubServices.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Offers:\n$subServicesText', style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('Total Price: Rs. ${widget.totalPrice}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                  ],
                  const SizedBox(height: 4),
                  Text('Preferred Date: ${_dateController.text}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                  Text('Preferred Time: ${_timeController.text}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 4),
                  Text('Payment Method: ${widget.paymentMethod}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 4),
                  Text('Name: ${_nameController.text}', style: const TextStyle(fontSize: 13)),
                  Text('Phone: ${_phoneController.text}', style: const TextStyle(fontSize: 13)),
                  Text('Address: ${_addressController.text}', style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );

      final String bookingId = DateTime.now().millisecondsSinceEpoch.toString();

      // Create WhatsApp message
      final String message = """
🔧 *New Service Booking Request*

*Service:* ${_serviceController.text}
${widget.selectedSubServices.isNotEmpty ? "*Selected Offers:*\n$subServicesText\n*Total Price:* Rs. ${widget.totalPrice}" : ""}
*Preferred Date:* ${_dateController.text}
*Preferred Time:* ${_timeController.text}
*Payment Method:* ${widget.paymentMethod}
*Name:* ${_nameController.text}
*Phone:* ${_phoneController.text}
*Email:* ${_emailController.text.isEmpty ? "Not provided" : _emailController.text}
*Address:* ${_addressController.text}
*Additional Details:* ${_messageController.text.isEmpty ? "None" : _messageController.text}

Thank you for choosing ZEETECH Technical Services!
      """.trim();

      if (confirm == true) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Save booking details to repository as Pending
        final newBooking = BookingModel(
          id: bookingId,
          customerName: _nameController.text.trim(),
          customerPhone: _phoneController.text.trim(),
          customerEmail: _emailController.text.trim(),
          customerAddress: _addressController.text.trim(),
          serviceName: _serviceController.text,
          message: _messageController.text.trim() + 
              (widget.selectedSubServices.isNotEmpty ? "\nSelected Offers:\n$subServicesText\nTotal Price: Rs. ${widget.totalPrice}\nPayment Method: ${widget.paymentMethod}" : "\nPayment Method: ${widget.paymentMethod}"),
          status: 'Pending',
          createdAt: DateTime.now(),
          preferredDate: _dateController.text,
          preferredTime: _timeController.text,
          problemImagePath: _problemImagePath ?? '',
        );

        final bool success = await BookingRepository().addBooking(newBooking);

        if (mounted) {
          Navigator.of(context).pop(); // Dismiss loader dialog
        }

        if (success) {
          if (mounted) {
            Navigator.pop(context); // Close the bottom sheet
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking Confirmed Successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to confirm booking. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Save booking details to repository as Cancelled
        final newBooking = BookingModel(
          id: bookingId,
          customerName: _nameController.text.trim(),
          customerPhone: _phoneController.text.trim(),
          customerEmail: _emailController.text.trim(),
          customerAddress: _addressController.text.trim(),
          serviceName: _serviceController.text,
          message: _messageController.text.trim() + 
              (widget.selectedSubServices.isNotEmpty ? "\n[ABANDONED/CANCELLED]\nSelected Offers:\n$subServicesText\nTotal Price: Rs. ${widget.totalPrice}\nPayment Method: ${widget.paymentMethod}" : "\n[ABANDONED/CANCELLED]\nPayment Method: ${widget.paymentMethod}"),
          status: 'Cancelled',
          createdAt: DateTime.now(),
          preferredDate: _dateController.text,
          preferredTime: _timeController.text,
          problemImagePath: _problemImagePath ?? '',
        );

        final bool success = await BookingRepository().addBooking(newBooking);

        if (mounted) {
          Navigator.of(context).pop(); // Dismiss loader dialog
        }

        if (mounted) {
          Navigator.pop(context); // Close the bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success 
                  ? 'Booking Cancelled. Saved as Cancelled in Dashboard.' 
                  : 'Failed to record cancelled booking.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add extra padding to handle keyboard overlay on mobile
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 24,
        right: 24,
        bottom: 24 + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pull Handle/Bar
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Book Service',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 20),

              // Service Name Field (Read Only)
              const Text(
                'Service',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _serviceController,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.article_outlined, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Full Name *
              const Text(
                'Full Name *',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone Number *
              const Text(
                'Phone Number *',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '03XX-XXXXXXX',
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email (Optional)
              const Text(
                'Email (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'your@email.com',
                  prefixIcon: const Icon(Icons.mail_outline, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Address/Location *
              const Text(
                'Address/Location *',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your address',
                  prefixIcon: const Icon(Icons.map_outlined, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Date & Time selection Row
              Row(
                children: [
                  // Preferred Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferred Date *',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            hintText: 'Select Date',
                            prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Date is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Preferred Time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferred Time *',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          onTap: () => _selectTime(context),
                          decoration: InputDecoration(
                            hintText: 'Select Time',
                            prefixIcon: const Icon(Icons.access_time_outlined, color: AppColors.primary),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Time is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Upload Problem Picture (Optional)
              const Text(
                'Upload Problem Picture (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: _problemImagePath == null
                    ? Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined, size: 36, color: AppColors.primary),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap to upload picture',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Help us diagnose the problem faster',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: FileImage(File(_problemImagePath!)),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _problemImagePath = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 16),

              // Additional Message (Optional)
              const Text(
                'Additional Message (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Any specific details or requirements...',
                  prefixIcon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              InkWell(
                onTap: _handleSubmit,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done_all, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Book Service Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
}
