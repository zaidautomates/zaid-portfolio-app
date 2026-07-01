import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    } else if (Platform.isAndroid) {
      // 10.0.2.2 is the IP address pointing to the host loopback interface in Android emulators
      return 'http://10.0.2.2:5000/api';
    } else {
      return 'http://localhost:5000/api';
    }
  }

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Profile endpoints
  static const String profile = '/profile';
  static const String profileAbout = '/profile/about';
  static const String profileContact = '/profile/contact';
  static const String profileSocial = '/profile/social';
  static const String profileSeed = '/profile/seed';

  // Other endpoints
  static const String skills = '/skills';
  static const String projects = '/projects';
  static const String categories = '/categories';
}
