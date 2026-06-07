import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const ZaidPortfolioApp());
}

class ZaidPortfolioApp extends StatelessWidget {
  const ZaidPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zaid Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.purple,
          brightness: Brightness.dark,
          primary: AppColors.purple,
          secondary: AppColors.cyan,
          tertiary: AppColors.gold,
          surface: AppColors.card,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class AppColors {
  static const bg = Color(0xFF050816);
  static const bgDeep = Color(0xFF0A1020);
  static const card = Color(0xFF101826);
  static const cardBorder = Color(0x26FFFFFF);
  static const purple = Color(0xFF8B5CF6);
  static const cyan = Color(0xFF22D3EE);
  static const gold = Color(0xFFF5C451);
  static const textMuted = Color(0xFF9AA4B2);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainNavigation(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 700;
                final avatarSize = compact ? 92.0 : 108.0;
                final cardPadding = compact ? 18.0 : 22.0;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(compact ? 14 : 22),
                    child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 430),
                          child: GlassCard(
                            padding: EdgeInsets.all(cardPadding),
                            radius: 32,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 2),
                                PremiumAvatar(size: avatarSize),
                                SizedBox(height: compact ? 16 : 22),
                                Text(
                                  'Zaid Ali',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Flutter Developer | AI Automation Builder | Computer Science Student',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14.5,
                                    height: 1.45,
                                  ),
                                ),
                                SizedBox(height: compact ? 14 : 20),
                                const Text(
                                  'Enter the portfolio to explore projects, skills, and internship-ready work.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: compact ? 16 : 22),
                                _authField(
                                  icon: Icons.email_outlined,
                                  hint: 'Email',
                                ),
                                const SizedBox(height: 12),
                                _authField(
                                  icon: Icons.lock_outline,
                                  hint: 'Password',
                                  obscure: true,
                                ),
                                SizedBox(height: compact ? 16 : 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.purple,
                                      foregroundColor: Colors.white,
                                      elevation: 12,
                                      shadowColor: AppColors.purple.withOpacity(
                                        0.35,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text(
                                      'Enter Portfolio',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Welcome to my professional portfolio experience.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _authField({
    required IconData icon,
    required String hint,
    bool obscure = false,
  }) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.cyan),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.cyan, width: 1.2),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  void _selectTab(int value) => setState(() => index = value);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onContactTap: () => _selectTab(3),
        onProjectsTap: () => _selectTab(2),
      ),
      const ProfileScreen(),
      const ProjectsScreen(),
      const ContactScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgDeep.withOpacity(0.92),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.32),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedIndex: index,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              indicatorColor: AppColors.purple.withOpacity(0.28),
              onDestinationSelected: _selectTab,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
                NavigationDestination(
                  icon: Icon(Icons.work_outline),
                  selectedIcon: Icon(Icons.work),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.mail_outline),
                  selectedIcon: Icon(Icons.mail),
                  label: 'Contact',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    return PortfolioPage(
      title: 'Home',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumHeroSection(
            onContactTap: onContactTap,
            onProjectsTap: onProjectsTap,
          ),
          const SizedBox(height: 22),
          const SectionHeader(
            title: 'Stats',
            subtitle:
                'A quick snapshot of the work I have delivered and where I am headed next.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              StatCard(label: 'Projects', value: '3+'),
              StatCard(label: 'Skills', value: '10+'),
              StatCard(label: 'Learning', value: 'AI/ML'),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'What I Do',
            subtitle:
                'Focused on mobile products, automation workflows, and polished software delivery.',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 380;
              if (narrow) {
                return const Column(
                  children: [
                    ActionCard(
                      icon: Icons.phone_android,
                      title: 'Flutter Mobile Apps',
                      subtitle:
                          'Clean interfaces, responsive layouts, and polished user experiences.',
                    ),
                    SizedBox(height: 12),
                    ActionCard(
                      icon: Icons.auto_awesome,
                      title: 'AI Automation',
                      subtitle:
                          'Practical workflows using n8n, APIs, and AI tools to save time.',
                    ),
                    SizedBox(height: 12),
                    ActionCard(
                      icon: Icons.laptop_mac,
                      title: 'Web & Software Development',
                      subtitle:
                          'Modern apps and dashboards built with maintainable code and UX in mind.',
                    ),
                  ],
                );
              }

              return const Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ActionCard(
                          icon: Icons.phone_android,
                          title: 'Flutter Mobile Apps',
                          subtitle:
                              'Clean interfaces, responsive layouts, and polished user experiences.',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ActionCard(
                          icon: Icons.auto_awesome,
                          title: 'AI Automation',
                          subtitle:
                              'Practical workflows using n8n, APIs, and AI tools to save time.',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ActionCard(
                    icon: Icons.laptop_mac,
                    title: 'Web & Software Development',
                    subtitle:
                        'Modern apps and dashboards built with maintainable code and UX in mind.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class PremiumHeroSection extends StatelessWidget {
  final VoidCallback onContactTap;
  final VoidCallback onProjectsTap;

  const PremiumHeroSection({
    super.key,
    required this.onContactTap,
    required this.onProjectsTap,
  });

  @override
  Widget build(BuildContext context) {
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                PremiumAvatar(size: 92),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zaid Ali',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Flutter Developer | AI Automation Builder | Computer Science Student',
                        style: TextStyle(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'I design and build premium mobile experiences, automation workflows, and practical software solutions that feel modern, useful, and ready for internship review.',
              style: TextStyle(
                color: Colors.white70,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
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
                    foregroundColor: Colors.white,
                    side: BorderSide(color: AppColors.cyan.withOpacity(0.65)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
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
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PortfolioPage(
      title: 'Profile',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionHeader(
            title: 'About Me',
            subtitle:
                'A concise summary of my background, mindset, and the kind of work I enjoy.',
          ),
          SizedBox(height: 14),
          GlassCard(
            child: Text(
              'I am Zaid Ali, a Computer Science student in my 6th semester at Abdul Wali Khan University Mardan. I build practical digital products with Flutter, Dart, and modern backend tools. My focus is clean UI, reliable functionality, and automation-driven solutions that improve speed, clarity, and delivery.',
              style: TextStyle(
                height: 1.65,
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 22),
          SectionHeader(
            title: 'Education',
            subtitle: 'Current academic background and learning context.',
          ),
          SizedBox(height: 14),
          InfoCard(
            icon: Icons.school_outlined,
            title: 'BS Computer Science',
            subtitle: 'Abdul Wali Khan University Mardan • 6th Semester',
          ),
          SizedBox(height: 22),
          SectionHeader(
            title: 'Focus Areas',
            subtitle:
                'The main areas I am actively developing and applying in projects.',
          ),
          SizedBox(height: 14),
          FocusAreaGrid(),
          SizedBox(height: 22),
          SectionHeader(
            title: 'Experience',
            subtitle:
                'Selected practical work that reflects my internship-ready skills.',
          ),
          SizedBox(height: 14),
          ExperienceGrid(),
          SizedBox(height: 22),
          SectionHeader(
            title: 'Skills',
            subtitle:
                'Technologies and tools I use across projects and learning.',
          ),
          SizedBox(height: 14),
          SkillWrap(),
        ],
      ),
    );
  }
}

class FocusAreaGrid extends StatelessWidget {
  const FocusAreaGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 380) {
          return const Column(
            children: [
              FocusAreaCard(
                icon: Icons.phone_android,
                title: 'Flutter Mobile Apps',
                subtitle: 'Mobile apps with modern UI and strong structure.',
              ),
              SizedBox(height: 12),
              FocusAreaCard(
                icon: Icons.auto_awesome,
                title: 'AI Automation',
                subtitle: 'n8n workflows, APIs, and productivity systems.',
              ),
              SizedBox(height: 12),
              FocusAreaCard(
                icon: Icons.language,
                title: 'Web & Software',
                subtitle:
                    'Dashboards, interfaces, and practical app solutions.',
              ),
            ],
          );
        }

        return const Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FocusAreaCard(
                    icon: Icons.phone_android,
                    title: 'Flutter Mobile Apps',
                    subtitle:
                        'Mobile apps with modern UI and strong structure.',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: FocusAreaCard(
                    icon: Icons.auto_awesome,
                    title: 'AI Automation',
                    subtitle: 'n8n workflows, APIs, and productivity systems.',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            FocusAreaCard(
              icon: Icons.language,
              title: 'Web & Software',
              subtitle: 'Dashboards, interfaces, and practical app solutions.',
            ),
          ],
        );
      },
    );
  }
}

class SkillWrap extends StatelessWidget {
  const SkillWrap({super.key});

  @override
  Widget build(BuildContext context) {
    const skills = [
      'Flutter',
      'Dart',
      'Python',
      'AI/ML',
      'n8n',
      'React',
      'Supabase',
      'Firebase',
      'Git',
      'UI/UX',
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: skills.map((skill) => SkillChip(label: skill)).toList(),
    );
  }
}

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PortfolioPage(
      title: 'Projects',
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectCard(
            icon: Icons.phone_iphone,
            title: 'Personal Portfolio Mobile App',
            tech: 'Flutter • Dart • Material 3',
            description:
                'A mobile portfolio app with login flow, bottom navigation, profile, projects, contact details, and a modern premium UI.',
          ),
          SizedBox(height: 14),
          ProjectCard(
            icon: Icons.account_tree_outlined,
            title: 'AI Automation Workflows',
            tech: 'n8n • APIs • Google Workspace',
            description:
                'Automation workflows designed to reduce repetitive work, organize information, and improve productivity using AI tools.',
          ),
          SizedBox(height: 14),
          ProjectCard(
            icon: Icons.dashboard_customize_outlined,
            title: 'EduNest LMS Dashboard',
            tech: 'React • Supabase • AI Integration',
            description:
                'A learning management dashboard with authentication, progress views, and AI-assisted learning features.',
          ),
        ],
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PortfolioPage(
      title: 'Contact',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Professional Links',
            subtitle:
                'Ways to reach me for internships and professional collaboration.',
          ),
          const SizedBox(height: 14),
          InfoCard(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'zaidautomates@gmail.com',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Opening Email...')));
            },
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.code,
            title: 'GitHub',
            subtitle: 'github.com/zaidautomates',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening GitHub profile...')),
              );
            },
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.business_center_outlined,
            title: 'LinkedIn',
            subtitle: 'linkedin.com/in/zaidautomates',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening LinkedIn profile...')),
              );
            },
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.phone_outlined,
            title: 'Phone',
            subtitle: 'Available upon request',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Phone details available upon request.'),
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          const InfoCard(
            icon: Icons.work_outline,
            title: 'Open to Internship Opportunities',
            subtitle:
                'Interested in Flutter development, AI automation, and software engineering opportunities.',
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thanks for reaching out. Let us connect.'),
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
          const Center(
            child: Text(
              'Built with Flutter & Dart',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              '© 2026 Zaid Ali',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  final String title;
  final Widget child;

  const PortfolioPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppBackdrop(),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Premium internship-ready personal portfolio',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const PremiumAvatar(size: 52),
                  ],
                ),
                const SizedBox(height: 18),
                child,
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'Professional mobile portfolio submission',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.45,
          colors: [AppColors.bgDeep, AppColors.bg, AppColors.bg],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -48,
            left: -40,
            child: _GlowOrb(color: AppColors.purple, size: 170),
          ),
          Positioned(
            top: 120,
            right: -30,
            child: _GlowOrb(color: AppColors.cyan, size: 150),
          ),
          Positioned(
            bottom: 90,
            left: 24,
            child: _GlowOrb(color: AppColors.gold, size: 130),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.24), color.withOpacity(0.0)],
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final Widget child;

  const AnimatedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.985, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, childWidget) {
        return Transform.scale(scale: value, child: childWidget);
      },
      child: child,
    );
  }
}

