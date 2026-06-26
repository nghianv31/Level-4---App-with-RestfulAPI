// ignore: file_names
import 'package:flutter/material.dart';

class AppTheme {
  // Common Colors
  static const Color primaryColor = Color(0xFFF24E1E);

  // Light Theme Colors
  static const Color lightBackground = Colors.white;
  static const Color lightTextColor = Color(0xFF242E37);
  static const Color lightTextHintColor = Color(0xFF5C6771);
  static const Color lightBorderColor = Color(0xFFEBECED);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkTextColor = Color(0xFFE0E0E0);
  static const Color darkTextHintColor = Color(0xFF9E9E9E);
  static const Color darkBorderColor = Color(0xFF333333);
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
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        surface: lightBackground,
        onSurface: lightTextColor,
        onSurfaceVariant: lightTextHintColor,
        outline: lightBorderColor,
        error: Colors.red,
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
