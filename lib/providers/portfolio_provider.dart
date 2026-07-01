import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../core/network/api_client.dart';
import '../models/user_model.dart';
import '../models/skill_model.dart';
import '../models/project_model.dart';

enum PortfolioStatus { initial, loading, loaded, empty, error }

class PortfolioProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  PortfolioStatus _status = PortfolioStatus.initial;
  UserModel? _user;
  List<SkillModel> _skills = [];
  List<ProjectModel> _projects = [];
  String? _errorMessage;

  PortfolioProvider(this._apiClient);

  PortfolioStatus get status => _status;
  UserModel? get user => _user;
  List<SkillModel> get skills => _skills;
  List<ProjectModel> get projects => _projects;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == PortfolioStatus.loading;

  Future<void> fetchPortfolioData() async {
    _status = PortfolioStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch public profile (which includes user, skills, and projects in one go!)
      final response = await _apiClient.get('/profile');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final userJson = data['user'] ?? {};
        _user = UserModel.fromJson(userJson);

        final List<dynamic> skillsJson = data['skills'] ?? [];
        _skills = skillsJson.map((s) => SkillModel.fromJson(s)).toList();

        final List<dynamic> projectsJson = data['projects'] ?? [];
        _projects = projectsJson.map((p) => ProjectModel.fromJson(p)).toList();

        if (_user == null) {
          _status = PortfolioStatus.empty;
        } else {
          _status = PortfolioStatus.loaded;
        }
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Failed to load portfolio data from server.';
        _status = PortfolioStatus.error;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = PortfolioStatus.error;
    }
    notifyListeners();
  }

  // Update profile basic info & about/education
  Future<bool> updateProfile({
    required String name,
    required String role,
    required String tagline,
    required String about,
    required String education,
  }) async {
    _status = PortfolioStatus.loading;
    notifyListeners();

    try {
      // 1. Update basic info
      final basicResponse = await _apiClient.put('/profile', body: {
        'name': name,
        'role': role,
        'tagline': tagline,
      });

      // 2. Update biography/about info
      final aboutResponse = await _apiClient.put('/profile/about', body: {
        'about': about,
        'education': education,
      });

      if (basicResponse.statusCode == 200 && aboutResponse.statusCode == 200) {
        // Refresh local state
        await fetchPortfolioData();
        return true;
      } else {
        _errorMessage = 'Failed to update profile details on the server.';
        _status = PortfolioStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _status = PortfolioStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Update contact & social links
  Future<bool> updateContact({
    required String email,
    required String phone,
    required String location,
    required String linkedin,
    required String github,
    required String website,
  }) async {
    _status = PortfolioStatus.loading;
    notifyListeners();

    try {
      // 1. Update contact
      final contactResponse = await _apiClient.put('/profile/contact', body: {
        'email': email,
        'phone': phone,
        'location': location,
      });

      // 2. Update social links
      final socialResponse = await _apiClient.put('/profile/social', body: {
        'linkedin': linkedin,
        'github': github,
        'website': website,
      });

      if (contactResponse.statusCode == 200 && socialResponse.statusCode == 200) {
        // Refresh local state
        await fetchPortfolioData();
        return true;
      } else {
        _errorMessage = 'Failed to update contact/social links on the server.';
        _status = PortfolioStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _status = PortfolioStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Upload profile image as base64 string directly
  Future<bool> uploadProfileImage(File file) async {
    _status = PortfolioStatus.loading;
    notifyListeners();

    try {
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      final mimeType = file.path.endsWith('.png') ? 'image/png' : 'image/jpeg';
      final dataUri = 'data:$mimeType;base64,$base64String';

      // Update via PUT /profile basic info
      final response = await _apiClient.put('/profile', body: {
        'profileImage': dataUri,
      });

      if (response.statusCode == 200) {
        await fetchPortfolioData();
        return true;
      } else {
        _errorMessage = 'Failed to upload profile image to the server.';
        _status = PortfolioStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _status = PortfolioStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Helper method to clear state on logout
  void clear() {
    _user = null;
    _skills = [];
    _projects = [];
    _status = PortfolioStatus.initial;
    _errorMessage = null;
  }
}
