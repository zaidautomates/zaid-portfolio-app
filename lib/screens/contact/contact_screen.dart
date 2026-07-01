import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/portfolio_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/app_backdrop.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/animated_card.dart';
import '../../widgets/common/premium_avatar.dart';
import '../../widgets/common/premium_icon_badge.dart';
import '../../widgets/common/theme_toggle_button.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/app_loading_indicator.dart';
import '../../widgets/common/brand_icons.dart';
import '../../widgets/common/app_page_header.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchProjectUrl(BuildContext context, String? url) async {
    if (url == null || url.trim().isEmpty) return;
    
    var urlString = url.trim();
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://') && 
        !urlString.startsWith('mailto:') && !urlString.startsWith('tel:')) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    final user = portfolioProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Stack(
          children: [
            AppBackdrop(),
            AppLoadingIndicator(message: 'Syncing contact details...'),
          ],
        ),
      );
    }

    final socialLinks = [
      if (user.linkedin.isNotEmpty)
        SocialLink(
          title: 'LinkedIn',
          subtitle: user.linkedin,
          icon: Icons.badge_outlined,
        ),
      if (user.github.isNotEmpty)
        SocialLink(
          title: 'GitHub',
          subtitle: user.github,
          icon: Icons.code_rounded,
        ),
      if (user.website.isNotEmpty)
        SocialLink(
          title: 'Portfolio Website',
          subtitle: user.website,
          icon: Icons.travel_explore_rounded,
        ),
    ];

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
                      title: 'Contact',
                      subtitle: 'Sync dynamic backend contact channels',
                      profileImageUrl: user.profileImage,
                    ),
                    const SizedBox(height: 22),
                    
                    const SectionHeader(
                      title: 'Professional Links',
                      subtitle: 'Ways to reach me for internships and professional collaboration.',
                    ),
                    const SizedBox(height: 14),
                    
                    if (socialLinks.isEmpty)
                      Center(
                        child: Text(
                          'No social links available.',
                          style: TextStyle(color: context.mutedText),
                        ),
                      )
                    else
                      SocialButtonGrid(
                        links: socialLinks,
                        onTap: (link) => _launchProjectUrl(context, link.subtitle),
                      ),
                    
                    const SizedBox(height: 18),
                    InfoCard(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: user.email,
                      onTap: () {
                        final emailUri = Uri.tryParse('mailto:${user.email}');
                        if (emailUri != null) {
                          launchUrl(emailUri);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    InfoCard(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      subtitle: user.phone.isEmpty ? 'Available upon request' : user.phone,
                      onTap: () {
                        if (user.phone.trim() == 'Available upon request' || user.phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone number is available upon request.'),
                              backgroundColor: AppColors.purple,
                            ),
                          );
                        } else {
                          final phoneUri = Uri.tryParse('tel:${user.phone.trim()}');
                          if (phoneUri != null) {
                            launchUrl(phoneUri, mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    InfoCard(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      subtitle: user.location.isEmpty ? 'KPK, Pakistan' : user.location,
                    ),
                    const SizedBox(height: 22),
                    const InfoCard(
                      icon: Icons.work_outline,
                      title: 'Open to Internship Opportunities',
                      subtitle: 'Interested in Flutter development, AI automation, and software engineering opportunities.',
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Thanks for reaching out! Looking forward to connecting.'),
                              backgroundColor: AppColors.purple,
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Let's Connect",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Text(
                        'Built with Flutter & Dart',
                        style: TextStyle(
                          color: context.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        'Copyright 2026 Zaid Ali',
                        style: TextStyle(color: context.mutedText, fontSize: 12.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialLink {
  final String title;
  final String subtitle;
  final IconData icon;

  const SocialLink({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = AnimatedCard(
      child: GlassCard(
        child: Row(
          children: [
            PremiumIconBadge(
              icon: icon,
              size: 50,
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

    if (onTap == null) {
      return card;
    }

    // GestureDetector instead of InkWell — avoids rect artifact from
    // InkWell's ripple layer clashing with GlassCard's BackdropFilter save-layer.
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: card,
    );
  }
}

class SocialButtonGrid extends StatelessWidget {
  final List<SocialLink> links;
  final ValueChanged<SocialLink> onTap;

  const SocialButtonGrid({super.key, required this.links, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: links.map((link) {
        final brandColor = link.title == 'LinkedIn'
            ? const Color(0xFF0A66C2)
            : link.title == 'GitHub'
                ? (context.isDarkPortfolio ? Colors.white : const Color(0xFF24292E))
                : AppColors.cyan;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Tooltip(
            message: link.title,
            // GestureDetector wraps AnimatedCard so the tap is handled
            // outside the BackdropFilter save-layer — no rect artifact.
            child: GestureDetector(
              onTap: () => onTap(link),
              child: AnimatedCard(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: context.cardFill,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.cardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              context.isDarkPortfolio ? 0.22 : 0.06,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: PremiumIconBadge(
                          icon: link.icon,
                          customIcon: link.title == 'LinkedIn'
                              ? LinkedInLogoWidget(
                                  size: 23,
                                  color: context.isDarkPortfolio
                                      ? Colors.white
                                      : brandColor,
                                )
                              : link.title == 'GitHub'
                                  ? CustomPaint(
                                      size: const Size(22, 22),
                                      painter: GitHubLogoPainter(
                                        color: context.isDarkPortfolio
                                            ? Colors.white
                                            : brandColor,
                                      ),
                                    )
                                  : null,
                          size: 48,
                          accent: brandColor,
                          secondAccent: AppColors.purple,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}