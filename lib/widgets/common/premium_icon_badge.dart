import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PremiumIconBadge extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final double size;
  final Color accent;
  final Color? secondAccent;
  final BorderRadiusGeometry? borderRadius;

  const PremiumIconBadge({
    super.key,
    this.icon,
    this.customIcon,
    this.size = 48,
    this.accent = AppColors.cyan,
    this.secondAccent,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(size * 0.34);
    final secondary = secondAccent ?? AppColors.purple;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(context.isDarkPortfolio ? 0.34 : 0.22),
            secondary.withOpacity(context.isDarkPortfolio ? 0.22 : 0.14),
          ],
        ),
        border: Border.all(
          color: accent.withOpacity(
            context.isDarkPortfolio ? 0.34 : 0.22,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(
              context.isDarkPortfolio ? 0.18 : 0.12,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -size * 0.16,
            top: -size * 0.18,
            child: Container(
              width: size * 0.46,
              height: size * 0.46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(
                  context.isDarkPortfolio ? 0.08 : 0.42,
                ),
              ),
            ),
          ),
          Center(
            child: customIcon ?? (icon != null ? Icon(
              icon,
              color: context.isDarkPortfolio ? Colors.white : accent,
              size: size * 0.48,
            ) : const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
