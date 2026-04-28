import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../services/location_service.dart';

enum LocationState { initial, loading, loaded, error }

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;

  LocationProvider({LocationService? locationService})
    : _locationService = locationService ?? LocationService();

  LocationModel? _currentLocation;
  LocationState _state = LocationState.initial;
  String _errorMessage = '';

  LocationModel? get currentLocation => _currentLocation;
  LocationState get state => _state;
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == LocationState.loading;
  bool get hasError => _state == LocationState.error;
  bool get hasLocation => _currentLocation != null;

  Future<void> fetchCurrentLocation() async {
    _setLoading();

    try {
      final LocationModel location = await _locationService
          .getCurrentLocationModel();

      _currentLocation = location;
      _state = LocationState.loaded;
      _errorMessage = '';
    } catch (error) {
      _setError(error.toString());
    }

    notifyListeners();
  }

  Future<bool> checkPermission() async {
    try {
      return await _locationService.checkAndRequestPermission();
    } catch (error) {
      _setError(error.toString());
      return false;
    }
  }

  Future<void> setLocationFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    _setLoading();

    try {
      final LocationModel location = await _locationService
          .getLocationModelFromCoordinates(
            latitude: latitude,
            longitude: longitude,
          );

      _currentLocation = location;
      _state = LocationState.loaded;
      _errorMessage = '';
    } catch (error) {
      _setError(error.toString());
    }

    notifyListeners();
  }

  void clearLocation() {
    _currentLocation = null;
    _state = LocationState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';

    if (_currentLocation != null) {
      _state = LocationState.loaded;
    } else {
      _state = LocationState.initial;
    }

    notifyListeners();
  }

  void _setLoading() {
    _state = LocationState.loading;
    _errorMessage = '';
    notifyListeners();
  }

  void _setError(String message) {
    _state = LocationState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
