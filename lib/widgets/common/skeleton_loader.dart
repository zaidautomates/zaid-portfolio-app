import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'glass_card.dart';

class SkeletonLoader extends StatefulWidget {
  final Widget child;

  const SkeletonLoader({super.key, required this.child});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
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
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.cardFill,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class SkeletonProjectCard extends StatelessWidget {
  const SkeletonProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        radius: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(width: 60, height: 60, radius: 14),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 18,
                          ),
                          const SkeletonBox(width: 60, height: 18, radius: 8),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SkeletonBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SkeletonBox(
              width: double.infinity,
              height: 14,
            ),
            const SizedBox(height: 6),
            SkeletonBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 14,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SkeletonBox(width: 50, height: 22, radius: 6),
                    const SizedBox(width: 6),
                    const SkeletonBox(width: 50, height: 22, radius: 6),
                  ],
                ),
                const SkeletonBox(width: 100, height: 32, radius: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonSkillCard extends StatelessWidget {
  const SkeletonSkillCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        radius: 22,
        child: Column(
          children: [
            Row(
              children: [
                const SkeletonBox(width: 44, height: 44, radius: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 16,
                      ),
                      const SizedBox(height: 6),
                      SkeletonBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 12,
                      ),
                    ],
                  ),
                ),
                const SkeletonBox(width: 32, height: 16),
              ],
            ),
            const SizedBox(height: 12),
            const SkeletonBox(
              width: double.infinity,
              height: 10,
              radius: 5,
            ),
          ],
        ),
      ),
    );
  }
}
