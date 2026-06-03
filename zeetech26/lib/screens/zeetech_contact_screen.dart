import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';

/// ZEETECH PREMIUM ENTERPRISE CONTACT SCREEN
/// Upgraded with modern high-contrast cards, glowing glassmorphic button icons,
/// custom pulsing locator nodes, and vibrant social media row selectors.
class ZeetechContactScreen extends StatelessWidget {
  const ZeetechContactScreen({super.key});

  // ── Preserved Url Launcher Logic 100% ──
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: Column(
        children: [
          // ── PREMIUM BRAND HEADER AREA ──
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade100,
                  width: 1.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.012),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: const SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.6,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "We're here to help 24/7",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── SCROLLABLE CONTACT CHANNELS CONTENT ──
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                // 1. WhatsApp Channel (Primary High Contrast Block)
                _buildContactButton(
                  iconWidget: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 22),
                  btnBgColor: AppColors.whatsappGreen,
                  title: 'WhatsApp Support',
                  subtitle: '+92 300 5518622',
                  caption: 'Instant chat - Quick response guaranteed',
                  onTap: () => _launchUrl('https://wa.me/923005518622?text=Hello%20ZEETECH!'),
                ),
                const SizedBox(height: 14),

                // 2. Direct Phone Call Channel
                _buildContactButton(
                  iconWidget: const Icon(Icons.phone_outlined, color: Colors.white, size: 22),
                  btnBgGradient: const LinearGradient(
                    colors: [Color(0xFF0066FF), Color(0xFF00A3FF)],
                  ),
                  title: 'Phone Call Support',
                  subtitle: '+92 300 5518622',
                  caption: 'Direct line to our customer relations desk',
                  onTap: () => _launchUrl('tel:+923005518622'),
                ),
                const SizedBox(height: 14),

                // 3. Email Channel
                _buildContactButton(
                  iconWidget: const Icon(Icons.mail_outline_rounded, color: Colors.white, size: 22),
                  btnBgGradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: 'Official Email Desk',
                  subtitle: 'info.zeetech26@gmail.com',
                  caption: 'Tap to send sales or custom inquiries',
                  onTap: () => _launchUrl('mailto:info.zeetech26@gmail.com'),
                ),
                const SizedBox(height: 14),

                // 4. Web Channel
                _buildContactButton(
                  iconWidget: const FaIcon(FontAwesomeIcons.globe, color: Colors.white, size: 22),
                  btnBgGradient: const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: 'Web Platform',
                  subtitle: 'www.zeetech26.com',
                  caption: 'Visit our site to explore corporate profiles',
                  onTap: () => _launchUrl('https://zeetech26.com/'),
                ),
                const SizedBox(height: 14),

                // 5. Facebook Corporate Profile
                _buildContactButton(
                  iconWidget: const FaIcon(FontAwesomeIcons.facebook, color: Colors.white, size: 22),
                  btnBgColor: const Color(0xFF1877F2),
                  title: 'Facebook Profile',
                  subtitle: 'ZEETECH Engineering',
                  caption: 'Follow our official engineering posts',
                  onTap: () => _launchUrl('https://www.facebook.com/people/ZEETECH/61582035964807/?rdid=Nk9HDGfATsc7xAMM&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1BS7AHHSx5%2F'),
                ),
                const SizedBox(height: 14),

