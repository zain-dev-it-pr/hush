import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Central design system for Hushh.
///
/// Everything visual lives here — colors, text styles, button shapes.

class AppTheme {
  AppTheme._();

  // Color tokens


  static const teal = Color(0xFF2DB896);
  static const tealLight = Color(0xFF3DD9B0);
  static const tealDark = Color(0xFF1A8A6F);

  static const bgBase = Color(0xFF0D0F14);
  static const bgSurface = Color(0xFF161A23);
  static const bgCard = Color(0xFF1C2130);
  static const bgCardElevated = Color(0xFF222840);
  static const textPrimary = Color(0xFFEDF0F7);
  static const textSecondary = Color(0xFF8E9BB0);
  static const textMuted = Color(0xFF4E5A6E);

  static const success = Color(0xFF2DB896);
  static const warning = Color(0xFFF5A623);
  static const danger = Color(0xFFE05454);
  static const info = Color(0xFF5B8DEF);

  /// Border / divider
  static const border = Color(0xFF252D3D);
  static const borderLight = Color(0xFF2E3850);

  // ThemeData factory

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true, fontFamily: 'Poppins', brightness: Brightness.dark, scaffoldBackgroundColor: bgBase, colorScheme: const ColorScheme.dark(primary: teal,
        secondary: tealLight, surface: bgSurface, error: danger, onPrimary: Colors.white, onSecondary: Colors.white, onSurface: textPrimary,
      ),

      // App bar — transparent, no elevation, white icons
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,elevation: 0, scrolledUnderElevation: 0, centerTitle: false, iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary, letterSpacing: 0.2,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light,),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: bgCard, elevation: 0, shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), side: const BorderSide(color: border, width: 1),),
        margin: EdgeInsets.zero,),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: teal,
          side: const BorderSide(color: teal, width: 1.5),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      // Bottom nav
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgSurface, selectedItemColor: teal, unselectedItemColor: textMuted, showSelectedLabels: true, showUnselectedLabels: true, type: BottomNavigationBarType.fixed, selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
        ),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: bgCardElevated, labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: textSecondary,
        ),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  //Text style shortcuts

  static const headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const headline2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textMuted,
    height: 1.4,
  );

  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textMuted,
    letterSpacing: 1.2,
  );
}
