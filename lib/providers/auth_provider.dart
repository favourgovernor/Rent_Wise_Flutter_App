import 'dart:convert';  // ← ADD THIS IMPORT
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  bool _isLoading = false;
  String? _token;
  Map<String, dynamic>? _user;
  
  bool get isLoading => _isLoading;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    _token = await _storage.read(key: 'auth_token');
    final userData = await _storage.read(key: 'user_data');
    if (userData != null) {
      _user = Map<String, dynamic>.from(jsonDecode(userData));
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      
      if (response['success']) {
        _token = response['token'];
        _user = response['user'];
        
        await _storage.write(key: 'auth_token', value: _token);
        await _storage.write(key: 'user_data', value: jsonEncode(_user));
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _token = null;
    _user = null;
    notifyListeners();
  }
}