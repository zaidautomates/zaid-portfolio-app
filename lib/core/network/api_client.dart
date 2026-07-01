import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  final SecureStorageService _secureStorage;
  final http.Client _client;
  
  // Callback when a 401 Unauthorized response is received
  void Function()? onUnauthorized;

  ApiClient(this._secureStorage, {http.Client? client}) 
      : _client = client ?? http.Client();

  bool get _isTestMode => !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  Map<String, String> _headers(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> get(String endpoint) async {
    if (_isTestMode) {
      return _mockResponse(endpoint, 'GET');
    }

    final token = await _secureStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    try {
      final response = await _client.get(url, headers: _headers(token))
          .timeout(const Duration(seconds: 15));
      _handleResponseStatus(response);
      return response;
    } on SocketException {
      throw Exception('No Internet connection. Check your network and try again.');
    }
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    if (_isTestMode) {
      return _mockResponse(endpoint, 'POST', body: body);
    }

    final token = await _secureStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    try {
      final response = await _client.post(
        url, 
        headers: _headers(token), 
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));
      _handleResponseStatus(response);
      return response;
    } on SocketException {
      throw Exception('No Internet connection. Check your network and try again.');
    }
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    if (_isTestMode) {
      return _mockResponse(endpoint, 'PUT', body: body);
    }

    final token = await _secureStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    try {
      final response = await _client.put(
        url, 
        headers: _headers(token), 
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));
      _handleResponseStatus(response);
      return response;
    } on SocketException {
      throw Exception('No Internet connection. Check your network and try again.');
    }
  }

  Future<http.Response> delete(String endpoint) async {
    if (_isTestMode) {
      return _mockResponse(endpoint, 'DELETE');
    }

    final token = await _secureStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    try {
      final response = await _client.delete(url, headers: _headers(token))
          .timeout(const Duration(seconds: 15));
      _handleResponseStatus(response);
      return response;
    } on SocketException {
      throw Exception('No Internet connection. Check your network and try again.');
    }
  }

  // Upload an image via multipart/form-data
  Future<http.Response> uploadImage(String endpoint, String filePath) async {
    if (_isTestMode) {
      return _mockResponse(endpoint, 'PUT');
    }

    final token = await _secureStorage.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    try {
      final request = http.MultipartRequest('PUT', url);
      
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      final file = await http.MultipartFile.fromPath('profileImage', filePath);
      request.files.add(file);
      
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);
      
      _handleResponseStatus(response);
      return response;
    } on SocketException {
      throw Exception('No Internet connection. Check your network and try again.');
    }
  }

  void _handleResponseStatus(http.Response response) {
    if (response.statusCode == 401) {
      if (onUnauthorized != null) {
        onUnauthorized!();
      }
    }
  }

  // Helper mock responses for testing
  http.Response _mockResponse(String endpoint, String method, {Map<String, dynamic>? body}) {
    if (endpoint == '/auth/login') {
      final email = body?['email'];
      final password = body?['password'];
      if (email == 'zaidautomates@gmail.com' && password == 'Zaid@2026') {
        return http.Response(
          jsonEncode({
            'token': 'mocked_token',
            'user': {
              'id': 'mocked_user_id',
              'name': 'Zaid Ali',
              'email': 'zaidautomates@gmail.com',
            }
          }),
          200,
          headers: {
            'content-type': 'application/json; charset=utf-8',
          },
        );
      } else {
        return http.Response(
          jsonEncode({'message': 'Invalid email or password.'}),
          401,
          headers: {
            'content-type': 'application/json; charset=utf-8',
          },
        );
      }
    }

    if (endpoint == '/profile') {
      return http.Response(
        jsonEncode({
          'user': {
            'id': 'mocked_user_id',
            'name': 'Zaid Ali',
            'email': 'zaidautomates@gmail.com',
            'role': 'AI Automation Developer & ML Engineer',
            'tagline': 'Building intelligent systems at the intersection of AI and mobile.',
            'about': 'BS Computer Science student at Abdul Wali Khan University Mardan (AWKUM), 6th Semester. Interning at CODIORA as an AI Automation Developer. Passionate about Flutter, machine learning, and agentic AI workflows.',
            'education': 'BS Computer Science - AWKUM, 6th Semester',
            'location': 'Mardan, KPK, Pakistan',
            'phone': '1234567890',
            'linkedin': 'linkedin.com/in/zaidautomates',
            'github': 'github.com/zaidautomates',
            'website': 'zaidautomates.github.io',
            'profileImage': '',
          },
          'skills': [
            {
              'id': 'skill1',
              'name': 'Flutter & Dart',
              'category': 'Mobile',
              'level': 'Advanced',
              'proficiency': 88,
            },
            {
              'id': 'skill2',
              'name': 'Python',
              'category': 'AI/ML',
              'level': 'Advanced',
              'proficiency': 85,
            },
            {
              'id': 'skill3',
              'name': 'Machine Learning',
              'category': 'AI/ML',
              'level': 'Intermediate',
              'proficiency': 78,
            },
            {
              'id': 'skill4',
              'name': 'n8n Automation',
              'category': 'Automation',
              'level': 'Advanced',
              'proficiency': 90,
            },
            {
              'id': 'skill5',
              'name': 'JavaScript / React',
              'category': 'Web',
              'level': 'Intermediate',
              'proficiency': 72,
            },
            {
              'id': 'skill6',
              'name': 'Agentic AI',
              'category': 'AI/ML',
              'level': 'Intermediate',
              'proficiency': 75,
            }
          ],
          'projects': [
            {
              'id': 'proj1',
              'title': 'Personal Portfolio Mobile App',
              'description': 'A premium, animated claymorphic and glassmorphic portfolio application showcasing developers details, dynamic skills, and API-powered project dashboards.',
              'category': 'Mobile',
              'technologies': ['Flutter', 'Dart', 'Provider', 'Node.js'],
              'imageUrl': '',
              'githubLink': 'github.com/zaidautomates',
              'liveLink': '',
              'status': 'Completed',
            },
            {
              'id': 'proj2',
              'title': 'YOLOv8 Object Detection Pipeline',
              'description': 'Real-time object detection system built on YOLOv8 with custom training pipeline, inference optimization, and visual dashboard for results.',
              'category': 'AI / ML',
              'technologies': ['Python', 'YOLOv8', 'OpenCV', 'PyTorch'],
              'imageUrl': '',
              'githubLink': 'github.com/zaidautomates',
              'liveLink': '',
              'status': 'Completed',
            },
            {
              'id': 'proj3',
              'title': 'EduNest LMS',
              'description': 'Full-featured Learning Management System with course management, student progress tracking, quizzes, and an instructor dashboard.',
              'category': 'Web / LMS',
              'technologies': ['React', 'Node.js', 'MongoDB', 'Express'],
              'imageUrl': '',
              'githubLink': 'github.com/zaidautomates',
              'liveLink': '',
              'status': 'Completed',
            },
            {
              'id': 'proj4',
              'title': 'n8n Social Media Automation Pipeline',
              'description': 'End-to-end automation pipeline that schedules, generates, and publishes social media content using n8n workflows and AI content generation.',
              'category': 'Automation',
              'technologies': ['n8n', 'OpenAI API', 'Webhooks', 'REST APIs'],
              'imageUrl': '',
              'githubLink': 'github.com/zaidautomates',
              'liveLink': '',
              'status': 'Completed',
            },
            {
              'id': 'proj5',
              'title': 'Pashto ASR Tool',
              'description': 'Automatic Speech Recognition tool for the Pashto language using fine-tuned Whisper model. Supports transcription of audio to Pashto text.',
              'category': 'AI / ML',
              'technologies': ['Python', 'Whisper', 'HuggingFace', 'Transformers'],
              'imageUrl': '',
              'githubLink': 'github.com/zaidautomates',
              'liveLink': '',
              'status': 'Completed',
            }
          ],
        }),
        200,
        headers: {
          'content-type': 'application/json; charset=utf-8',
        },
      );
    }

    return http.Response(
      '{"message": "Mocked response"}',
      200,
      headers: {
        'content-type': 'application/json; charset=utf-8',
      },
    );
  }
}
