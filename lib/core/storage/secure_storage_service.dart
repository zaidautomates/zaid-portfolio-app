import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();
  
  // In-memory cache for test mode to avoid native method channel hangs
  final Map<String, String> _testCache = {};

  static const String _keyToken = 'auth_token';
  static const String _keyUserEmail = 'user_email';

  bool get _isTestMode => !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  Future<void> saveToken(String token) async {
    if (_isTestMode) {
      _testCache[_keyToken] = token;
      return;
    }
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    if (_isTestMode) {
      return _testCache[_keyToken];
    }
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    if (_isTestMode) {
      _testCache.remove(_keyToken);
      return;
    }
    await _storage.delete(key: _keyToken);
  }

  Future<void> saveUserEmail(String email) async {
    if (_isTestMode) {
      _testCache[_keyUserEmail] = email;
      return;
    }
    await _storage.write(key: _keyUserEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    if (_isTestMode) {
      return _testCache[_keyUserEmail];
    }
    return await _storage.read(key: _keyUserEmail);
  }

  Future<void> clearSession() async {
    if (_isTestMode) {
      _testCache.clear();
      return;
    }
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyUserEmail);
  }
}
