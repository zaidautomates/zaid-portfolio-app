import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'theme_toggle_button.dart';
import 'premium_avatar.dart';

class AppPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String profileImageUrl;
  final Widget? rightAction;

  const AppPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.profileImageUrl,
    this.rightAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left: Theme Toggle
        const SizedBox(
          width: 52,
          child: Align(
            alignment: Alignment.centerLeft,
            child: ThemeToggleButton(),
          ),
        ),
        
        // Center: Centered Headline and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryText,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.mutedText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        
        // Right: Consistent Avatar or Action
        SizedBox(
          width: 52,
          child: Align(
            alignment: Alignment.centerRight,
            child: rightAction ?? PremiumAvatar(size: 40, imageUrl: profileImageUrl),
          ),
        ),
      ],
    );
  }
}
