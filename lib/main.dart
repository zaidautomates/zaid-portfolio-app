import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

final portfolioState = PortfolioState();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await portfolioState.init();
  runApp(const ZaidPortfolioApp());
}

class ClampedScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class ZaidPortfolioApp extends StatelessWidget {
  const ZaidPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: portfolioState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Zaid Portfolio',
          debugShowCheckedModeBanner: false,
          themeMode: portfolioState.themeMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          scrollBehavior: ClampedScrollBehavior(),
          home: const LoginScreen(),
        );
      },
    );
  }
}

class PortfolioState extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _initialized = false;

  // Theme state
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  // Profile state
  String _name = 'Zaid Ali';
  String get name => _name;

  String _title = 'Flutter Developer | AI Automation Builder | Computer Science Student';
  String get title => _title;

  String _bio = 'I am Zaid Ali, a Computer Science student in my 6th semester at Abdul Wali Khan University Mardan. I build practical digital products with Flutter, Dart, and modern backend tools. My focus is clean UI, reliable functionality, and automation-driven solutions that improve speed, clarity, and delivery.';
  String get bio => _bio;

  // Contact state
  String _email = 'zaidautomates@gmail.com';
  String get email => _email;

  String _phone = 'Available upon request';
  String get phone => _phone;

  bool get initialized => _initialized;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Load theme
    final themeStr = _prefs.getString('pref_theme_mode') ?? 'dark';
    _themeMode = themeStr == 'light' ? ThemeMode.light : ThemeMode.dark;

    // Load profile info
    _name = _prefs.getString('pref_profile_name') ?? 'Zaid Ali';
    _title = _prefs.getString('pref_profile_title') ?? 
        'Flutter Developer | AI Automation Builder | Computer Science Student';
    _bio = _prefs.getString('pref_profile_bio') ?? 
        'I am Zaid Ali, a Computer Science student in my 6th semester at Abdul Wali Khan University Mardan. I build practical digital products with Flutter, Dart, and modern backend tools. My focus is clean UI, reliable functionality, and automation-driven solutions that improve speed, clarity, and delivery.';

    // Load contact info
    _email = _prefs.getString('pref_contact_email') ?? 'zaidautomates@gmail.com';
    _phone = _prefs.getString('pref_contact_phone') ?? 'Available upon request';

    _initialized = true;
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString('pref_theme_mode', mode == ThemeMode.light ? 'light' : 'dark');
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required String title, required String bio}) async {
    _name = name;
    _title = title;
    _bio = bio;
    await _prefs.setString('pref_profile_name', name);
    await _prefs.setString('pref_profile_title', title);
    await _prefs.setString('pref_profile_bio', bio);
    notifyListeners();
  }

  Future<void> updateContact({required String email, required String phone}) async {
    _email = email;
    _phone = phone;
    await _prefs.setString('pref_contact_email', email);
    await _prefs.setString('pref_contact_phone', phone);
    notifyListeners();
  }
}


class AppColors {
  static const bg = Color(0xFF050816);
  static const bgDeep = Color(0xFF0A1020);
  static const lightBg = Color(0xFFF6F3FF);
  static const lightBgDeep = Color(0xFFEAFBFF);
  static const card = Color(0xFF101826);
  static const cardBorder = Color(0x26FFFFFF);
  static const lightCardBorder = Color(0x2A24304A);
  static const purple = Color(0xFF8B5CF6);
  static const cyan = Color(0xFF22D3EE);
  static const gold = Color(0xFFF5C451);
  static const textMuted = Color(0xFF9AA4B2);
  static const lightText = Color(0xFF172033);
  static const lightMuted = Color(0xFF667085);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
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
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.purple,
      brightness: Brightness.light,
      primary: AppColors.purple,
      secondary: const Color(0xFF0891B2),
      tertiary: const Color(0xFFB7791F),
      surface: Colors.white,
    ),
    textTheme: Typography.blackMountainView.apply(
      bodyColor: AppColors.lightText,
      displayColor: AppColors.lightText,
    ),
  );
}

extension PortfolioTheme on BuildContext {
  bool get isDarkPortfolio => Theme.of(this).brightness == Brightness.dark;

  Color get primaryText => isDarkPortfolio ? Colors.white : AppColors.lightText;

  Color get mutedText =>
      isDarkPortfolio ? AppColors.textMuted : AppColors.lightMuted;

