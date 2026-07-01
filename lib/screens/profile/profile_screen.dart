import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/app_backdrop.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/animated_card.dart';
import '../../widgets/common/premium_avatar.dart';
import '../../widgets/common/premium_icon_badge.dart';
import '../../widgets/common/skeleton_loader.dart';

import '../../widgets/common/section_header.dart';
import '../../widgets/common/app_loading_indicator.dart';
import '../../widgets/profile/skill_progress_card.dart';
import '../auth/login_screen.dart';
import './edit_profile_screen.dart';
import '../../widgets/common/app_page_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.cyan),
                title: Text('Choose from Gallery', style: TextStyle(color: context.primaryText)),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.purple),
                title: Text('Take a Photo', style: TextStyle(color: context.primaryText)),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      final sizeInBytes = await file.length();
      final sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > 5) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image file exceeds the 5MB size limit.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        final portfolioProvider = context.read<PortfolioProvider>();
        final success = await portfolioProvider.uploadProfileImage(file);

        if (context.mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile image updated successfully!'),
                backgroundColor: AppColors.purple,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(portfolioProvider.errorMessage ?? 'Failed to upload image.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: TextStyle(color: context.primaryText)),
        content: Text('Are you sure you want to log out from your portfolio session?',
            style: TextStyle(color: context.softText)),
        backgroundColor: context.isDarkPortfolio ? AppColors.bgDeep : Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: context.mutedText)),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              final authProvider = context.read<AuthProvider>();
              final portfolioProvider = context.read<PortfolioProvider>();
              
              await authProvider.logout();
              portfolioProvider.clear();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
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
            AppLoadingIndicator(message: 'Syncing profile data...'),
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
                      title: 'Profile',
                      subtitle: 'Credentials restored & database verified',
                      profileImageUrl: user.profileImage,
                      rightAction: IconButton(
                        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                        tooltip: 'Logout session',
                        onPressed: () => _showLogoutDialog(context),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Profile Header card
                    GlassCard(
                      child: Column(
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                PremiumAvatar(size: 110, imageUrl: user.profileImage),
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.purple,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                                    onPressed: () => _pickAndUploadImage(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: context.primaryText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user.role,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.gold),
                              const SizedBox(width: 4),
                              Text(
                                user.location,
                                style: TextStyle(color: context.mutedText, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: SectionHeader(
                            title: 'About Me',
                            subtitle: 'A concise summary of my background, mindset, and interests.',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.purple),
                          tooltip: 'Edit Profile Details',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GlassCard(
                      child: Text(
                        user.about,
                        style: TextStyle(
                          height: 1.65,
                          color: context.softText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    const SectionHeader(
                      title: 'Education',
                      subtitle: 'Current academic credentials & background.',
                    ),
                    const SizedBox(height: 14),
                    InfoCard(
                      icon: Icons.school_outlined,
                      title: 'Degree Program',
                      subtitle: user.education,
                    ),
                    if (user.careerGoals.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      const SectionHeader(
                        title: 'Career Goals',
                        subtitle: 'Primary professional objective and targets.',
                      ),
                      const SizedBox(height: 14),
                      InfoCard(
                        icon: Icons.track_changes_rounded,
                        title: 'Future Targets',
                        subtitle: user.careerGoals,
                      ),
                    ],
                    const SizedBox(height: 22),

                    const SectionHeader(
                      title: 'Skills & Proficiencies',
                      subtitle: 'Technical capabilities loaded dynamically from the backend.',
                    ),
                    const SizedBox(height: 14),
                    if (portfolioProvider.skills.isEmpty)
                      if (portfolioProvider.status == PortfolioStatus.loading)
                        const Column(
                          children: [
                            SkeletonSkillCard(),
                            SizedBox(height: 12),
                            SkeletonSkillCard(),
                            SizedBox(height: 12),
                            SkeletonSkillCard(),
                          ],
                        )
                      else
                        Center(
                          child: Text(
                            'No skills loaded yet.',
                            style: TextStyle(color: context.mutedText),
                          ),
                        )
                    else
                      Column(
                        children: portfolioProvider.skills
                            .map((skill) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: SkillProgressCard(skill: skill),
                                ))
                            .toList(),
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
  }
}