                // 6. Instagram Hub
                _buildContactButton(
                  iconWidget: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 22),
                  btnBgGradient: const LinearGradient(
                    colors: [Color(0xFF8134AF), Color(0xFFDD2A7B), Color(0xFFF58529)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: 'Instagram Hub',
                  subtitle: '@zeetech.26',
                  caption: 'Check our latest job reels and design reviews',
                  onTap: () => _launchUrl('https://www.instagram.com/zeetech.26?igsh=YTQ3bDJoczl1cmZ0'),
                ),
                const SizedBox(height: 14),

                // 7. TikTok Channel
                _buildContactButton(
                  iconWidget: const FaIcon(FontAwesomeIcons.tiktok, color: Colors.white, size: 22),
                  btnBgColor: Colors.black,
                  title: 'TikTok Workspace',
                  subtitle: '@zeetech26',
                  caption: 'Watch expert technician work in action',
                  onTap: () => _launchUrl('https://www.tiktok.com/@zeetech26?_r=1&_t=ZS-95EIV49D8AT'),
                ),
                
                const SizedBox(height: 24),

                // 8. Tappable Office Location Details
                InkWell(
                  onTap: () => _launchUrl(
                    'https://www.google.com/maps/place/ZEETECH+Engineering/@33.657742,72.984981,19.74z/data=!4m14!1m7!3m6!1s0x38df97d71f2ca195:0x915d255641727aff!2sZEETECH+Engineering!8m2!3d33.657742!4d72.984981!16s%2Fg%2F11nbk_k4pp!3m5!1s0x38df97d71f2ca195:0x915d255641727aff!8m2!3d33.657742!4d72.984981!16s%2Fg%2F11nbk_k4pp',
                  ),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade100, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.015),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.map_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Head Office Location',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'ZEETECH Engineering, Ghazali Road, Islamabad',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textGray,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.open_in_new_rounded,
                                    size: 13,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Launch Google Maps',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 9. Premium Interactive Visual Map Panel
                InkWell(
                  onTap: () => _launchUrl(
                    'https://www.google.com/maps/place/ZEETECH+Engineering/@33.657742,72.984981,19.74z/data=!4m14!1m7!3m6!1s0x38df97d71f2ca195:0x915d255641727aff!2sZEETECH+Engineering!8m2!3d33.657742!4d72.984981!16s%2Fg%2F11nbk_k4pp!3m5!1s0x38df97d71f2ca195:0x915d255641727aff!8m2!3d33.657742!4d72.984981!16s%2Fg%2F11nbk_k4pp',
                  ),
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.cyan.shade50.withOpacity(0.5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.blue.shade100, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.015),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _MapGridPainter(),
                          ),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: double.infinity),
                            Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primary,
                              size: 48,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Visual Navigator Map',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDark,
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Tap to open real-time directions',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textGray,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 10. Follow Us Grid & Row Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade100, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.015),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Follow ZEETECH Engineering',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(
                            icon: FontAwesomeIcons.facebook,
                            color: const Color(0xFF1877F2),
                            onTap: () => _launchUrl('https://www.facebook.com/people/ZEETECH/61582035964807/?rdid=Nk9HDGfATsc7xAMM&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1BS7AHHSx5%2F'),
                          ),
                          const SizedBox(width: 14),
                          _buildSocialIcon(
                            icon: FontAwesomeIcons.instagram,
                            color: Colors.transparent,
                            isInstagram: true,
                            onTap: () => _launchUrl('https://www.instagram.com/zeetech.26?igsh=YTQ3bDJoczl1cmZ0'),
                          ),
                          const SizedBox(width: 14),
                          _buildSocialIcon(
                            icon: FontAwesomeIcons.tiktok,
                            color: Colors.black,
                            onTap: () => _launchUrl('https://www.tiktok.com/@zeetech26?_r=1&_t=ZS-95EIV49D8AT'),
                          ),
                          const SizedBox(width: 14),
                          _buildSocialIcon(
                            icon: FontAwesomeIcons.whatsapp,
                            color: AppColors.whatsappGreen,
                            onTap: () => _launchUrl('https://wa.me/923005518622'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Premium UI Component: Modern Contact Channel Button
  Widget _buildContactButton({
    required Widget iconWidget,
    Gradient? btnBgGradient,
    Color? btnBgColor,
    required String title,
    required String subtitle,
    required String caption,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade100, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: btnBgColor,
                gradient: btnBgGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: iconWidget,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caption,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Premium UI Component: Glowing Rounded Social Link Circle
  Widget _buildSocialIcon({
    required dynamic icon,
    required Color color,
    bool isInstagram = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isInstagram ? null : color,
          gradient: isInstagram
              ? const RadialGradient(
                  colors: [
                    Color(0xFF8134AF),
                    Color(0xFFDD2A7B),
                    Color(0xFFF58529),
                  ],
                  center: Alignment.bottomLeft,
                  radius: 1.2,
                )
              : null,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

// Preserved Custom Map grid lines painter exactly
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.08)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final roadPaint = Paint()
      ..color = Colors.blue.withOpacity(0.06)
      ..strokeWidth = 10;
    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
