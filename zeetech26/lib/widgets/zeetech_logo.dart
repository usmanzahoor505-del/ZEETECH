import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';

class ZeetechLogo extends StatelessWidget {
  final double size;
  final bool hasBorder;
  final bool hasShadow;

  const ZeetechLogo({
    super.key,
    this.size = 80,
    this.hasBorder = true,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    // Proportional scaling for elements inside the logo to keep it pixel-perfect
    final double borderRadius = size * 0.26; // squircle look matching the screenshot
    final double fontSize = size * 0.13;      // scaled to fit in a single line
    final double spacing = size * 0.025;      // letter spacing
    final double horizontalPadding = size * 0.1; // padding inside the squircle

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary, // Solid brand royal blue from screenshot
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(
                color: Colors.white.withOpacity(0.18),
                width: size * 0.015,
              )
            : null,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: size * 0.12,
                  offset: Offset(0, size * 0.04),
                ),
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.15),
                  blurRadius: size * 0.25,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            'ZEETECH',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: spacing,
            ),
            maxLines: 1,
            softWrap: false,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
