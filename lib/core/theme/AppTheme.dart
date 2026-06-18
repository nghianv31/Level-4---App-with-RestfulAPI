// ignore: file_names
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color secondaryColor = Color(0xFF16A34A);
  static const Color tertiaryColor = Color(0xFFBC4800);
  static const Color neutralColor = Color(0xFF757681);

  // Thêm các màu sắc chi tiết từ DESIGN.md
  static const Color surface = Color(0xFFFAF8FF);
  static const Color onSurface = Color(0xFF191B23);
  static const Color surfaceContainer = Color(0xFFEDEDF9);
  static const Color outline = Color(0xFF737686);
  static const Color outlineVariant = Color(0xFFC3C6D7);
  static const Color errorColor = Color(0xFFBA1A1A);

  // Font family mặc định (DESIGN.md yêu cầu Inter)
  static const String fontFamily = 'Inter';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: surface,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        background: surface,
        surface: Colors.white,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: onSurface,
        onSurface: onSurface,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: onSurface,
        centerTitle: true,
        iconTheme: IconThemeData(size: 24, color: onSurface),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 12px radius từ DESIGN.md
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1), // slate-200 border
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48), // tối thiểu 48px
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: neutralColor, fontFamily: fontFamily),
        errorStyle: const TextStyle(color: errorColor, fontFamily: fontFamily),
      ),
      textTheme: const TextTheme(
        displayMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.64,
          color: onSurface,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.24,
          color: onSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
          color: onSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
          color: Colors.black54,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: neutralColor,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    // Để giữ thiết kế nhất quán với tone sáng, hoặc cung cấp bản tối chuyên nghiệp
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      // Có thể tùy biến thêm nếu cần hỗ trợ chế độ tối đầy đủ
    );
  }
}
