import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import './network_image_view.dart';

class PremiumAvatar extends StatefulWidget {
  final double size;
  final String imageUrl;

  const PremiumAvatar({
    super.key,
    required this.size,
    this.imageUrl = '',
  });

  @override
  State<PremiumAvatar> createState() => _PremiumAvatarState();
}

class _PremiumAvatarState extends State<PremiumAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    final isTestMode = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTestMode) {
      _controller.repeat();
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.purple.withOpacity(0.3),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _controller.value * 2.0 * 3.1415926535,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [AppColors.purple, AppColors.cyan, AppColors.gold, AppColors.purple],
                      stops: [0.0, 0.33, 0.67, 1.0],
                    ),
                  ),
                ),
              ),
              ClipOval(
                child: Container(
                  width: widget.size - 8,
                  height: widget.size - 8,
                  color: AppColors.bgDeep,
                  child: NetworkImageView(
                    imageUrl: widget.imageUrl,
                    fallbackAsset: 'assets/Profile.jpeg',
                    width: widget.size - 8,
                    height: widget.size - 8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