class PremiumAvatar extends StatelessWidget {
  final double size;
  final String assetPath;

  const PremiumAvatar({
    super.key,
    required this.size,
    this.assetPath = 'assets/Profile.jpeg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.purple, AppColors.cyan, AppColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.28),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: ClipOval(
          child: Container(
            width: size - 12,
            height: size - 12,
            color: AppColors.bgDeep,
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgDeep,
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: const Center(
                    child: Text(
                      'ZA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: SizedBox(
        width: 104,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          radius: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppColors.purple.withOpacity(0.32),
                    AppColors.cyan.withOpacity(0.18),
                  ],
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      height: 1.45,
                    ),
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

class FocusAreaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FocusAreaCard({
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
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purple.withOpacity(0.18),
              ),
              child: Icon(icon, color: AppColors.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      height: 1.45,
                    ),
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

class ExperienceGrid extends StatelessWidget {
  const ExperienceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 380;
        final cards = [
          const ExperienceCard(
            icon: Icons.phone_android,
            title: 'Flutter Mobile App Development',
            subtitle:
                'Designed premium mobile interfaces, responsive layouts, and polished navigation flows.',
          ),
          const ExperienceCard(
            icon: Icons.auto_awesome,
            title: 'AI Automation Projects',
            subtitle:
                'Built workflow automations with n8n, APIs, and AI tools to simplify repetitive tasks.',
          ),
          const ExperienceCard(
            icon: Icons.dashboard_customize_outlined,
            title: 'LMS Dashboard Development',
            subtitle:
                'Created dashboard-style experiences with structured layouts and clear user flows.',
          ),
          const ExperienceCard(
            icon: Icons.language,
            title: 'Web Application Development',
            subtitle:
                'Contributed to modern web product ideas with React, Supabase, and Firebase.',
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
              const SizedBox(height: 12),
              cards[3],
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
            Row(
              children: [
                Expanded(child: cards[2]),
                const SizedBox(width: 12),
                Expanded(child: cards[3]),
              ],
            ),
          ],
        );
      },
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ExperienceCard({
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.24),
                    AppColors.purple.withOpacity(0.18),
                  ],
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      height: 1.45,
                    ),
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.purple.withOpacity(0.17),
              ),
              child: Icon(icon, color: AppColors.cyan),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      height: 1.45,
                    ),
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: card,
    );
  }
}

class ProjectCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String tech;
  final String description;

  const ProjectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.tech,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.purple.withOpacity(0.30),
                        AppColors.cyan.withOpacity(0.18),
                      ],
                    ),
                  ),
                  child: Icon(icon, color: AppColors.gold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tech,
                        style: const TextStyle(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w700,
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
              description,
              style: const TextStyle(color: Colors.white70, height: 1.55),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Project details coming soon'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: AppColors.gold.withOpacity(0.55)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('View Project'),
              ),
            ),
          ],
        ),
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
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
