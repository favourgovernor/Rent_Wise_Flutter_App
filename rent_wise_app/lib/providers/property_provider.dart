import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PropertyProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<dynamic> _properties = [];
  List<dynamic> _tenants = [];
  List<dynamic> _units = [];
  bool _isLoading = false;

  List<dynamic> get properties => _properties;
  List<dynamic> get tenants => _tenants;
  List<dynamic> get units => _units;
  bool get isLoading => _isLoading;

  Future<void> loadProperties(int landlordId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _properties = await _apiService.getProperties(landlordId);
      notifyListeners();
    } catch (e) {
      print('Error loading properties: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTenants(int landlordId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _tenants = await _apiService.getTenants(landlordId);
      notifyListeners();
    } catch (e) {
      print('Error loading tenants: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
}