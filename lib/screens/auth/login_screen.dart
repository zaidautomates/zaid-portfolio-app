import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../widgets/common/app_backdrop.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/premium_avatar.dart';
import '../navigation/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _passwordVisible = false;

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

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final portfolioProvider = context.read<PortfolioProvider>();

    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      // Pre-fetch portfolio data on successful login
      await portfolioProvider.fetchPortfolioData();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainNavigationScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                child: child,
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.status == AuthStatus.loading;

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
                                    'Zaid Ali',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Flutter Developer | AI Automation Builder',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: context.mutedText,
                                      fontSize: 14.5,
                                      height: 1.45,
                                    ),
                                  ),
                                  SizedBox(height: compact ? 14 : 20),
                                  Text(
                                    'Enter credentials to explore verified projects, dynamic skills, and API-powered portfolio dashboards.',
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
                                    validator: Validators.validateEmail,
                                    enabled: !isLoading,
                                  ),
                                  const SizedBox(height: 12),
                                  _authField(
                                    controller: _passwordController,
                                    icon: Icons.lock_outline,
                                    hint: 'Password',
                                    obscure: !_passwordVisible,
                                    textInputAction: TextInputAction.done,
                                    validator: Validators.validatePassword,
                                    onFieldSubmitted: (_) => isLoading ? null : _login(),
                                    enabled: !isLoading,
                                    suffixIcon: IconButton(
                                      tooltip: _passwordVisible ? 'Hide password' : 'Show password',
                                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                    ),
                                  ),
                                  if (authProvider.errorMessage != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      authProvider.errorMessage!,
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
                                      onPressed: isLoading ? null : _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.purple,
                                        foregroundColor: Colors.white,
                                        elevation: 12,
                                        shadowColor: AppColors.purple.withOpacity(0.35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : const Text(
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
                                    'Powered by secure API-restored sessions.',
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
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
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
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.78),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
