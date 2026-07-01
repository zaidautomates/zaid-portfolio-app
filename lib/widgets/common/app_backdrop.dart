import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppBackdrop extends StatefulWidget {
  const AppBackdrop({super.key});

  @override
  State<AppBackdrop> createState() => _AppBackdropState();
}

class _AppBackdropState extends State<AppBackdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _orb1Animation;
  late final Animation<double> _orb2Animation;
  late final Animation<double> _orb3Animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    _orb1Animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.66, curve: Curves.easeInOut),
    );
    _orb2Animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.33, 0.99, curve: Curves.easeInOut),
    );
    _orb3Animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.66, 1.0, curve: Curves.easeInOut),
    );

    final isTestMode = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTestMode) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.isDarkPortfolio
        ? const [AppColors.bgDeep, AppColors.bg, AppColors.bg]
        : const [AppColors.lightBgDeep, AppColors.lightBg, Color(0xFFFFFFFF)];

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.45,
          colors: colors,
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned(
                top: -48,
                left: -40,
                child: _GlowOrb(
                  color: AppColors.purple,
                  size: 170,
                  opacity: context.isDarkPortfolio ? 0.24 : 0.13,
                  animationValue: _orb1Animation.value,
                ),
              ),
              Positioned(
                top: 120,
                right: -30,
                child: _GlowOrb(
                  color: AppColors.cyan,
                  size: 150,
                  opacity: context.isDarkPortfolio ? 0.24 : 0.12,
                  animationValue: _orb2Animation.value,
                ),
              ),
              Positioned(
                bottom: 90,
                left: 24,
                child: _GlowOrb(
                  color: AppColors.gold,
                  size: 130,
                  opacity: context.isDarkPortfolio ? 0.24 : 0.11,
                  animationValue: _orb3Animation.value,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  final double animationValue;

  const _GlowOrb({
    required this.color,
    required this.size,
    required this.opacity,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    final modulatedOpacity = opacity * (0.75 + 0.25 * animationValue);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(modulatedOpacity),
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}
