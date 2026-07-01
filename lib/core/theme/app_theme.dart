import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF050816);
  static const bgDeep = Color(0xFF0A1020);
  static const lightBg = Color(0xFFF6F3FF);
  static const lightBgDeep = Color(0xFFEAFBFF);
  static const card = Color(0xFF101826);
  static const cardBorder = Color(0x40FFFFFF); // 25% opacity for sharper borders
  static const lightCardBorder = Color(0x4024304A);
  static const purple = Color(0xFF8B5CF6);
  static const cyan = Color(0xFF22D3EE);
  static const gold = Color(0xFFF5C451);
  static const textMuted = Color(0xFF9AA4B2);
  static const lightText = Color(0xFF172033);
  static const lightMuted = Color(0xFF667085);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.purple,
      brightness: Brightness.dark,
      primary: AppColors.purple,
      secondary: AppColors.cyan,
      tertiary: AppColors.gold,
      surface: AppColors.card,
    ),
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.purple,
      brightness: Brightness.light,
      primary: AppColors.purple,
      secondary: const Color(0xFF0891B2),
      tertiary: const Color(0xFFB7791F),
      surface: Colors.white,
    ),
    textTheme: Typography.blackMountainView.apply(
      bodyColor: AppColors.lightText,
      displayColor: AppColors.lightText,
    ),
  );
}

extension PortfolioTheme on BuildContext {
  bool get isDarkPortfolio => Theme.of(this).brightness == Brightness.dark;

  Color get primaryText => isDarkPortfolio ? Colors.white : AppColors.lightText;

  Color get mutedText =>
      isDarkPortfolio ? AppColors.textMuted : AppColors.lightMuted;

  Color get softText =>
      isDarkPortfolio ? Colors.white70 : const Color(0xFF344054);

  Color get cardFill => isDarkPortfolio
      ? Colors.white.withOpacity(0.09) // More substance for 3D look
      : Colors.white.withOpacity(0.92);

  Color get cardBorder =>
      isDarkPortfolio ? AppColors.cardBorder : AppColors.lightCardBorder;

  Color get navFill => isDarkPortfolio
      ? AppColors.bgDeep.withOpacity(0.92)
      : Colors.white.withOpacity(0.92);
}