  Color get softText =>
      isDarkPortfolio ? Colors.white70 : const Color(0xFF344054);

  Color get cardFill => isDarkPortfolio
      ? Colors.white.withValues(alpha: 0.05)
      : Colors.white.withValues(alpha: 0.9);

  Color get cardBorder =>
      isDarkPortfolio ? AppColors.cardBorder : AppColors.lightCardBorder;

  Color get navFill => isDarkPortfolio
      ? AppColors.bgDeep.withValues(alpha: 0.92)
      : Colors.white.withValues(alpha: 0.92);
}

class PortfolioProject {
  final String id;
  final IconData icon;
  final String title;
  final String tech;
  final String description;
  final String details;
  final List<String> technologies;
  final List<String> highlights;
  final String category;
  final String imagePath;
  final String? gitHubUrl;
  final String? liveUrl;

  const PortfolioProject({
    required this.id,
    required this.icon,
    required this.title,
    required this.tech,
    required this.description,
    required this.details,
    required this.technologies,
    required this.highlights,
    required this.category,
    required this.imagePath,
    this.gitHubUrl,
    this.liveUrl,
  });
}

class SkillLevel {
  final String name;
  final double level;
  final IconData icon;

  const SkillLevel({
    required this.name,
    required this.level,
    required this.icon,
  });
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

const portfolioProjects = [
  PortfolioProject(
    id: 'portfolio_app',
    icon: Icons.phone_iphone,
    title: 'Personal Portfolio Mobile App',
    tech: 'Flutter / Dart / Material 3',
    description:
        'A premium mobile portfolio application designed in Flutter, featuring glassmorphism, dynamic animations, and state persistence.',
    details:
        'This app showcases a personal portfolio in a professional mobile layout. It integrates smooth animations, a password-secured login screen, local database persistence, dynamic profile editing, and search/filter functionality.',
    technologies: ['Flutter', 'Dart', 'Material 3', 'Shared Preferences', 'Animations'],
    highlights: [
      'Sleek glassmorphic card layouts with custom Bezier brand icons',
      'Reactive navigation and state management via ChangeNotifier',
      'Persistent theme settings and local user preferences',
    ],
    category: 'Mobile',
    imagePath: 'assets/personal_portfolio_app.png',
    gitHubUrl: 'https://github.com/zaidautomates/zaid-portfolio-app',
  ),
  PortfolioProject(
    id: 'ai_automation',
    icon: Icons.auto_awesome,
    title: 'AI Automation Workflows',
    tech: 'n8n / APIs / Google Workspace',
    description:
        'Automation workflows designed to reduce repetitive work, organize information, and improve productivity using AI tools.',
    details:
        'An ecosystem of automation scripts and visual workflows built in n8n. It automatically intercepts support emails, processes them using ChatGPT for intent analysis, retrieves context from a vector database, and generates drafts or updates Google Workspace records.',
    technologies: ['n8n', 'OpenAI API', 'Vector Databases', 'Google APIs', 'Python'],
    highlights: [
      'Saves 15+ hours weekly by automating customer ticket triage',
      'Utilizes AI agent logic to intelligently route complex issues',
      'Real-time logging and failure notifications using Discord webhooks',
    ],
    category: 'AI/ML',
    imagePath: 'assets/ai_workflows.png',
    gitHubUrl: 'https://github.com/zaidautomates/ai-workflows',
    liveUrl: 'https://n8n.io',
  ),
  PortfolioProject(
    id: 'edunest_lms',
    icon: Icons.school_outlined,
    title: 'EduNest LMS Dashboard',
    tech: 'React / Supabase / AI Integration',
    description:
        'A learning management dashboard with authentication, progress views, and AI-assisted learning features.',
    details:
        'A web-based portal built for students and instructors. Features include course progress tracking, interactive quizzes, video streaming, and an AI-driven chatbot that answers questions based on course handouts.',
    technologies: ['React.js', 'Supabase', 'Tailwind CSS', 'OpenAI', 'Vite'],
    highlights: [
      'Real-time student progress tracking using Supabase WebSockets',
      'Responsive dark/light layout tailored for high readability',
      'AI assistant integrated using vector embeddings for handout querying',
    ],
    category: 'Web',
    imagePath: 'assets/edunest_lms.png',
    gitHubUrl: 'https://github.com/zaidautomates/edunest-lms',
    liveUrl: 'https://supabase.com',
  ),
  PortfolioProject(
    id: 'ecotrack_app',
    icon: Icons.energy_savings_leaf_outlined,
    title: 'EcoTrack - Carbon Footprint Tracker',
    tech: 'Flutter / SQLite / FL Chart',
    description:
        'A mobile app empowering users to log activities, track carbon emissions, and set green habit reminders.',
    details:
        'EcoTrack makes environmental impact visible. Users can log daily transport, food consumption, and energy use. The app calculates their carbon footprint in real-time, displays progress charts, and suggests carbon-reducing challenges.',
    technologies: ['Flutter', 'Dart', 'SQLite', 'FL Chart', 'Local Notifications'],
    highlights: [
      'Real-time visual graphs of emissions using customized FL Chart',
      'Gamified green challenge cards with point tracking',
      'Daily local notification triggers for eco-friendly reminders',
    ],
    category: 'Mobile',
    imagePath: 'assets/ecotrack.png',
    gitHubUrl: 'https://github.com/zaidautomates/ecotrack',
  ),
  PortfolioProject(
    id: 'devconnect_web',
    icon: Icons.connect_without_contact_outlined,
    title: 'DevConnect - Developer Networking Platform',
    tech: 'Next.js / Node.js / Socket.io / WebRTC',
    description:
        'A collaborative web workspace with real-time text chat, audio calls, and code sharing.',
    details:
        'DevConnect bridges the gap for remote dev teams. It combines a real-time Markdown editor, collaborative code execution blocks, a messaging center with channel divisions, and voice-room integration.',
    technologies: ['Next.js', 'Socket.io', 'WebRTC', 'Express', 'MongoDB'],
    highlights: [
      'Real-time code editing synched using OT (Operational Transformation)',
      'Low-latency voice calling powered by WebRTC peer mesh',
      'Secure user accounts and encrypted direct messaging',
    ],
    category: 'Web',
    imagePath: 'assets/devconnect.png',
    gitHubUrl: 'https://github.com/zaidautomates/devconnect',
  ),
  PortfolioProject(
    id: 'smarthome_iot',
    icon: Icons.settings_remote_outlined,
    title: 'SmartHome IoT Controller',
    tech: 'Vue.js / MQTT / Highcharts / Tailwind',
    description:
        'An administrative panel showing sensor analytics, camera streams, and active appliance toggles.',
    details:
        'A dashboard designed for home automation. It fetches temperature, humidity, and power consumption from local IoT microcontrollers (ESP32) via MQTT, displaying real-time gauges, history charts, and camera feeds.',
    technologies: ['Vue.js', 'MQTT / Mosquitto', 'Highcharts', 'Tailwind CSS', 'Node-RED'],
    highlights: [
      'Sub-second status updates via MQTT protocol integration',
      'Interactive history charts showing appliance power usage over time',
      'Custom automated scenes triggered by environmental thresholds',
    ],
    category: 'Dashboard',
    imagePath: 'assets/smarthome.png',
    gitHubUrl: 'https://github.com/zaidautomates/smarthome-iot',
  ),
];

const portfolioSkills = [
  SkillLevel(name: 'Flutter', level: 0.9, icon: Icons.phone_android),
  SkillLevel(name: 'Dart', level: 0.86, icon: Icons.data_object_rounded),
  SkillLevel(name: 'UI/UX', level: 0.82, icon: Icons.palette_outlined),
  SkillLevel(name: 'Firebase', level: 0.74, icon: Icons.local_fire_department),
  SkillLevel(name: 'React', level: 0.72, icon: Icons.hub_outlined),
  SkillLevel(name: 'Python', level: 0.7, icon: Icons.terminal),
  SkillLevel(name: 'n8n Automation', level: 0.84, icon: Icons.auto_awesome),
  SkillLevel(name: 'Git', level: 0.78, icon: Icons.merge_type_rounded),
];

const socialLinks = [
  SocialLink(
    title: 'LinkedIn',
    subtitle: 'linkedin.com/in/zaidautomates',
    icon: Icons.badge_outlined,
  ),
  SocialLink(
    title: 'GitHub',
    subtitle: 'github.com/zaidautomates',
    icon: Icons.code_rounded,
  ),
  SocialLink(
    title: 'Portfolio Website',
    subtitle: 'zaidautomates.dev',
    icon: Icons.travel_explore_rounded,
  ),
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  static const _passwordSalt = 'codiora-portfolio-v2';
  static const _validPasswordHash = 3724395600;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _passwordVisible = false;
  String? _authError;

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
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _authError = 'Please enter valid portfolio credentials.');
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    final passwordHash = _hashPassword(_passwordController.text);
    final validEmail = portfolioState.email.trim().toLowerCase();

