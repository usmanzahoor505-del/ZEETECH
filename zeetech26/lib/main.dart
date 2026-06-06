import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/zeetech_home_screen.dart';
import 'screens/zeetech_services_screen.dart';
import 'screens/service_detail_screen.dart';
import 'screens/zeetech_about_screen.dart';
import 'screens/zeetech_contact_screen.dart';
import 'screens/zeetech_account_screen.dart';
import 'screens/zeetech_orders_screen.dart';
import 'screens/zeetech_checkout_screen.dart';
import 'screens/zeetech_unified_auth_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/zeetech_technician_dashboard.dart';
import 'screens/zeetech_business_screen.dart';
import 'screens/zeetech_products_screen.dart';
import 'screens/product_detail_screen.dart';
import 'services/user_auth_service.dart';
import 'services/admin_auth_service.dart';
import 'widgets/zeetech_bottom_nav.dart';
import 'widgets/floating_whatsapp_button.dart';
import 'widgets/booking_form_screen.dart';
import 'widgets/feedback_bottom_sheet.dart';
import 'widgets/feedbacks_list_bottom_sheet.dart';

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
  String? _selectedProductCategoryId;
  bool _isGuest = false;
  
  // Navigation history to handle physical/virtual device back buttons correctly
  final List<String> _navigationHistory = [];

  // Triggers to reload child screen data on tab selection
  int _homeRefreshTrigger = 0;
  int _accountRefreshTrigger = 0;

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
      final details = await UserAuthService.getCurrentUserDetails();
      if (details != null && details['role'] == 'TECHNICIAN') {
        setState(() {
          _appState = 'technician';
        });
        return;
      }
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
      if (_activeTab != screen) {
        // If we are navigating back to the screen that was last in our history, pop it
        if (_navigationHistory.isNotEmpty && _navigationHistory.last == screen) {
          _navigationHistory.removeLast();
        } else {
          // Otherwise, it's a forward navigation. Record current tab to history
          if (_navigationHistory.isEmpty || _navigationHistory.last != _activeTab) {
            _navigationHistory.add(_activeTab);
          }
        }
      }

      if (screen == 'service-detail' && serviceId != null) {
        _selectedServiceId = serviceId;
        _activeTab = 'service-detail';
      } else if (screen == 'product-detail' && serviceId != null) {
        _selectedProductCategoryId = serviceId;
        _activeTab = 'product-detail';
      } else {
        _selectedServiceId = null;
        _selectedProductCategoryId = null;
        _activeTab = screen;
      }

      if (_activeTab == 'home') {
        _homeRefreshTrigger++;
      } else if (_activeTab == 'account') {
        _accountRefreshTrigger++;
      }

      // If we go back to the home page, clear history to reset the back navigation stack
      if (screen == 'home') {
        _navigationHistory.clear();
      }
    });
  }

  void _handleBackNavigation() {
    if (_navigationHistory.isNotEmpty) {
      final previousScreen = _navigationHistory.removeLast();
      setState(() {
        _activeTab = previousScreen;
        // If we go back from service-detail, clear the selected service ID
        if (_activeTab != 'service-detail') {
          _selectedServiceId = null;
        }
        if (_activeTab != 'product-detail') {
          _selectedProductCategoryId = null;
        }
        if (_activeTab == 'home') {
          _homeRefreshTrigger++;
        } else if (_activeTab == 'account') {
          _accountRefreshTrigger++;
        }
      });
    }
  }

  void _showSignInRequiredDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.darkBg,
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

  void _openFeedbacksListSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FeedbacksListBottomSheet(),
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

    if (_activeTab == 'product-detail' && _selectedProductCategoryId != null) {
      return ProductDetailScreen(
        categoryId: _selectedProductCategoryId!,
        onNavigate: (screen) => _handleNavigate(screen),
      );
    }

    switch (_activeTab) {
      case 'home':
        return ZeetechHomeScreen(
          refreshTrigger: _homeRefreshTrigger,
          onNavigate: (screen) => _handleNavigate(screen),
        );
      case 'services':
        return ZeetechServicesScreen(
          onNavigate: (screen, {serviceId}) => _handleNavigate(screen, serviceId: serviceId),
        );
      case 'orders':
        return ZeetechOrdersScreen(
          isGuest: _isGuest,
          onNavigate: (screen) => _handleNavigate(screen),
        );
      case 'checkout':
        return ZeetechCheckoutScreen(
          onNavigate: (screen) => _handleNavigate(screen),
        );
      case 'about':
        return const ZeetechAboutScreen();
      case 'contact':
        return const ZeetechContactScreen();
      case 'business':
        return ZeetechBusinessScreen(
          onNavigate: (screen) => _handleNavigate(screen),
        );
      case 'products':
        return ZeetechProductsScreen(
          onNavigate: (screen, {serviceId}) => _handleNavigate(screen, serviceId: serviceId),
        );
      case 'account':
        return ZeetechAccountScreen(
          refreshTrigger: _accountRefreshTrigger,
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
          refreshTrigger: _homeRefreshTrigger,
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
        backgroundColor: AppColors.darkBg,
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

    if (_appState == 'technician') {
      return ZeetechTechnicianDashboard(
        onLogout: () {
          setState(() {
            _appState = 'auth';
          });
        },
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (_activeTab == 'home') {
          SystemNavigator.pop();
        } else {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          top: _activeTab != 'service-detail' && 
               _activeTab != 'product-detail' && 
               _activeTab != 'business' && 
               _activeTab != 'products', // These screens manage their own bleeding headers
          bottom: false,
          child: Stack(
            children: [
              // Screen Content
              Positioned.fill(
                child: _renderContent(),
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
                  onTap: _openFeedbacksListSheet,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ZeetechBottomNav(
          activeTab: (_activeTab == 'orders')
              ? 'orders'
              : (_activeTab == 'contact')
                  ? 'contact'
                  : (_activeTab == 'account')
                      ? 'account'
                      : (_activeTab == 'about')
                          ? 'about'
                          : 'home',
          onTabChange: (tab) => _handleNavigate(tab),
        ),
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
              'Feedbacks',
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
