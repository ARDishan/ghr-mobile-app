import 'package:flutter/material.dart';

/// Carried over from the previous project structure.
class AppSizes {
  AppSizes._();

  static late MediaQueryData _mediaQuery;
  static late double _screenWidth;
  static late double _screenHeight;

  static void init(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    _screenWidth = _mediaQuery.size.width;
    _screenHeight = _mediaQuery.size.height;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static EdgeInsets get viewPadding => _mediaQuery.viewPadding;
  static EdgeInsets get viewInsets => _mediaQuery.viewInsets;

  static double wp(double percent) => _screenWidth * percent / 100;
  static double hp(double percent) => _screenHeight * percent / 100;

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  static const double iconXs = 14.0;
  static const double iconSm = 18.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusXxl = 32.0;
  static const double radiusFull = 100.0;

  static const double buttonHeightLg = 56.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightSm = 40.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 64.0;
  static const double bottomNavHeight = 70.0;
  static const double cardHeight = 220.0;

  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: md, vertical: lg);
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  static bool get isMobile => _screenWidth < mobileBreakpoint;
  static bool get isTablet =>
      _screenWidth >= mobileBreakpoint && _screenWidth < tabletBreakpoint;
  static bool get isDesktop => _screenWidth >= tabletBreakpoint;
}
