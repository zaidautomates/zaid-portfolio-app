import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/app_backdrop.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/animated_card.dart';
import '../../widgets/common/premium_avatar.dart';
import '../../widgets/common/theme_toggle_button.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/app_loading_indicator.dart';
import '../../widgets/common/app_error_view.dart';
import '../../widgets/common/premium_icon_badge.dart';
import '../../widgets/common/app_page_header.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onContactTap;
  final VoidCallback onProjectsTap;

  const HomeScreen({
    super.key,
    required this.onContactTap,
    required this.onProjectsTap,
  });

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);

    if (portfolioProvider.status == PortfolioStatus.loading) {
      return const Scaffold(
        body: Stack(
          children: [
            AppBackdrop(),
            AppLoadingIndicator(message: 'Loading your portfolio...'),
          ],
        ),
      );
    }

    if (portfolioProvider.status == PortfolioStatus.error) {
      return Scaffold(
        body: Stack(
          children: [
            const AppBackdrop(),
            AppErrorView(
              errorMessage: portfolioProvider.errorMessage ?? 'Failed to load portfolio.',
              onRetry: () => portfolioProvider.fetchPortfolioData(),
            ),
          ],
        ),
      );
    }

    final user = portfolioProvider.user;
    if (user == null) {
      return Scaffold(
        body: Stack(
          children: [
            const AppBackdrop(),
            AppErrorView(
              errorMessage: 'No profile information found on the server.',
              onRetry: () => portfolioProvider.fetchPortfolioData(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () => portfolioProvider.fetchPortfolioData(),
              color: AppColors.purple,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppPageHeader(
                      title: 'Home',
                      subtitle: 'Premium internship-ready personal portfolio',
                      profileImageUrl: user.profileImage,
                    ),
                    const SizedBox(height: 22),
                    _buildHeroSection(context, user),
                    const SizedBox(height: 22),
                    const SectionHeader(
                      title: 'Stats',
                      subtitle: 'A quick snapshot of the work I have delivered and where I am headed next.',
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        StatCard(
                          label: 'Projects',
                          value: '${portfolioProvider.projects.length}+',
                          baseColor: const Color(0xFF0284C7),
                          shadowColor: const Color(0xFF0C4A6E),
                          highlightColor: Colors.white,
                        ),
                        StatCard(
                          label: 'Skills',
                          value: '${portfolioProvider.skills.length}+',
                          baseColor: const Color(0xFF7C3AED),
                          shadowColor: const Color(0xFF4C1D95),
                          highlightColor: Colors.white,
                        ),
                        const StatCard(
                          label: 'Learning',
                          value: 'AI/ML',
                          baseColor: const Color(0xFFD97706),
                          shadowColor: const Color(0xFF78350F),
                          highlightColor: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(
                      title: 'What I Do',
                      subtitle: 'Focused on mobile products, automation workflows, and polished software delivery.',
                    ),
                    const SizedBox(height: 14),
                    _buildWhatIDo(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, user) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GlassCard(
        radius: 34,
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 340;
                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: PremiumAvatar(size: 92, imageUrl: user.profileImage)),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: context.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.role,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PremiumAvatar(size: 92, imageUrl: user.profileImage),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: context.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.role,
                            style: const TextStyle(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            Text(
              user.tagline,
              style: TextStyle(
                color: context.softText,
                fontSize: 15.5,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: onContactTap,
                  icon: const Icon(Icons.mail_outline),
                  label: const Text('Contact Me'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onProjectsTap,
                  icon: const Icon(Icons.work_outline),
                  label: const Text('View Projects'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.primaryText,
                    side: BorderSide(
                      color: AppColors.cyan.withOpacity(0.65),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatIDo(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 380;
        final cards = [
          const ActionCard(
            icon: Icons.phone_android,
            title: 'Flutter Mobile Apps',
            subtitle: 'Clean interfaces, responsive layouts, and polished user experiences.',
          ),
          const ActionCard(
            icon: Icons.auto_awesome,
            title: 'AI Automation',
            subtitle: 'Practical workflows using n8n, APIs, and AI tools to save time.',
          ),
          const ActionCard(
            icon: Icons.laptop_mac,
            title: 'Web & Software Development',
            subtitle: 'Modern apps and dashboards built with maintainable code and UX in mind.',
          ),
        ];

        if (narrow) {
          return Column(
            children: [
              cards[0],
              const SizedBox(height: 12),
              cards[1],
              const SizedBox(height: 12),
              cards[2],
            ],
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 12),
                Expanded(child: cards[1]),
              ],
            ),
            const SizedBox(height: 12),
            cards[2],
          ],
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color baseColor;
  final Color shadowColor;
  final Color highlightColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.baseColor,
    required this.shadowColor,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: Container(
        width: 104,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: baseColor,
          border: Border.all(
            color: Colors.white.withOpacity(0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(4, 6),
            ),
            BoxShadow(
              color: highlightColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(-3, -4),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.24),
              Colors.white.withOpacity(0.0),
              Colors.black.withOpacity(0.25),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ActionCard({
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PremiumIconBadge(
              icon: icon,
              accent: AppColors.cyan,
              secondAccent: AppColors.purple,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: context.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
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