    if (email != validEmail || passwordHash != _validPasswordHash) {
      setState(() => _authError = 'Invalid email or password.');
      return;
    }

    setState(() => _authError = null);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigation(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  int _hashPassword(String password) {
    var hash = 2166136261;
    for (final codeUnit in '$_passwordSalt:$password'.codeUnits) {
      hash = hash ^ codeUnit;
      hash = (hash * 16777619) & 0xFFFFFFFF;
    }
    return hash;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
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
                    physics: const ClampingScrollPhysics(),
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
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 2),
                                  PremiumAvatar(size: avatarSize),
                                  SizedBox(height: compact ? 16 : 22),
                                  Text(
                                    portfolioState.name,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    portfolioState.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: context.mutedText,
                                      fontSize: 14.5,
                                      height: 1.45,
                                    ),
                                  ),
                                  SizedBox(height: compact ? 14 : 20),
                                  Text(
                                    'Enter the portfolio using verified credentials to explore projects, skills, and internship-ready work.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: context.softText,
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: compact ? 16 : 22),
                                  _authField(
                                    controller: _emailController,
                                    icon: Icons.email_outlined,
                                    hint: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: _validateEmail,
                                  ),
                                  const SizedBox(height: 12),
                                  _authField(
                                    controller: _passwordController,
                                    icon: Icons.lock_outline,
                                    hint: 'Password',
                                    obscure: !_passwordVisible,
                                    textInputAction: TextInputAction.done,
                                    validator: _validatePassword,
                                    onFieldSubmitted: (_) => _login(),
                                    suffixIcon: IconButton(
                                      tooltip: _passwordVisible
                                          ? 'Hide password'
                                          : 'Show password',
                                      onPressed: () => setState(
                                        () => _passwordVisible =
                                            !_passwordVisible,
                                      ),
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                    ),
                                  ),
                                  if (_authError != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      _authError!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFFFF6B6B),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
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
                                        shadowColor: AppColors.purple
                                            .withValues(alpha: 0.35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
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
                                  Text(
                                    'Use assigned portfolio credentials to continue.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: context.mutedText),
                                  ),
                                ],
                              ),
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
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    ValueChanged<String>? onFieldSubmitted,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(color: context.primaryText),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.cyan),
        suffixIcon: suffixIcon == null
            ? null
            : IconTheme(
                data: IconThemeData(color: context.mutedText),
                child: suffixIcon,
              ),
        hintText: hint,
        hintStyle: TextStyle(color: context.mutedText),
        errorMaxLines: 2,
        filled: true,
        fillColor: context.isDarkPortfolio
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.78),
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
          borderSide: BorderSide(color: context.cardBorder),
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
              color: context.navFill,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: context.isDarkPortfolio ? 0.32 : 0.12,
                  ),
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
              indicatorColor: AppColors.purple.withValues(alpha: 0.28),
              surfaceTintColor: Colors.transparent,
              onDestinationSelected: _selectTab,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_rounded),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
                NavigationDestination(
                  icon: Icon(Icons.work_outline_rounded),
                  selectedIcon: Icon(Icons.work_rounded),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.mail_outline_rounded),
                  selectedIcon: Icon(Icons.mail_rounded),
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
              StatCard(label: 'Projects', value: '6+'),
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
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 340;
                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(child: PremiumAvatar(size: 92)),
                      const SizedBox(height: 16),
                      Text(
                        portfolioState.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: context.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        portfolioState.title,
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
                    const PremiumAvatar(size: 92),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            portfolioState.name,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: context.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            portfolioState.title,
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
              'I design and build premium mobile experiences, automation workflows, and practical software solutions that feel modern, useful, and ready for internship review.',
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
                    foregroundColor: context.primaryText,
                    side: BorderSide(
                      color: AppColors.cyan.withValues(alpha: 0.65),
                    ),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: SectionHeader(
                  title: 'About Me',
                  subtitle:
                      'A concise summary of my background, mindset, and the kind of work I enjoy.',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.purple),
                tooltip: 'Edit Profile',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileEditScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          GlassCard(
            child: Text(
              portfolioState.bio,
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
            subtitle: 'Current academic background and learning context.',
          ),
          const SizedBox(height: 14),
          const InfoCard(
            icon: Icons.school_outlined,
            title: 'BS Computer Science',
            subtitle: 'Abdul Wali Khan University Mardan / 6th Semester',
          ),
          const SizedBox(height: 22),
          const SectionHeader(
            title: 'Focus Areas',
            subtitle:
                'The main areas I am actively developing and applying in projects.',
          ),
          const SizedBox(height: 14),
          const FocusAreaGrid(),
          const SizedBox(height: 22),
          const SectionHeader(
            title: 'Experience',
            subtitle:
                'Selected practical work that reflects my internship-ready skills.',
          ),
          const SizedBox(height: 14),
          const ExperienceGrid(),
          const SizedBox(height: 22),
          const SectionHeader(
            title: 'Skills',
            subtitle:
                'Technologies and tools I use across projects and learning.',
          ),
          const SizedBox(height: 14),
          const SkillWrap(),
        ],
      ),
    );
  }
}

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _bioController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: portfolioState.name);
    _titleController = TextEditingController(text: portfolioState.title);
    _bioController = TextEditingController(text: portfolioState.bio);
    _emailController = TextEditingController(text: portfolioState.email);
    _phoneController = TextEditingController(text: portfolioState.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final title = _titleController.text.trim();
      final bio = _bioController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();

      await portfolioState.updateProfile(name: name, title: title, bio: bio);
      await portfolioState.updateContact(email: email, phone: phone);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.purple,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: Form(
                key: _formKey,
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
                        Text(
                          'Edit Profile',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _titleController,
                            label: 'Professional Role',
                            icon: Icons.work_outline,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Title is required' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _bioController,
                            label: 'About / Bio',
                            icon: Icons.info_outline,
                            maxLines: 4,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Bio is required' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Email is required';
                              if (!val.contains('@') || !val.contains('.')) return 'Invalid email format';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _phoneController,
                            label: 'Phone',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Phone is required' : null,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: BorderSide(color: context.cardBorder),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: context.primaryText),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: _save,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.purple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text('Save Changes'),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.softText,
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: context.primaryText),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.cyan),
            filled: true,
            fillColor: context.isDarkPortfolio
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.03),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cyan, width: 1.2),
            ),
          ),
        ),
      ],
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
    return Column(
      children: portfolioSkills
          .map(
            (skill) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SkillProgressCard(skill: skill),
            ),
          )
          .toList(),
    );
  }
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Generate categories dynamically
    final categories = ['All', ...portfolioProjects.map((p) => p.category).toSet()];

    // Apply combined filters
    final query = _searchQuery.trim().toLowerCase();
    final filteredProjects = portfolioProjects.where((project) {
      final matchesCategory = _selectedCategory == 'All' || project.category == _selectedCategory;
      final matchesSearch = query.isEmpty ||
          project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query) ||
          project.category.toLowerCase().contains(query) ||
          project.technologies.any((tech) => tech.toLowerCase().contains(query));
      return matchesCategory && matchesSearch;
    }).toList();

    return PortfolioPage(
      title: 'Projects',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            radius: 20,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              style: TextStyle(color: context.primaryText),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: AppColors.cyan),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.purple),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                hintText: 'Search title, tech, description...',
                hintStyle: TextStyle(color: context.mutedText),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          
          // Category Filtering Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : context.primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                    selectedColor: AppColors.purple,
                    backgroundColor: context.isDarkPortfolio
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : context.cardBorder,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          
          // Project Listing or Empty State
          if (filteredProjects.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off_outlined,
                      size: 72,
                      color: AppColors.purple,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Projects Found',
                      style: TextStyle(
                        color: context.primaryText,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your search query or category filter.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.mutedText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                final project = filteredProjects[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: ProjectCard(project: project),
                );
              },
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
          SocialButtonGrid(
            links: socialLinks,
            onTap: (link) {
              final url = link.subtitle.startsWith('http')
                  ? link.subtitle
                  : 'https://${link.subtitle}';
              launchProjectUrl(context, url);
            },
          ),
          const SizedBox(height: 18),
          InfoCard(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: portfolioState.email,
            onTap: () {
              final emailUri = Uri.tryParse('mailto:${portfolioState.email}');
              if (emailUri != null) {
                launchUrl(emailUri);
              }
            },
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.phone_outlined,
            title: 'Phone',
            subtitle: portfolioState.phone,
            onTap: () {
              if (portfolioState.phone.trim() == 'Available upon request') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Phone number is available upon request.'),
                    backgroundColor: AppColors.purple,
                  ),
                );
              } else {
                final phoneUri = Uri.tryParse('tel:${portfolioState.phone.trim()}');
                if (phoneUri != null) {
                  launchUrl(phoneUri, mode: LaunchMode.externalApplication);
                }
              }
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
            physics: const ClampingScrollPhysics(),
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
                          Text(
                            'Premium internship-ready personal portfolio',
                            style: TextStyle(
                              color: context.mutedText,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const ThemeToggleButton(),
                    const SizedBox(width: 10),
                    const PremiumAvatar(size: 52),
                  ],
                ),
                const SizedBox(height: 18),
                child,
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    'Professional mobile portfolio submission',
                    style: TextStyle(color: context.mutedText, fontSize: 12.5),
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
    final colors = context.isDarkPortfolio
        ? const [AppColors.bgDeep, AppColors.bg, AppColors.bg]
        : const [AppColors.lightBgDeep, AppColors.lightBg, Color(0xFFFFFFFF)];

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.45,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -48,
            left: -40,
            child: _GlowOrb(
              color: AppColors.purple,
              size: 170,
              opacity: context.isDarkPortfolio ? 0.24 : 0.13,
            ),
          ),
          Positioned(
            top: 120,
            right: -30,
            child: _GlowOrb(
              color: AppColors.cyan,
              size: 150,
              opacity: context.isDarkPortfolio ? 0.24 : 0.12,
            ),
          ),
          Positioned(
            bottom: 90,
            left: 24,
            child: _GlowOrb(
              color: AppColors.gold,
              size: 130,
              opacity: context.isDarkPortfolio ? 0.24 : 0.11,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _GlowOrb({
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0.0),
          ],
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
            color: context.cardFill,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: context.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: context.isDarkPortfolio ? 0.28 : 0.08,
                ),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: context.primaryText),
            child: child,
          ),
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
            color: AppColors.purple.withValues(alpha: 0.28),
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
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
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
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: context.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: context.mutedText,
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: context.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(color: context.mutedText, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkedInLogoWidget extends StatelessWidget {
  final double size;
  final Color color;

  const LinkedInLogoWidget({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          'in',
          style: TextStyle(
            color: color,
            fontSize: size * 0.82,
            fontWeight: FontWeight.w900,
            fontFamily: 'Inter',
            height: 0.9,
          ),
        ),
      ),
    );
  }
}

