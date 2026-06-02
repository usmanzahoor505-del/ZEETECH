import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF00529C);      // Royal Blue from your screenshot
  static const Color secondary = Color(0xFF3884F4);    // Light Accent Blue from your screenshot
  static const Color darkBg = Color(0xFF072D52);       // Deep Corporate Navy
  static const Color darkBg2 = Color(0xFF00529C);      // Royal Blue Secondary
  static const Color lightBg = Color(0xFFF0F4F8);      // Soft cool blue-gray background
  static const Color grayBg = Color(0xFFE2EAF4);       // Gray border / background
  static const Color textDark = Color(0xFF072D52);     // Deep Navy for text
  static const Color textLight = Colors.white;
  static const Color textGray = Color(0xFF3E4E68);     // Muted slate gray for secondary text
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color border = Color(0xFFD6E2F0);       // Soft premium border
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient header = LinearGradient(
    colors: [AppColors.darkBg, AppColors.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Customized category gradients to match the corporate royal/navy brand
  static const LinearGradient ac = LinearGradient(
    colors: [Color(0xFF00529C), Color(0xFF3884F4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient refrigerator = LinearGradient(
    colors: [Color(0xFF072D52), Color(0xFF00529C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient solar = LinearGradient(
    colors: [Color(0xFF072D52), Color(0xFF3884F4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient inverter = LinearGradient(
    colors: [Color(0xFF00529C), Color(0xFFE2EAF4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient carpenter = LinearGradient(
    colors: [Color(0xFF072D52), Color(0xFF3884F4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient electrician = LinearGradient(
    colors: [Color(0xFF00529C), Color(0xFF3884F4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient washingMachine = LinearGradient(
    colors: [Color(0xFF072D52), Color(0xFF00529C)],
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
