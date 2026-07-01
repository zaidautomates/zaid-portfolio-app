import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/network/api_client.dart';
import '../core/storage/secure_storage_service.dart';
import '../models/auth_response_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  String? _token;

  AuthProvider(this._apiClient, this._secureStorage) {
    // Hook the unauthorized callback from ApiClient to trigger automatic logout
    _apiClient.onUnauthorized = handleSessionExpired;
  }

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> checkAuth() async {
    await Future.microtask(() {});
    _status = AuthStatus.loading;
    notifyListeners();
    
    try {
      final savedToken = await _secureStorage.getToken();
      if (savedToken != null && savedToken.isNotEmpty) {
        _token = savedToken;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.post('/auth/login', body: {
        'email': email.trim().toLowerCase(),
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authResponse = AuthResponseModel.fromJson(data);
        
        _token = authResponse.token;
        await _secureStorage.saveToken(authResponse.token);
        await _secureStorage.saveUserEmail(authResponse.userEmail);
        
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Authentication failed. Please check your credentials.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();
    
    await _secureStorage.clearSession();
    _token = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void handleSessionExpired() {
    _secureStorage.clearSession();
    _token = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = 'Session expired. Please log in again.';
    notifyListeners();
  }
}