class GitHubLogoPainter extends CustomPainter {
  final Color color;

  GitHubLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final sx = size.width / 24.0;
    final sy = size.height / 24.0;

    // Start path at M12 0
    path.moveTo(12 * sx, 0 * sy);
    path.cubicTo(5.374 * sx, 0 * sy, 0 * sx, 5.373 * sy, 0 * sx, 12 * sy);
    path.cubicTo(0 * sx, 17.302 * sy, 3.438 * sx, 21.8 * sy, 8.207 * sx, 23.387 * sy);
    path.cubicTo(8.806 * sx, 23.498 * sy, 9.0 * sx, 23.126 * sy, 9.0 * sx, 22.81 * sy);
    path.lineTo(9.0 * sx, 20.576 * sy);
    path.cubicTo(5.662 * sx, 21.302 * sy, 4.967 * sx, 19.16 * sy, 4.967 * sx, 19.16 * sy);
    path.cubicTo(4.421 * sx, 17.773 * sy, 3.634 * sx, 17.404 * sy, 3.634 * sx, 17.404 * sy);
    path.cubicTo(2.545 * sx, 16.659 * sy, 3.717 * sx, 16.675 * sy, 3.717 * sx, 16.675 * sy);
    path.cubicTo(4.922 * sx, 16.759 * sy, 5.556 * sx, 17.912 * sy, 5.556 * sx, 17.912 * sy);
    path.cubicTo(6.666 * sx, 19.746 * sy, 8.363 * sx, 19.216 * sy, 9.048 * sx, 18.909 * sy);
    path.cubicTo(9.155 * sx, 18.134 * sy, 9.466 * sx, 17.604 * sy, 9.81 * sx, 17.305 * sy);
    path.cubicTo(7.145 * sx, 17.0 * sy, 4.343 * sx, 15.971 * sy, 4.343 * sx, 11.374 * sy);
    path.cubicTo(4.343 * sx, 10.063 * sy, 4.812 * sx, 8.993 * sy, 5.579 * sx, 8.153 * sy);
    path.cubicTo(5.455 * sx, 7.85 * sy, 5.044 * sx, 6.629 * sy, 5.696 * sx, 4.977 * sy);
    path.cubicTo(5.696 * sx, 4.977 * sy, 6.704 * sx, 4.655 * sy, 8.997 * sx, 6.207 * sy);
    path.cubicTo(9.954 * sx, 5.941 * sy, 10.98 * sx, 5.808 * sy, 12.0 * sx, 5.803 * sy);
    path.cubicTo(13.02 * sx, 5.808 * sy, 14.047 * sx, 5.941 * sy, 15.006 * sx, 6.207 * sy);
    path.cubicTo(17.297 * sx, 4.655 * sy, 18.303 * sx, 4.977 * sy, 18.303 * sx, 4.977 * sy);
    path.cubicTo(18.956 * sx, 6.63 * sy, 18.545 * sx, 7.851 * sy, 18.421 * sx, 8.153 * sy);
    path.cubicTo(19.191 * sx, 8.993 * sy, 19.656 * sx, 10.064 * sy, 19.656 * sx, 11.374 * sy);
    path.cubicTo(19.656 * sx, 15.983 * sy, 16.849 * sx, 16.998 * sy, 14.177 * sx, 17.295 * sy);
    path.cubicTo(14.607 * sx, 17.667 * sy, 15.0 * sx, 18.397 * sy, 15.0 * sx, 19.517 * sy);
    path.lineTo(15.0 * sx, 22.81 * sy);
    path.cubicTo(15.0 * sx, 23.129 * sy, 15.192 * sx, 23.504 * sy, 15.801 * sx, 23.386 * sy);
    path.cubicTo(20.566 * sx, 21.797 * sy, 24.0 * sx, 17.3 * sy, 24.0 * sx, 12.0 * sy);
    path.cubicTo(24.0 * sx, 5.373 * sy, 18.627 * sx, 0 * sy, 12.0 * sx, 0 * sy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PremiumIconBadge extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final double size;
  final Color accent;
  final Color? secondAccent;
  final BorderRadiusGeometry? borderRadius;

  const PremiumIconBadge({
    super.key,
    this.icon,
    this.customIcon,
    this.size = 48,
    this.accent = AppColors.cyan,
    this.secondAccent,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(size * 0.34);
    final secondary = secondAccent ?? AppColors.purple;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: context.isDarkPortfolio ? 0.34 : 0.22),
            secondary.withValues(alpha: context.isDarkPortfolio ? 0.22 : 0.14),
          ],
        ),
        border: Border.all(
          color: accent.withValues(
            alpha: context.isDarkPortfolio ? 0.34 : 0.22,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(
              alpha: context.isDarkPortfolio ? 0.18 : 0.12,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -size * 0.16,
            top: -size * 0.18,
            child: Container(
              width: size * 0.46,
              height: size * 0.46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(
                  alpha: context.isDarkPortfolio ? 0.08 : 0.42,
                ),
              ),
            ),
          ),
          Center(
            child: customIcon ?? (icon != null ? Icon(
              icon,
              color: context.isDarkPortfolio ? Colors.white : accent,
              size: size * 0.48,
            ) : const SizedBox.shrink()),
          ),
        ],
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
            PremiumIconBadge(
              icon: icon,
              size: 46,
              accent: AppColors.gold,
              secondAccent: AppColors.purple,
              borderRadius: BorderRadius.circular(999),
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
            PremiumIconBadge(
              icon: icon,
              accent: AppColors.gold,
              secondAccent: AppColors.cyan,
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
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
            child: AnimatedCard(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: InkWell(
                    onTap: () => onTap(link),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: context.cardFill,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.cardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: context.isDarkPortfolio ? 0.22 : 0.06,
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
                                  color: context.isDarkPortfolio ? Colors.white : brandColor,
                                )
                              : link.title == 'GitHub'
                                  ? CustomPaint(
                                      size: const Size(22, 22),
                                      painter: GitHubLogoPainter(
                                        color: context.isDarkPortfolio ? Colors.white : brandColor,
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

class ProjectCard extends StatelessWidget {
  final PortfolioProject project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProjectDetailScreen(project: project),
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
    return AnimatedCard(
      child: InkWell(
        onTap: () => _openDetails(context),
        borderRadius: BorderRadius.circular(22),
        child: GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      child: Image.asset(
                        project.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.card,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 24,
                            color: AppColors.textMuted,
                          ),
                        ),
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.cyan.withValues(alpha: 0.12),
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
                          project.tech,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: context.isDarkPortfolio
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.03),
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
                  OutlinedButton.icon(
                    onPressed: () => _openDetails(context),
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: const Text(
                      'View Project',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.primaryText,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      side: BorderSide(
                        color: AppColors.gold.withValues(alpha: 0.6),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkPortfolio;

    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: InkWell(
        onTap: () {
          portfolioState.updateTheme(isDark ? ThemeMode.light : ThemeMode.dark);
        },
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: context.cardFill,
            border: Border.all(color: context.cardBorder),
          ),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: isDark ? AppColors.gold : AppColors.purple,
          ),
        ),
      ),
    );
  }
}

Future<void> launchProjectUrl(BuildContext context, String? url) async {
  if (url == null || url.trim().isEmpty) return;
  
  var urlString = url.trim();
  if (!urlString.startsWith('http://') && !urlString.startsWith('https://') && 
      !urlString.startsWith('mailto:') && !urlString.startsWith('tel:')) {
    urlString = 'https://$urlString';
  }

  final uri = Uri.tryParse(urlString);
  if (uri != null) {
    try {
      // Try launching in external application directly (e.g. Chrome/Safari or external apps)
      bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Fallback to platform default
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $urlString')),
        );
      }
    } catch (e) {
      // Fallback try-catch in case LaunchMode.externalApplication throws on some platforms
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

class ProjectDetailScreen extends StatelessWidget {
  final PortfolioProject project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
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
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const ThemeToggleButton(),
                    ],
                  ),
                  const SizedBox(height: 18),
                  
                  // Beautiful and Professional Project Preview Image Banner
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
                      child: Image.asset(
                        project.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.card,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                        ),
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
                                color: AppColors.cyan.withValues(alpha: 0.15),
                                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
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
                          project.tech,
                          style: const TextStyle(
                            color: AppColors.cyan,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          project.details,
                          style: TextStyle(
                            color: context.softText,
                            height: 1.58,
                            fontSize: 15,
                          ),
                        ),
                        
                        // GitHub / Live Demo Buttons
                        if ((project.gitHubUrl != null && project.gitHubUrl!.trim().isNotEmpty) || 
                            (project.liveUrl != null && project.liveUrl!.trim().isNotEmpty)) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              if (project.gitHubUrl != null && project.gitHubUrl!.trim().isNotEmpty)
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () => launchProjectUrl(context, project.gitHubUrl),
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
                              if (project.gitHubUrl != null && project.liveUrl != null && 
                                  project.gitHubUrl!.trim().isNotEmpty && project.liveUrl!.trim().isNotEmpty)
                                const SizedBox(width: 12),
                              if (project.liveUrl != null && project.liveUrl!.trim().isNotEmpty)
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () => launchProjectUrl(context, project.liveUrl),
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
                    subtitle:
                        'Tools and frameworks used to build or design this project.',
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
                    subtitle:
                        'Key points that show the project value and user experience.',
                  ),
                  const SizedBox(height: 14),
                  ...project.highlights.map(
                    (highlight) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InfoCard(
                        icon: Icons.check_circle_outline,
                        title: highlight,
                        subtitle: 'Included as part of the Week 2 upgrade.',
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

class SkillProgressCard extends StatelessWidget {
  final SkillLevel skill;

  const SkillProgressCard({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final percent = (skill.level * 100).round();

    return AnimatedCard(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        radius: 22,
        child: Column(
          children: [
            Row(
              children: [
                PremiumIconBadge(
                  icon: skill.icon,
                  customIcon: skill.name == 'Flutter'
                      ? const FlutterLogo(size: 18)
                      : null,
                  size: 44,
                  accent: AppColors.cyan,
                  secondAccent: AppColors.purple,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    skill.name,
                    style: TextStyle(
                      color: context.primaryText,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                    ),
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
              tween: Tween(begin: 0, end: skill.level),
              duration: const Duration(milliseconds: 850),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 9,
                    backgroundColor: context.isDarkPortfolio
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.lightMuted.withValues(alpha: 0.14),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.purple,
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

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
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
