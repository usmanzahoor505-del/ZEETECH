import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';

class ZeetechContactScreen extends StatelessWidget {
  const ZeetechContactScreen({super.key});

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
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppGradients.header,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "We're here to help 24/7",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Contact Cards
              _buildContactButton(
                icon: Icons.phone_outlined,
                iconColor: Colors.white,
                btnBgGradient: AppGradients.primary,
                title: 'Phone',
                subtitle: '+92 300 5518622',
                caption: 'Tap to call principal number',
                onTap: () => _launchUrl('tel:+923005518622'),
              ),
              const SizedBox(height: 16),

              _buildContactButton(
                icon: Icons.chat_bubble_outline,
                iconColor: Colors.white,
                btnBgColor: AppColors.whatsappGreen,
                title: 'WhatsApp',
                subtitle: '+92 300 5518622',
                caption: 'Quick response guaranteed',
                onTap: () => _launchUrl('https://wa.me/923005518622?text=Hello%20ZEETECH!'),
              ),
              const SizedBox(height: 16),

              _buildContactButton(
                icon: Icons.mail_outline,
                iconColor: Colors.white,
                btnBgGradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                title: 'Email',
                subtitle: 'info.zeetech26@gmail.com',
                caption: 'Tap to send sales inquiry',
                onTap: () => _launchUrl('mailto:info.zeetech26@gmail.com'),
              ),
              const SizedBox(height: 16),

              // Address card (tappable - opens Google Maps)
              InkWell(
                onTap: () => _launchUrl(
                  'https://www.google.com/maps/place/33%C2%B039\'35.3%22N+72%C2%B059\'21.1%22E/@33.6598056,72.9866195,17z',
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.orange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.map_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Office Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'G-12 Ghazali Road, Islamabad',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textGray,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.open_in_new,
                                  size: 13,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Open in Google Maps',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
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

              const SizedBox(height: 24),

              // Tappable Map Card
              InkWell(
                onTap: () => _launchUrl(
                  'https://www.google.com/maps/place/33%C2%B039\'35.3%22N+72%C2%B059\'21.1%22E/@33.6598056,72.9866195,17z',
                ),
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.cyan.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.blue.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Map grid lines for visual effect
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MapGridPainter(),
                        ),
                      ),
                      // Content
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: double.infinity),
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 64,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Find Us on Map',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'G-12 Ghazali Road, Islamabad',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textGray,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.open_in_new,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Tap to open Google Maps',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Social Media Row
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Follow Us',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
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
                        const SizedBox(width: 12),
                        _buildSocialIcon(
                          icon: FontAwesomeIcons.instagram,
                          color: Colors.transparent,
                          isInstagram: true,
                          onTap: () => _launchUrl('https://www.instagram.com/zeetech.26?igsh=YTQ3bDJoczl1cmZ0'),
                        ),
                        const SizedBox(width: 12),
                        _buildSocialIcon(
                          icon: FontAwesomeIcons.tiktok,
                          color: Colors.black,
                          onTap: () => _launchUrl('https://www.tiktok.com/@zeetech26?_r=1&_t=ZS-95EIV49D8AT'),
                        ),
                        const SizedBox(width: 12),
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

              const SizedBox(height: 24),

              // Operating Hours
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Text(
                      'Operating Hours',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Monday - Saturday: 8:00 AM - 10:00 PM',
                      style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Sunday: 9:00 AM - 8:00 PM',
                      style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.white24, height: 1),
                    SizedBox(height: 16),
                    Text(
                      '🚨 Emergency Service: 24/7',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required Color iconColor,
    Gradient? btnBgGradient,
    Color? btnBgColor,
    required String title,
    required String subtitle,
    required String caption,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: btnBgColor,
                gradient: btnBgGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caption,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
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

  Widget _buildSocialIcon({
    required FaIconData icon,
    required Color color,
    bool isInstagram = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 56,
        height: 56,
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
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.08)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Road-like horizontal stripe
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
