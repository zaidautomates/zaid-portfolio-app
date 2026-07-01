import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/skill_model.dart';
import '../common/animated_card.dart';
import '../common/glass_card.dart';
import '../common/premium_icon_badge.dart';

class SkillProgressCard extends StatelessWidget {
  final SkillModel skill;

  const SkillProgressCard({super.key, required this.skill});

  IconData _getSkillIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('flutter')) {
      return Icons.phone_android;
    } else if (lowerName.contains('dart')) {
      return Icons.data_object_rounded;
    } else if (lowerName.contains('ui') || lowerName.contains('ux') || lowerName.contains('css') || lowerName.contains('html')) {
      return Icons.palette_outlined;
    } else if (lowerName.contains('firebase')) {
      return Icons.local_fire_department;
    } else if (lowerName.contains('react')) {
      return Icons.hub_outlined;
    } else if (lowerName.contains('python')) {
      return Icons.terminal;
    } else if (lowerName.contains('n8n') || lowerName.contains('automation')) {
      return Icons.auto_awesome;
    } else if (lowerName.contains('git')) {
      return Icons.merge_type_rounded;
    } else if (lowerName.contains('node') || lowerName.contains('express')) {
      return Icons.javascript;
    } else if (lowerName.contains('mongo') || lowerName.contains('db') || lowerName.contains('database')) {
      return Icons.storage;
    } else if (lowerName.contains('docker') || lowerName.contains('devops')) {
      return Icons.developer_board;
    }
    return Icons.star_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final percent = skill.proficiency;
    final icon = _getSkillIcon(skill.name);

    return AnimatedCard(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        radius: 22,
        child: Column(
          children: [
            Row(
              children: [
                PremiumIconBadge(
                  icon: icon,
                  customIcon: skill.name.toLowerCase().contains('flutter')
                      ? const FlutterLogo(size: 18)
                      : null,
                  size: 44,
                  accent: AppColors.cyan,
                  secondAccent: AppColors.purple,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: TextStyle(
                          color: context.primaryText,
                          fontWeight: FontWeight.w800,
                          fontSize: 15.5,
                        ),
                      ),
                      Text(
                        '${skill.category} • ${skill.level}',
                        style: TextStyle(
                          color: context.mutedText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: skill.fraction),
              duration: const Duration(milliseconds: 950),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 10,
                    width: double.infinity,
                    color: context.isDarkPortfolio
                        ? Colors.white.withOpacity(0.08)
                        : AppColors.lightMuted.withOpacity(0.14),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: constraints.maxWidth * value,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              gradient: const LinearGradient(
                                colors: [AppColors.cyan, AppColors.purple],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cyan.withOpacity(0.45),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
