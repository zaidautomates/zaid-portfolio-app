import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../models/project_model.dart';
import '../../widgets/common/app_backdrop.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/network_image_view.dart';
import '../../widgets/common/theme_toggle_button.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/brand_icons.dart';
import '../../widgets/common/animated_card.dart';
import '../../widgets/common/premium_icon_badge.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  String _getFallbackAsset(String title, String id) {
    final searchStr = '$title $id'.toLowerCase();
    if (searchStr.contains('portfolio')) {
      return 'assets/personal_portfolio_app.png';
    } else if (searchStr.contains('ai') || searchStr.contains('workflow')) {
      return 'assets/ai_workflows.png';
    } else if (searchStr.contains('lms') || searchStr.contains('edu') || searchStr.contains('nest')) {
      return 'assets/edunest_lms.png';
    } else if (searchStr.contains('eco') || searchStr.contains('track') || searchStr.contains('carbon')) {
      return 'assets/ecotrack.png';
    } else if (searchStr.contains('connect') || searchStr.contains('network') || searchStr.contains('dev')) {
      return 'assets/devconnect.png';
    } else if (searchStr.contains('smart') || searchStr.contains('iot') || searchStr.contains('home')) {
      return 'assets/smarthome.png';
    }
    return 'assets/personal_portfolio_app.png';
  }

  Future<void> _launchProjectUrl(BuildContext context, String? url) async {
    if (url == null || url.trim().isEmpty) return;
    
    var urlString = url.trim();
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }

    final uri = Uri.tryParse(urlString);
    if (uri != null) {
      try {
        bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
        if (!launched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open link: $urlString')),
          );
        }
      } catch (e) {
        try {
          final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
          if (!launched && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open link: $urlString')),
            );
          }
        } catch (err) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error opening link: $err')),
            );
          }
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid link format')),
        );
      }
    }
  }

  List<String> _getProjectHighlights(ProjectModel project) {
    // Generate mock high-quality highlights since the backend doesn't contain a highlights field
    return [
      'Built using ${project.technologies.take(2).join(" & ")} and modern design patterns.',
      'Completed with status "${project.status}" and ready for portfolio demonstration.',
      'Fully optimized navigation structures and fast API-loaded states.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final fallback = _getFallbackAsset(project.title, project.id);
    final highlights = _getProjectHighlights(project);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Project Details',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.primaryText,
                          ),
                        ),
                      ),
                      const ThemeToggleButton(),
                    ],
                  ),
                  const SizedBox(height: 18),
                  
                  // Beautiful widescreen image banner
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: context.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: NetworkImageView(
                        imageUrl: project.imageUrl,
                        fallbackAsset: fallback,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  
                  GlassCard(
                    radius: 30,
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.cyan.withOpacity(0.15),
                                border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
                              ),
                              child: Text(
                                project.category,
                                style: const TextStyle(
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: project.status == 'Completed'
                                    ? Colors.green.withOpacity(0.15)
                                    : project.status == 'In Progress'
                                        ? Colors.orange.withOpacity(0.15)
                                        : Colors.blue.withOpacity(0.15),
                              ),
                              child: Text(
                                project.status,
                                style: TextStyle(
                                  color: project.status == 'Completed'
                                      ? Colors.greenAccent
                                      : project.status == 'In Progress'
                                          ? Colors.orangeAccent
                                          : Colors.blueAccent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          project.title,
                          style: TextStyle(
                            color: context.primaryText,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          project.technologies.join(' / '),
                          style: const TextStyle(
                            color: AppColors.cyan,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          project.description,
                          style: TextStyle(
                            color: context.softText,
                            height: 1.58,
                            fontSize: 15,
                          ),
                        ),
                        
                        // GitHub / Live Demo Buttons
                        if (project.githubUrl.isNotEmpty || project.liveUrl.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              if (project.githubUrl.isNotEmpty)
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () => _launchProjectUrl(context, project.githubUrl),
                                    icon: CustomPaint(
                                      size: const Size(20, 20),
                                      painter: GitHubLogoPainter(color: Colors.white),
                                    ),
                                    label: const Text('GitHub Repo'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.purple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              if (project.githubUrl.isNotEmpty && project.liveUrl.isNotEmpty)
                                const SizedBox(width: 12),
                              if (project.liveUrl.isNotEmpty)
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () => _launchProjectUrl(context, project.liveUrl),
                                    icon: const Icon(Icons.language),
                                    label: const Text('Live Demo'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.gold,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const SectionHeader(
                    title: 'Technologies Used',
                    subtitle: 'Tools and frameworks used to build this project.',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: project.technologies
                        .map((tech) => SkillChip(label: tech))
                        .toList(),
                  ),
                  const SizedBox(height: 22),
                  const SectionHeader(
                    title: 'Project Highlights',
                    subtitle: 'Key highlights explaining structural and architecture value.',
                  ),
                  const SizedBox(height: 14),
                  ...highlights.map(
                    (highlight) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InfoCard(
                        icon: Icons.check_circle_outline,
                        title: highlight,
                        subtitle: 'Integrated as part of the Week 4 upgrade.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white.withOpacity(0.09)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: context.primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: GlassCard(
        child: Row(
          children: [
            PremiumIconBadge(
              icon: icon,
              size: 46,
              accent: AppColors.gold,
              secondAccent: AppColors.purple,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: context.primaryText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(color: context.mutedText, height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
