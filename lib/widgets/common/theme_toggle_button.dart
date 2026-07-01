import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: InkWell(
        onTap: () {
          themeProvider.updateTheme(isDark ? ThemeMode.light : ThemeMode.dark);
        },
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: context.cardFill,
            border: Border.all(color: context.cardBorder),
          ),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: isDark ? AppColors.gold : AppColors.purple,
          ),
        ),
      ),
    );
  }
}
