import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import './glass_card.dart';

class AppLoadingIndicator extends StatelessWidget {
  final String message;

  const AppLoadingIndicator({
    super.key,
    this.message = 'Loading portfolio assets...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: GlassCard(
          radius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: AppColors.purple,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.mutedText,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
