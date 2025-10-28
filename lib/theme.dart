import 'package:flutter/material.dart';

class AppTheme {
  // ألوان موحّدة للتصميم
  static const Color primary = Color(0xFF1E293B); // اللون الداكن الأساسي
  static const Color accent  = Color(0xFF22C55E); // أخضر للتأكيدات
  static const Color bg      = Color(0xFFF3F4F6); // خلفية فاتحة
  static const Color surface = Colors.white;      // بطاقات/أسطح
  static const Color text    = Color(0xFF0F172A); // نص أساسي
  static const Color textSecondary = Color(0xFF94A3B8); // نص ثانوي
  static const Color border  = Color(0xFFE5E7EB); // حدود فاتحة
  static const Color danger  = Color(0xFFE11D48); // تحذيرات/إلغاء

  static ThemeData get light {
    final cs = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      surface: surface,
      background: bg,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: bg,

      // الخطوط
      fontFamily: 'Cairo',
      fontFamilyFallback: const ['Tajawal'],

      // نصوص عامة (استخدمنا الأوزان المتوفرة لديك 400/700/800)
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: text),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: text),
        titleLarge:  TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: text),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: text),
        bodyLarge:   TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: text),
        bodyMedium:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: text),
        bodySmall:   TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondary),
        labelLarge:  TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: text),
      ),

      // AppBar شفاف مثل التصميم
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primary,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: primary,
        ),
      ),

      // بطاقات
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),

      // أزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: border),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFE5E7EB),
        hintStyle: const TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w700,
          fontFamily: 'Cairo',
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),

      // شريط التنقل السفلي
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),

      // سلايدر
      sliderTheme: const SliderThemeData(
        trackHeight: 6,
        activeTrackColor: accent,
        inactiveTrackColor: border,
        thumbColor: accent,
      ),

      // سناك بار
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        behavior: SnackBarBehavior.floating,
      ),

      // فواصل
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
    );
  }
}