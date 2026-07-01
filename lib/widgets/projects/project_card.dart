import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/project_model.dart';
import '../../screens/projects/project_details_screen.dart';
import '../common/animated_card.dart';
import '../common/glass_card.dart';
import '../common/network_image_view.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  String _getFallbackAsset(String title, String id) {
    final searchStr = '$title $id'.toLowerCase();
    if (searchStr.contains('portfolio')) {
      return 'assets/personal_portfolio_app.png';
    } else if (searchStr.contains('ai') || searchStr.contains('workflow') ||
        searchStr.contains('yolo') || searchStr.contains('sepsis') ||
        searchStr.contains('pashto') || searchStr.contains('asr') ||
        searchStr.contains('ml') || searchStr.contains('machine')) {
      return 'assets/ai_workflows.png';
    } else if (searchStr.contains('lms') ||
        searchStr.contains('edu') ||
        searchStr.contains('nest')) {
      return 'assets/edunest_lms.png';
    } else if (searchStr.contains('n8n') ||
        searchStr.contains('automat') ||
        searchStr.contains('pipeline')) {
      return 'assets/ai_workflows.png';
    }
    return 'assets/personal_portfolio_app.png';
  }

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProjectDetailsScreen(project: project),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fallback = _getFallbackAsset(project.title, project.id);

    // GestureDetector on the outside so tap goes through AnimatedCard
    // without InkWell sitting between AnimatedCard and GlassCard's BackdropFilter
    return AnimatedCard(
      child: GestureDetector(
        onTap: () => _openDetails(context),
        child: GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project image thumbnail
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: context.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: NetworkImageView(
                        imageUrl: project.imageUrl,
                        fallbackAsset: fallback,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                project.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: context.primaryText,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.cyan.withOpacity(0.12),
                              ),
                              child: Text(
                                project.category,
                                style: const TextStyle(
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project.technologies.join(' / '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.softText,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.softText,
                  fontSize: 13.5,
                  height: 1.48,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 6,
                    children: project.technologies.take(2).map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: context.isDarkPortfolio
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.03),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            color: context.mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Plain styled container instead of OutlinedButton to avoid
                  // extra ripple layers inside GlassCard
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.6),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.open_in_new,
                          size: 13,
                          color: context.primaryText,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'View Project',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: context.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}