import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/storage/preferences_service.dart';
import 'core/network/api_client.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/portfolio_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ZaidPortfolioApp(prefs: prefs));
}

class ZaidPortfolioApp extends StatelessWidget {
  final SharedPreferences? prefs;

  const ZaidPortfolioApp({super.key, this.prefs});

  @override
  Widget build(BuildContext context) {
    final isTestMode = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
    if (isTestMode) {
      // Avoid compiler warnings by casting if needed, but it is standard
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});
    }

    if (prefs != null) {
      return _buildApp(prefs!);
    }
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Color(0xFF050816),
              body: Center(
                child: SizedBox(width: 32, height: 32),
              ),
            ),
          );
        }
        return _buildApp(snapshot.data!);
      },
    );
  }

  Widget _buildApp(SharedPreferences sharedPreferences) {
    return MultiProvider(
      providers: [
        Provider<SecureStorageService>(
          create: (_) => SecureStorageService(),
        ),
        Provider<PreferencesService>(
          create: (_) => PreferencesService(sharedPreferences),
        ),
        ProxyProvider<SecureStorageService, ApiClient>(
          update: (_, secureStorage, __) => ApiClient(secureStorage),
        ),
        ChangeNotifierProxyProvider2<ApiClient, SecureStorageService, AuthProvider>(
          create: (context) => AuthProvider(
            context.read<ApiClient>(),
            context.read<SecureStorageService>(),
          ),
          update: (_, apiClient, secureStorage, previous) =>
              previous ?? AuthProvider(apiClient, secureStorage),
        ),
        ChangeNotifierProxyProvider<ApiClient, PortfolioProvider>(
          create: (context) => PortfolioProvider(context.read<ApiClient>()),
          update: (_, apiClient, previous) =>
              previous ?? PortfolioProvider(apiClient),
        ),
        ChangeNotifierProxyProvider<PreferencesService, ThemeProvider>(
          create: (context) => ThemeProvider(context.read<PreferencesService>()),
          update: (_, prefsService, previous) =>
              previous ?? ThemeProvider(prefsService),
        ),
      ],
      child: const PortfolioMaterialApp(),
    );
  }
}

class PortfolioMaterialApp extends StatelessWidget {
  const PortfolioMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Zaid Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
