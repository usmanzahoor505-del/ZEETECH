import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/theme.dart';
import '../services/cart_service.dart';
import '../services/booking_repository.dart';
import '../services/user_auth_service.dart';
import '../models/booking_model.dart';
import '../services/upload_service.dart';
import '../services/api_config.dart';

class ZeetechCheckoutScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;

  const ZeetechCheckoutScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ZeetechCheckoutScreen> createState() => _ZeetechCheckoutScreenState();
}

class _ZeetechCheckoutScreenState extends State<ZeetechCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isLoading = false;
  String _paymentMethod = 'Cash on Service'; // Default Cash on Service
  String? _problemImagePath;
  final TextEditingController _tidController = TextEditingController();
  String? _paymentReceiptPath;
  String? _copiedValue;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    // Default scheduled date to tomorrow
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _dateController.text = "${tomorrow.day}/${tomorrow.month}/${tomorrow.year}";
    _timeController.text = "11:00 AM - 01:00 PM";
  }

  Future<void> _loadUserDetails() async {
    final details = await UserAuthService.getCurrentUserDetails();
    final email = await UserAuthService.getCurrentUser();
    if (details != null) {
      setState(() {
        _nameController.text = details['fullName'] ?? '';
        _phoneController.text = details['phone'] ?? '';
        _emailController.text = details['email'] ?? email ?? '';
      });
    } else if (email != null) {
      setState(() {
        _emailController.text = email;
        _nameController.text = email.split('@')[0];
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _tidController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
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

  void _showTimeSlots() {
    final slots = [
      "09:00 AM - 11:00 AM",
      "11:00 AM - 01:00 PM",
      "01:00 PM - 03:00 PM",
      "03:00 PM - 05:00 PM",
      "05:00 PM - 07:00 PM"
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Preferred Time Slot',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: slots.map((slot) {
                    final isSelected = _timeController.text == slot;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _timeController.text = slot;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.textDark,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handlePlaceOrder() async {
    if (CartService().items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty! Please add services.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 1. Build structured message detailing the cart
      final subServicesText = CartService().items.map(
        (item) => "- ${item.name} x${item.quantity} (Rs. ${item.price})"
      ).join("\n");

      final String bookingId = "BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}";

      final String fullMessage = """
Selected services from Cart:
$subServicesText

Payment Method: $_paymentMethod
Booking total value: Rs. ${CartService().totalPrice}
Convenience fee: Rs. 50
Grand Total: Rs. ${CartService().totalPrice + 50}

Preferred Schedule: ${_dateController.text} at ${_timeController.text}
      """.trim();

      // Category Name matches the first item in cart (e.g. AC Services)
      final String categoryName = CartService().items.first.categoryName;

      // Upload problem image first if picked
      String finalImagePath = '';
      if (_problemImagePath != null && _problemImagePath!.isNotEmpty) {
        final String? uploadedUrl = await UploadService.uploadImage(_problemImagePath!);
        if (uploadedUrl != null) {
          finalImagePath = uploadedUrl;
        } else {
          finalImagePath = _problemImagePath!;
        }
      }

      // Upload payment receipt first if picked
      String finalReceiptPath = '';
      if (_paymentReceiptPath != null && _paymentReceiptPath!.isNotEmpty) {
        final String? uploadedUrl = await UploadService.uploadImage(_paymentReceiptPath!);
        if (uploadedUrl != null) {
          finalReceiptPath = uploadedUrl;
        } else {
          finalReceiptPath = _paymentReceiptPath!;
        }
      }

      String paymentDetailsText = "";
      if (_paymentMethod != 'Cash on Service') {
        paymentDetailsText = "\n\nPayment Details:\n- Transaction ID (TID): ${_tidController.text.trim()}\n- Receipt Proof: $finalReceiptPath";
      }

      final String updatedFullMessage = """
$fullMessage
$paymentDetailsText
""".trim();

      final newBooking = BookingModel(
        id: bookingId,
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        customerEmail: _emailController.text.trim(),
        customerAddress: _addressController.text.trim(),
        serviceName: categoryName,
        message: updatedFullMessage,
        status: 'Pending',
        createdAt: DateTime.now(),
        preferredDate: _dateController.text,
        preferredTime: _timeController.text,
        problemImagePath: finalImagePath,
      );

      final success = await BookingRepository().addBooking(newBooking);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        CartService().clearCart();
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Booking Placed!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your service request has been registered as pending. Track status in your bookings tab.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.4),
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      widget.onNavigate('orders'); // Jump to orders history screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Go to My Bookings', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit booking. Check backend connection.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all address & details.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => widget.onNavigate('services'),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1.2,
          ),
        ),
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: cart.cartNotifier,
        builder: (context, cartItems, child) {
          if (cartItems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    const Text(
                      'No items in checkout',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add services to your cart to proceed with checkout.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textGray),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => widget.onNavigate('services'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Explore Services', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          }

          final int itemsPrice = cart.totalPrice;
          final int convenienceFee = 50;
          final int grandTotal = itemsPrice + convenienceFee;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                64 + MediaQuery.of(context).padding.bottom + 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Service Address & Customer Details Card
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Service Address & Details',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Your Full Name',
                              labelStyle: const TextStyle(fontSize: 13),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Contact Phone Number',
                              labelStyle: const TextStyle(fontSize: 13),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Phone is required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _addressController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'Exact Street Address / Flat / Floor',
                              labelStyle: const TextStyle(fontSize: 13),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Address is required' : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Schedule Card
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Select Preferred Schedule',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _dateController.text.isEmpty ? 'Pick Date' : _dateController.text,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                                        ),
                                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: _showTimeSlots,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _timeController.text.isEmpty ? 'Pick Time' : _timeController.text,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Cart Items Summary Card (with Qty counter)
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined, color: AppColors.primary, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Booking Cart Items',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartItems.length,
                            separatorBuilder: (context, index) => const Divider(height: 20),
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Row(
                                children: [
                                  // Bullet / Category Icon
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.build_outlined, size: 16, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.categoryName,
                                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Rs. ${item.price * item.quantity}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                                      ),
                                      const SizedBox(height: 4),
                                      // Plus-Minus Counter
                                      Container(
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => cart.removeFromCart(item.serviceId, item.name),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Text('-', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                              ),
                                            ),
                                            Text(
                                              '${item.quantity}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark),
                                            ),
                                            GestureDetector(
                                              onTap: () => cart.addToCart(item.serviceId, item.categoryName, item.name, item.price),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Text('+', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Problem Image Selector Card (Optional)
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.photo_camera_rounded, color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Upload Problem Picture (Optional)',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
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
                                        color: Colors.grey.shade200,
                                        width: 1.5,
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4.5 Payment Method Selector Card
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.payment_rounded, color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Select Payment Method',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Column(
                            children: [
                              _buildPaymentMethodOption(
                                method: 'Bank Transfer',
                                icon: Icons.account_balance_rounded,
                                subtitle: 'Transfer to ZeeTech bank account',
                              ),
                              const SizedBox(height: 10),
                              _buildPaymentMethodOption(
                                method: 'Easypaisa',
                                icon: Icons.pix_rounded,
                                subtitle: 'Pay via Easypaisa Mobile Wallet',
                              ),
                              const SizedBox(height: 10),
                              _buildPaymentMethodOption(
                                method: 'JazzCash',
                                icon: Icons.wallet_rounded,
                                subtitle: 'Pay via JazzCash Mobile Wallet',
                              ),
                              const SizedBox(height: 10),
                              _buildPaymentMethodOption(
                                method: 'Cash on Service',
                                icon: Icons.payments_rounded,
                                subtitle: 'Pay in cash after the service is completed',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Bill Details Card
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bill Details',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Cart Total', style: TextStyle(fontSize: 13, color: AppColors.textGray)),
                              Text('Rs. $itemsPrice', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Convenience & Visit Fee', style: TextStyle(fontSize: 13, color: AppColors.textGray)),
                              Text('Rs. $convenienceFee', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discount Credit', style: TextStyle(fontSize: 13, color: AppColors.textGray)),
                              Text('Rs. 0', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green)),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount Payable', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              Text('Rs. $grandTotal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 6. Checkout action button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _handlePlaceOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'PLACE ORDER (Rs. $grandTotal)',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required String method,
    required IconData icon,
    required String subtitle,
  }) {
    final isSelected = _paymentMethod == method;
    return InkWell(
      onTap: () {
        setState(() {
          _paymentMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.grey.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.primary : AppColors.textGray,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? AppColors.primary : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? AppColors.textGray.withOpacity(0.8) : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: method,
                  groupValue: _paymentMethod,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _paymentMethod = val;
                      });
                    }
                  },
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isSelected && method != 'Cash on Service'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 24, thickness: 0.8),
                        _buildExpandedPaymentDetails(method),
                      ],
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedPaymentDetails(String method) {
    String accountTitle = 'ZEETECH Technical Services';
    String accountNumber = '';
    String bankName = '';
    String instructions = '';

    if (method == 'Bank Transfer') {
      bankName = 'Bank Alfalah Limited';
      accountNumber = '0123-100789456';
      instructions = 'Please transfer the grand total to our company bank account and upload your receipt screenshot with Transaction ID.';
    } else if (method == 'Easypaisa') {
      bankName = 'Easypaisa Wallet';
      accountNumber = '0300-5518622';
      instructions = 'Please transfer the grand total to our Easypaisa merchant wallet and upload your receipt screenshot with Transaction ID.';
    } else if (method == 'JazzCash') {
      bankName = 'JazzCash Wallet';
      accountNumber = '0300-5518622';
      instructions = 'Please transfer the grand total to our JazzCash merchant wallet and upload your receipt screenshot with Transaction ID.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transfer Credentials:',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 0.8),
          ),
          child: Column(
            children: [
              _buildAccountDetailRow('Title', accountTitle),
              const Divider(height: 16),
              _buildAccountDetailRow('Account No', accountNumber),
              const Divider(height: 16),
              _buildAccountDetailRow('Network/Bank', bankName),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          instructions,
          style: TextStyle(fontSize: 10.5, color: AppColors.textGray.withOpacity(0.85), height: 1.4),
        ),
        const SizedBox(height: 14),
        const Text(
          'Enter Transaction ID (TID) *',
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _tidController,
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: 'Enter 11 or 12 digit TID code',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            prefixIcon: const Icon(Icons.pin_rounded, color: Colors.grey, size: 16),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (val) {
            if (_paymentMethod != 'Cash on Service' && (val == null || val.trim().isEmpty)) {
              return 'Please enter Transaction ID';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        const Text(
          'Upload Receipt Screenshot *',
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showImagePickerOptions(isReceipt: true),
          borderRadius: BorderRadius.circular(12),
          child: _paymentReceiptPath == null
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_rounded, color: AppColors.primary, size: 28),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload Receipt Proof (Screenshot)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Max size 5MB (JPG, PNG)',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_paymentReceiptPath!),
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _paymentReceiptPath!.split('/').last,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ready to upload',
                              style: TextStyle(fontSize: 10, color: Colors.green.shade600, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          setState(() {
                            _paymentReceiptPath = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAccountDetailRow(String label, String value) {
    final isCopied = _copiedValue == value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.5, color: AppColors.textGray.withOpacity(0.8), fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                setState(() {
                  _copiedValue = value;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted && _copiedValue == value) {
                    setState(() {
                      _copiedValue = null;
                    });
                  }
                });
              },
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 15),
                secondChild: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 15),
                crossFadeState: isCopied ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
            ),
          ],
        ),
      ],
    );
  }


  Future<void> _pickImage(ImageSource source, {bool isReceipt = false}) async {
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
          if (isReceipt) {
            _paymentReceiptPath = image.path;
          } else {
            _problemImagePath = image.path;
          }
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

  void _showImagePickerOptions({bool isReceipt = false}) {
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
                  _pickImage(ImageSource.gallery, isReceipt: isReceipt);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isReceipt: isReceipt);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
