import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                context.isDarkPortfolio ? 0.42 : 0.1,
              ),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(
                context.isDarkPortfolio ? 0.08 : 0.55,
              ),
              blurRadius: 12,
              offset: const Offset(-3, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: padding,
              decoration: BoxDecoration(
                color: context.cardFill,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: context.cardBorder, width: 1),
                // Subtle top-left inner highlight for bevel effect
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(
                      context.isDarkPortfolio ? 0.07 : 0.35,
                    ),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5],
                ),
              ),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: context.primaryText),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}