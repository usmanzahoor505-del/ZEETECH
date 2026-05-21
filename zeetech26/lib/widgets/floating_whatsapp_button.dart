import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';

class FloatingWhatsAppButton extends StatefulWidget {
  const FloatingWhatsAppButton({super.key});

  @override
  State<FloatingWhatsAppButton> createState() => _FloatingWhatsAppButtonState();
}

class _FloatingWhatsAppButtonState extends State<FloatingWhatsAppButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseScaleAnimation;
  late Animation<double> _pulseOpacityAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse effect animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseScaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _pulseOpacityAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    // Periodic rotation animation
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -0.17), weight: 25), // -10 degrees
      TweenSequenceItem(tween: Tween<double>(begin: -0.17, end: 0.17), weight: 25), // 10 degrees
      TweenSequenceItem(tween: Tween<double>(begin: 0.17, end: -0.17), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: -0.17, end: 0.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut));

    // Repeat rotation every 3.5 seconds
    _startPeriodicRotation();
  }

  void _startPeriodicRotation() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        await _rotateController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _handleWhatsApp() async {
    const message = "Hello ZEETECH! I need technical service assistance.";
    final url = Uri.parse("https://wa.me/923005518622?text=${Uri.encodeComponent(message)}");
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulse effect back circle
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseScaleAnimation.value,
              child: Opacity(
                opacity: _pulseOpacityAnimation.value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.whatsappGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),

        // Main FAB Button
        RotationTransition(
          turns: _rotateAnimation,
          child: FloatingActionButton(
            onPressed: _handleWhatsApp,
            backgroundColor: AppColors.whatsappGreen,
            elevation: 8,
            shape: const CircleBorder(),
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
