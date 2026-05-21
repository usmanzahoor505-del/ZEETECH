import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/zeetech_home_screen.dart';
import 'screens/zeetech_services_screen.dart';
import 'screens/service_detail_screen.dart';
import 'screens/zeetech_about_screen.dart';
import 'screens/zeetech_contact_screen.dart';
import 'screens/zeetech_account_screen.dart';
import 'screens/zeetech_unified_auth_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'services/user_auth_service.dart';
import 'services/admin_auth_service.dart';
import 'widgets/zeetech_bottom_nav.dart';
import 'widgets/floating_whatsapp_button.dart';
import 'widgets/booking_form_screen.dart';
import 'widgets/feedback_bottom_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZEETECH Technical Services',
      theme: getThemeData(),
      debugShowCheckedModeBanner: false,
      home: const AppEntryScreen(),
    );
  }
}

class AppEntryScreen extends StatefulWidget {
  const AppEntryScreen({super.key});

  @override
  State<AppEntryScreen> createState() => _AppEntryScreenState();
}

class _AppEntryScreenState extends State<AppEntryScreen> {
  String _appState = 'splash'; // 'splash', 'check_session', 'auth', 'main', 'admin'
  String _activeTab = 'home'; // 'home', 'services', 'about', 'contact', 'account', 'service-detail'
  String? _selectedServiceId;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkSession() async {
    setState(() {
      _isGuest = false;
    });

    final isAdmin = await AdminAuthService.isAdminLoggedIn();
    if (isAdmin) {
      setState(() {
        _appState = 'admin';
      });
      return;
    }

    final isUser = await UserAuthService.getCurrentUser();
    if (isUser != null) {
      setState(() {
        _appState = 'main';
        _activeTab = 'home';
      });
      return;
    }

    setState(() {
      _appState = 'auth';
    });
  }

  void _handleNavigate(String screen, {String? serviceId}) {
    setState(() {
      if (screen == 'service-detail' && serviceId != null) {
        _selectedServiceId = serviceId;
        _activeTab = 'service-detail';
      } else {
        _selectedServiceId = null;
        _activeTab = screen;
      }
    });
  }

  void _showSignInRequiredDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_person_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign In Required',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please sign in or create an account to book this service and track your progress.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _appState = 'auth';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Sign In Now'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _openBookingForm({
    String? serviceName,
    List<Map<String, dynamic>>? selectedServices,
    int? totalPrice,
    String? paymentMethod,
  }) {
    if (_isGuest) {
      _showSignInRequiredDialog();
      return;
    }

    final name = serviceName ?? (_selectedServiceId != null 
        ? '${_selectedServiceId!.toUpperCase()} Service' 
        : 'General Service');
        
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingFormScreen(
        serviceName: name,
        selectedSubServices: selectedServices ?? [],
        totalPrice: totalPrice ?? 0,
        paymentMethod: paymentMethod ?? 'Cash on Service',
      ),
    );
  }

  void _openFeedbackSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FeedbackBottomSheet(),
    );
  }

  Widget _renderContent() {
    if (_activeTab == 'service-detail' && _selectedServiceId != null) {
      return ServiceDetailScreen(
        serviceId: _selectedServiceId!,
        onNavigate: (screen) => _handleNavigate(screen),
        onBook: (serviceName, selectedServices, totalPrice, paymentMethod) {
          _openBookingForm(
            serviceName: serviceName,
            selectedServices: selectedServices,
            totalPrice: totalPrice,
            paymentMethod: paymentMethod,
          );
        },
      );
    }

    switch (_activeTab) {
      case 'home':
        return ZeetechHomeScreen(
          onNavigate: (screen) => _handleNavigate(screen),
        );
      case 'services':
        return ZeetechServicesScreen(
          onNavigate: (screen, {serviceId}) => _handleNavigate(screen, serviceId: serviceId),
        );
      case 'about':
        return const ZeetechAboutScreen();
      case 'contact':
        return const ZeetechContactScreen();
      case 'account':
        return ZeetechAccountScreen(
          isGuest: _isGuest,
          onNavigate: (screen) => _handleNavigate(screen),
          onLogout: () {
            setState(() {
              _appState = 'auth';
            });
          },
        );
      default:
        return ZeetechHomeScreen(
          onNavigate: (screen) => _handleNavigate(screen),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_appState == 'splash') {
      return SplashScreen(
        onComplete: () {
          setState(() {
            _appState = 'check_session';
          });
          _checkSession();
        },
      );
    }

    if (_appState == 'check_session') {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_appState == 'auth') {
      return ZeetechUnifiedAuthScreen(
        onLoginSuccess: () {
          _checkSession();
        },
        onExploreAsGuest: () {
          setState(() {
            _isGuest = true;
            _appState = 'main';
            _activeTab = 'home';
          });
        },
      );
    }

    if (_appState == 'admin') {
      return AdminDashboardScreen(
        onLogout: () {
          setState(() {
            _appState = 'auth';
          });
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        top: _activeTab != 'service-detail', // Detail screen has its own top header
        bottom: false,
        child: Stack(
          children: [
            // Screen Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 64.0), // Padding to avoid overlap with bottom navigation bar
                child: _renderContent(),
              ),
            ),

            // Floating WhatsApp Button
            const Positioned(
              bottom: 96,
              right: 16,
              child: FloatingWhatsAppButton(),
            ),

            // Floating Feedback Button
            Positioned(
              bottom: 170,
              right: 16,
              child: FloatingFeedbackButton(
                onTap: _openFeedbackSheet,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ZeetechBottomNav(
        activeTab: _activeTab == 'service-detail' ? 'services' : _activeTab,
        onTabChange: (tab) => _handleNavigate(tab),
      ),
    );
  }
}

// Floating Feedback Button widget (similar styling to the React code)
class FloatingFeedbackButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingFeedbackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              'Feedback',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
