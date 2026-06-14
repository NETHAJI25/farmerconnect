import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Primary Palette
  static const Color forestGreen = Color(0xFF1B5E20);
  static const Color freshGreen = Color(0xFF2E7D32);
  static const Color limeAccent = Color(0xFF8BC34A);

  // Secondary Palette
  static const Color harvestAmber = Color(0xFFFFB300);
  static const Color earthBrown = Color(0xFF795548);
  static const Color organicCream = Color(0xFFFFF8E7);

  // Commerce Colors
  static const Color offerRed = Color(0xFFFF5252);
  static const Color cartOrange = Color(0xFFFF6D00);
  static const Color successGreen = Color(0xFF00C853);

  // Neutrals
  static const Color darkBg = Color(0xFF0F1115);
  static const Color cardBg = Color(0xFF161B22);
  static const Color softGrey = Color(0xFFE8EAED);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color white = Color(0xFFFFFFFF);

  // Radius constants
  static const double radiusCard = 24.0;
  static const double radiusButton = 18.0;
  static const double radiusBottomSheet = 32.0;
  static const double radiusPill = 100.0;

  static TextStyle _poppins({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ).copyWith(
      displayLarge: _poppins(size: 42, weight: FontWeight.w700),
      displayMedium: _poppins(size: 34, weight: FontWeight.w700),
      headlineLarge: _poppins(size: 28, weight: FontWeight.w700),
      headlineMedium: _poppins(size: 24, weight: FontWeight.w600),
      titleLarge: _poppins(size: 20, weight: FontWeight.w600),
      titleMedium: _poppins(size: 18, weight: FontWeight.w600),
      titleSmall: _poppins(size: 16, weight: FontWeight.w600),
      bodyLarge: _poppins(size: 16, weight: FontWeight.w400),
      bodyMedium: _poppins(size: 14, weight: FontWeight.w400),
      bodySmall: _poppins(size: 13, weight: FontWeight.w400),
      labelLarge: _poppins(size: 14, weight: FontWeight.w600),
      labelMedium: _poppins(size: 12, weight: FontWeight.w500),
      labelSmall: _poppins(size: 11, weight: FontWeight.w500),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: forestGreen,
        onPrimary: white,
        primaryContainer: forestGreen.withValues(alpha: 0.12),
        secondary: harvestAmber,
        onSecondary: white,
        secondaryContainer: harvestAmber.withValues(alpha: 0.12),
        surface: white,
        onSurface: textPrimary,
        surfaceContainerHighest: const Color(0xFFF8FAF5),
        error: offerRed,
        onError: white,
        outline: const Color(0xFFD1D5DB),
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: white,
        foregroundColor: textPrimary,
        titleTextStyle: _poppins(size: 20, weight: FontWeight.w600, color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: forestGreen,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: _poppins(size: 16, weight: FontWeight.w600, color: white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: forestGreen,
          side: const BorderSide(color: forestGreen),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: _poppins(size: 16, weight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAF5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: forestGreen, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: _poppins(size: 14, weight: FontWeight.w400, color: textSecondary),
        labelStyle: _poppins(size: 14, weight: FontWeight.w500, color: textSecondary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: forestGreen,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: _poppins(size: 11, weight: FontWeight.w600),
        unselectedLabelStyle: _poppins(size: 11, weight: FontWeight.w500),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusPill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        labelStyle: _poppins(size: 13, weight: FontWeight.w500),
        backgroundColor: forestGreen.withValues(alpha: 0.08),
        selectedColor: forestGreen,
        secondarySelectedColor: forestGreen,
        brightness: Brightness.light,
      ),
      dividerTheme: DividerThemeData(
        color: const Color(0xFFE5E7EB),
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: forestGreen,
        foregroundColor: white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: forestGreen.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _poppins(size: 11, weight: FontWeight.w600, color: forestGreen);
          }
          return _poppins(size: 11, weight: FontWeight.w500, color: textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: forestGreen, size: 24);
          }
          return const IconThemeData(color: textSecondary, size: 24);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).copyWith(
      displayLarge: _poppins(size: 42, weight: FontWeight.w700, color: white),
      displayMedium: _poppins(size: 34, weight: FontWeight.w700, color: white),
      headlineLarge: _poppins(size: 28, weight: FontWeight.w700, color: white),
      headlineMedium: _poppins(size: 24, weight: FontWeight.w600, color: white),
      titleLarge: _poppins(size: 20, weight: FontWeight.w600, color: white),
      titleMedium: _poppins(size: 18, weight: FontWeight.w600, color: white),
      titleSmall: _poppins(size: 16, weight: FontWeight.w600, color: white),
      bodyLarge: _poppins(size: 16, weight: FontWeight.w400, color: white),
      bodyMedium: _poppins(size: 14, weight: FontWeight.w400, color: white),
      bodySmall: _poppins(size: 13, weight: FontWeight.w400, color: white),
      labelLarge: _poppins(size: 14, weight: FontWeight.w600, color: white),
      labelMedium: _poppins(size: 12, weight: FontWeight.w500, color: white),
      labelSmall: _poppins(size: 11, weight: FontWeight.w500, color: white),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF4CAF50),
        onPrimary: white,
        primaryContainer: const Color(0xFF4CAF50).withValues(alpha: 0.15),
        secondary: const Color(0xFFFFB74D),
        onSecondary: const Color(0xFF0F1115),
        secondaryContainer: const Color(0xFFFFB74D).withValues(alpha: 0.12),
        surface: darkBg,
        onSurface: white,
        surfaceContainerHighest: cardBg,
        error: const Color(0xFFEF5350),
        onError: white,
        outline: const Color(0xFF2C2C2E),
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: darkBg,
        foregroundColor: white,
        titleTextStyle: _poppins(size: 20, weight: FontWeight.w600, color: white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: _poppins(size: 16, weight: FontWeight.w600, color: white),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: _poppins(size: 14, weight: FontWeight.w400, color: textSecondary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: const Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: _poppins(size: 11, weight: FontWeight.w600),
        unselectedLabelStyle: _poppins(size: 11, weight: FontWeight.w500),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusPill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        labelStyle: _poppins(size: 13, weight: FontWeight.w500),
        backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.08),
        selectedColor: const Color(0xFF4CAF50),
        brightness: Brightness.dark,
      ),
      dividerTheme: DividerThemeData(
        color: const Color(0xFF2C2C2E),
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: const Color(0xFF4CAF50).withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _poppins(size: 11, weight: FontWeight.w600, color: const Color(0xFF4CAF50));
          }
          return _poppins(size: 11, weight: FontWeight.w500, color: const Color(0xFF6B7280));
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF4CAF50), size: 24);
          }
          return const IconThemeData(color: Color(0xFF6B7280), size: 24);
        }),
      ),
    );
  }

  // Backward-compatible aliases
  static const Color primaryGreen = forestGreen;
  static const Color secondaryAmber = harvestAmber;
  static const Color errorRed = offerRed;
  static const Color surfaceLight = white;
  static const Color backgroundLight = Color(0xFFF8FAF5);

  // Soft shadow helper
  static BoxShadow softShadow({Color color = Colors.black, double opacity = 0.06, double blur = 20, double y = 4}) {
    return BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: blur,
      offset: Offset(0, y),
    );
  }

  // Glass effect decoration
  static BoxDecoration glassEffect({Color? background, double blur = 20, double opacity = 0.6}) {
    return BoxDecoration(
      color: (background ?? Colors.white).withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radiusCard),
      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
