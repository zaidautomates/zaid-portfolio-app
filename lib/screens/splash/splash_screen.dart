import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/portfolio_provider.dart';
import '../auth/login_screen.dart';
import '../navigation/main_navigation_screen.dart';
import '../../widgets/common/app_backdrop.dart';
import '../../widgets/common/premium_avatar.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initApp();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initApp() async {
    final authProvider = context.read<AuthProvider>();
    final portfolioProvider = context.read<PortfolioProvider>();

    // 1. Check if token exists in secure storage
    await authProvider.checkAuth();

    if (authProvider.isAuthenticated) {
      // 2. Fetch all portfolio database assets in the background
      await portfolioProvider.fetchPortfolioData();
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTestMode = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PremiumAvatar(size: 100, imageUrl: ''),
                  const SizedBox(height: 24),
                  const Text(
                    'Zaid Ali',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'AI Automation Developer & ML Engineer',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  isTestMode
                      ? const SizedBox(width: 28, height: 28)
                      : const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: AppColors.purple,
                            strokeWidth: 2.5,
                          ),
                        ),
                  const SizedBox(height: 14),
                  Text(
                    'Syncing portfolio data...',
                    style: TextStyle(
                      color: context.mutedText,
                      fontSize: 14,
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
