import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import './glass_card.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: GlassCard(
          radius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 64,
                color: AppColors.purple,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  color: context.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.mutedText,
                  fontSize: 14.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
