import 'package:flutter/material.dart';
import '../theme/theme.dart';

class LegalPoliciesScreen extends StatelessWidget {
  const LegalPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.lightBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Legal & Policies',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: -0.3,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textGray,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            tabs: [
              Tab(text: 'Privacy Policy'),
              Tab(text: 'Terms of Service'),
              Tab(text: 'Refund Policy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PrivacyPolicyTab(),
            _TermsOfServiceTab(),
            _RefundPolicyTab(),
          ],
        ),
      ),
    );
  }
}

class _PrivacyPolicyTab extends StatelessWidget {
  const _PrivacyPolicyTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            icon: Icons.shield_rounded,
            title: 'Privacy Policy',
            subtitle: 'Last Updated: June 2026',
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('1. Information We Collect'),
          _buildBodyText(
            'At ZeeTech, we collect essential information required to deliver premium technical services. This includes:\n'
            '• Personal Details: Your full name, email address, phone number, and physical home/office address.\n'
            '• Problem Documentation: Images and photos you upload showing the appliance or maintenance issue. These are saved securely on our local server and shared only with your assigned technician.\n'
            '• Device and Usage Data: IP address, device model, operating system, and app performance logs.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('2. How We Use Your Information'),
          _buildBodyText(
            'Your data is processed strictly for the following purposes:\n'
            '• Dispatching technicians to your exact location.\n'
            '• Communicating booking statuses, verification OTPs, and receipt details.\n'
            '• Processing transactions and preventing fraudulent transactions.\n'
            '• Generating service statistics and improving app performance.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('3. Security and Storage'),
          _buildBodyText(
            'We employ enterprise-grade security controls (HTTPS, password hashing, and encrypted database connections) to safeguard your data. Your data is stored on secure local servers and is never sold or rented to third-party advertisers.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('4. Your Rights'),
          _buildBodyText(
            'You have the right to request access to your personal profiles, request corrections to your phone/address details, or ask for the deletion of your account. For data erasure queries, please contact our support team at support@zeetech.com.',
          ),
          const SizedBox(height: 30),
          _buildComplianceBadge(),
        ],
      ),
    );
  }
}

class _TermsOfServiceTab extends StatelessWidget {
  const _TermsOfServiceTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            icon: Icons.gavel_rounded,
            title: 'Terms of Service',
            subtitle: 'Last Updated: June 2026',
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('1. Service Agreement'),
          _buildBodyText(
            'By downloading, registering, or using the ZeeTech application, you agree to comply with and be bound by these Terms of Service. If you do not agree, please do not use our services.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('2. User Accounts'),
          _buildBodyText(
            'You are responsible for maintaining the confidentiality of your account credentials, including your login password and OTP codes. You agree to notify ZeeTech immediately of any unauthorized use of your account. You must provide accurate, current, and complete information during registration.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('3. Booking and Dispatch Policies'),
          _buildBodyText(
            '• All bookings are subject to technician availability.\n'
            '• ZeeTech acts as a trusted platform assigning verified, professional technicians to your service requests.\n'
            '• Users agree to provide safe access to their premises for the technician to carry out the necessary diagnostics or repairs.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('4. Prohibited Activities'),
          _buildBodyText(
            'You agree not to bypass the platform by dealing directly with assigned technicians outside the app, submit false billing/receipt details, upload malicious images, or engage in behavior that harms ZeeTech staff or technicians.',
          ),
          const SizedBox(height: 30),
          _buildComplianceBadge(),
        ],
      ),
    );
  }
}

class _RefundPolicyTab extends StatelessWidget {
  const _RefundPolicyTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            icon: Icons.monetization_on_rounded,
            title: 'Refund & Cancellations',
            subtitle: 'Last Updated: June 2026',
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('1. Booking Cancellations'),
          _buildBodyText(
            '• Pre-Dispatch: You may cancel your service booking at any time before the technician is dispatched without any penalty or fee.\n'
            '• Post-Dispatch: If a booking is cancelled after the technician has arrived at your address or is already in transit, a diagnostic/cancellation fee of Rs. 300 will be charged to cover travel costs.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('2. Refund Eligibility'),
          _buildBodyText(
            '• Refunds are initiated automatically if a booking is cancelled under the eligible pre-dispatch conditions.\n'
            '• If you paid using bank transfer, EasyPaisa, or JazzCash, the refunded amount will be credited back to your original payment account.\n'
            '• Service Warranty: We provide a 7-day warranty on workmanship. If the same issue recurs within 7 days, our technician will inspect and repair it free of charge, or you will be issued a refund if the repair is not possible.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('3. Processing Duration'),
          _buildBodyText(
            'Approved refunds are processed within 3 to 5 business days, depending on bank clearance times. You will receive an email confirmation and in-app status update once the refund is successfully transferred.',
          ),
          const SizedBox(height: 30),
          _buildComplianceBadge(),
        ],
      ),
    );
  }
}

// ── SHARED COMPONENT WIDGETS ──

Widget _buildHeaderCard({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: AppGradients.primary,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        letterSpacing: -0.2,
      ),
    ),
  );
}

Widget _buildBodyText(String content) {
  return Text(
    content,
    style: const TextStyle(
      fontSize: 12.5,
      color: AppColors.textGray,
      height: 1.5,
    ),
  );
}

Widget _buildComplianceBadge() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade100, width: 1.2),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.verified_user_rounded, color: Colors.green, size: 18),
        const SizedBox(width: 8),
        Text(
          'ZeeTech Compliance Verified & Audited',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
