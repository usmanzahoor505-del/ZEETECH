import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/user_auth_service.dart';
import '../services/admin_auth_service.dart';
import 'otp_verification_screen.dart';
import '../widgets/zeetech_logo.dart';

class ZeetechUnifiedAuthScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onExploreAsGuest;

  const ZeetechUnifiedAuthScreen({
    super.key, 
    required this.onLoginSuccess,
    required this.onExploreAsGuest,
  });

  @override
  State<ZeetechUnifiedAuthScreen> createState() => _ZeetechUnifiedAuthScreenState();
}

class _ZeetechUnifiedAuthScreenState extends State<ZeetechUnifiedAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Input controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        final emailText = _emailController.text.trim();
        final passwordText = _passwordController.text;

        // 1. Try Admin Login first
        final isAdminSuccess = await AdminAuthService.loginAdmin(emailText, passwordText);
        if (isAdminSuccess) {
          widget.onLoginSuccess();
          return;
        }

        // 2. Try Customer Login
        final isUserSuccess = await UserAuthService.loginUser(emailText, passwordText);
        if (isUserSuccess) {
          widget.onLoginSuccess();
          return;
        }

        // Both failed
        setState(() {
          _errorMessage = 'Invalid email or password.';
        });
      } else {
        // Sign Up Flow (Customer registration only)
        final String emailVal = _emailController.text.trim();
        final String fullNameVal = _fullNameController.text.trim();
        final String phoneVal = _phoneController.text.trim();
        final String passwordVal = _passwordController.text;

        if (emailVal.isEmpty || fullNameVal.isEmpty || phoneVal.isEmpty || passwordVal.isEmpty) {
          setState(() {
            _errorMessage = 'All fields are required for sign up.';
          });
          return;
        }

        final otpResult = await UserAuthService.sendOtp(emailVal);

        if (otpResult['success'] == true) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                  fullName: fullNameVal,
                  email: emailVal,
                  phone: phoneVal,
                  password: passwordVal,
                  onSignupSuccess: () {
                    setState(() {
                      _isLogin = true;
                      _errorMessage = null;
                    });
                    _fullNameController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                    _passwordController.clear();
                  },
                ),
              ),
            );
          }
        } else {
          setState(() {
            _errorMessage = otpResult['message'] ?? 'Failed to send verification email.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred during authentication.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.header,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Branded Square Logo Header matching screenshot
                  const ZeetechLogo(size: 84),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'ZEETECH SERVICES',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isLogin ? 'Sign in to access your account' : 'Register your details to start booking',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 32),

                // Form Card Container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.14)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Auth Toggle Tabs (Sign In / Sign Up)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLogin = true;
                                _errorMessage = null;
                              });
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _isLogin ? primaryColor : Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLogin = false;
                                _errorMessage = null;
                              });
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: !_isLogin ? primaryColor : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 28, color: Colors.white10),

                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Full Name (Only for Sign Up)
                      if (!_isLogin) ...[
                        const Text(
                          'Full Name',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fullNameController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Enter your full name',
                            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            prefixIcon: Icon(Icons.person_outline_rounded, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          validator: (value) {
                            if (!_isLogin && (value == null || value.trim().isEmpty)) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                      ],

                      // Email Field (Used as identifier in both Login & Signup)
                      const Text(
                        'Email / Username',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter email address',
                          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          prefixIcon: Icon(Icons.mail_outline_rounded, color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email or username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Phone Number (Only for Sign Up)
                      if (!_isLogin) ...[
                        const Text(
                          'Phone Number',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'e.g. 03001234567',
                            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            prefixIcon: Icon(Icons.phone_android_outlined, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          validator: (value) {
                            if (!_isLogin && (value == null || value.trim().isEmpty)) {
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                      ],

                      // Password Field
                      const Text(
                        'Password',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.grey.shade500),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey.shade500,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Submit button
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  _isLogin ? 'Sign In' : 'Sign Up',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: widget.onExploreAsGuest,
                          child: const Text(
                            'Explore as Guest',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
      ),
    ),
  );
}
}
