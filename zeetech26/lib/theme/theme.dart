import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF0057FF);
  static const Color secondary = Color(0xFF00C2FF);
  static const Color darkBg = Color(0xFF0A1628);
  static const Color darkBg2 = Color(0xFF0D1B2A);
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color grayBg = Color(0xFFE5E9F0);
  static const Color textDark = Color(0xFF0A1628);
  static const Color textLight = Colors.white;
  static const Color textGray = Color(0xFF4A5568);
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color border = Color(0xFFE2E8F0);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient header = LinearGradient(
    colors: [AppColors.darkBg, AppColors.darkBg2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ac = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient refrigerator = LinearGradient(
    colors: [Color(0xFF0891B2), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient solar = LinearGradient(
    colors: [Color(0xFFEAB308), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient inverter = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient carpenter = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFCA8A04)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient electrician = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient feedback = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

ThemeData getThemeData() {
  return ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBg,
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        color: AppColors.textGray,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        color: AppColors.textGray,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
    ),
    useMaterial3: true,
  );
}
