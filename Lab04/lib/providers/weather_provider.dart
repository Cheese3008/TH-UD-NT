import 'package:flutter/material.dart';

import '../models/forecast_model.dart';
import '../models/weather_model.dart';
import '../services/connectivity_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;
  final ConnectivityService _connectivityService;

  WeatherProvider({
    WeatherService? weatherService,
    LocationService? locationService,
    StorageService? storageService,
    ConnectivityService? connectivityService,
  }) : _weatherService = weatherService ?? WeatherService(),
       _locationService = locationService ?? LocationService(),
       _storageService = storageService ?? StorageService(),
       _connectivityService = connectivityService ?? ConnectivityService();

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];

  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';

  bool _isOffline = false;
  bool _isUsingCachedData = false;
  DateTime? _lastUpdateTime;

  List<String> _favoriteCities = [];
  List<String> _recentSearches = [];

  String _temperatureUnit = 'celsius';
  String _windSpeedUnit = 'ms';
  String _timeFormat = '24h';
  String _languageCode = 'vi';

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => List.unmodifiable(_forecast);

  WeatherState get state => _state;
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == WeatherState.loading;
  bool get hasError => _state == WeatherState.error;
  bool get hasWeatherData => _currentWeather != null;

  bool get isOffline => _isOffline;
  bool get isUsingCachedData => _isUsingCachedData;
  DateTime? get lastUpdateTime => _lastUpdateTime;

  List<String> get favoriteCities => List.unmodifiable(_favoriteCities);
  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  String get temperatureUnit => _temperatureUnit;
  String get windSpeedUnit => _windSpeedUnit;
  String get timeFormat => _timeFormat;
  String get languageCode => _languageCode;

  Future<void> initialize() async {
    await _loadUserPreferences();
    await _loadFavoriteAndRecentCities();

    final bool hasConnection = await _connectivityService
        .hasInternetConnection();

    _isOffline = !hasConnection;

    if (_currentWeather == null) {
      await loadCachedWeather();

      if (_currentWeather == null && hasConnection) {
        await fetchWeatherByCity('Ho Chi Minh City');
      }
    }
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    final String trimmedCityName = cityName.trim();

    if (trimmedCityName.isEmpty) {
      _setError('Vui lòng nhập tên thành phố.');
      return;
    }

    _setLoading();

    try {
      final bool hasConnection = await _connectivityService
          .hasInternetConnection();

      _isOffline = !hasConnection;

      if (!hasConnection) {
        await loadCachedWeather();

        if (_currentWeather != null) {
          _isUsingCachedData = true;
          _state = WeatherState.loaded;
          _errorMessage =
              'Thiết bị đang offline. Đang hiển thị dữ liệu đã lưu.';
        } else {
          _setError('Thiết bị đang offline và chưa có dữ liệu cache.');
        }

        notifyListeners();
        return;
      }

      final WeatherModel weather = await _weatherService
          .getCurrentWeatherByCity(trimmedCityName);

      final List<ForecastModel> forecast = await _weatherService
          .getForecastByCity(trimmedCityName);

      _currentWeather = weather;
      _forecast = forecast;

      await _storageService.saveWeatherData(weather);
      await _storageService.saveForecastData(forecast);
      await _storageService.addRecentSearch(weather.cityName);

      _lastUpdateTime = DateTime.now();
      _recentSearches = await _storageService.getRecentSearches();

      _isOffline = false;
      _isUsingCachedData = false;
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (error) {
      await _handleFetchError(error);
    }

    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _setLoading();

    try {
      final bool hasConnection = await _connectivityService
          .hasInternetConnection();

      _isOffline = !hasConnection;

      if (!hasConnection) {
        await loadCachedWeather();

        if (_currentWeather != null) {
          _isUsingCachedData = true;
          _state = WeatherState.loaded;
          _errorMessage =
              'Thiết bị đang offline. Đang hiển thị dữ liệu đã lưu.';
        } else {
          _setError('Thiết bị đang offline và chưa có dữ liệu cache.');
        }

        notifyListeners();
        return;
      }

      final position = await _locationService.getCurrentPosition();

      final WeatherModel weather = await _weatherService
          .getCurrentWeatherByCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
          );

      final List<ForecastModel> forecast = await _weatherService
          .getForecastByCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
          );

      _currentWeather = weather;
      _forecast = forecast;

      await _storageService.saveWeatherData(weather);
      await _storageService.saveForecastData(forecast);
      await _storageService.addRecentSearch(weather.cityName);

      _lastUpdateTime = DateTime.now();
      _recentSearches = await _storageService.getRecentSearches();

      _isOffline = false;
      _isUsingCachedData = false;
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (error) {
      await _handleFetchError(error);
    }

    notifyListeners();
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
      return;
    }

    await fetchWeatherByLocation();
  }

  Future<void> loadCachedWeather() async {
    final WeatherModel? cachedWeather = await _storageService
        .getCachedWeather();

    final List<ForecastModel> cachedForecast = await _storageService
        .getCachedForecast();

    final DateTime? lastUpdate = await _storageService
        .getLastWeatherUpdateTime();

    if (cachedWeather == null) {
      return;
    }

    _currentWeather = cachedWeather;
    _forecast = cachedForecast;
    _lastUpdateTime = lastUpdate;
    _isUsingCachedData = true;
    _state = WeatherState.loaded;

    notifyListeners();
  }

  Future<void> addFavoriteCity(String cityName) async {
    await _storageService.addFavoriteCity(cityName);
    _favoriteCities = await _storageService.getFavoriteCities();
    notifyListeners();
  }

  Future<void> removeFavoriteCity(String cityName) async {
    await _storageService.removeFavoriteCity(cityName);
    _favoriteCities = await _storageService.getFavoriteCities();
    notifyListeners();
  }

  Future<void> toggleCurrentCityFavorite() async {
    final WeatherModel? weather = _currentWeather;

    if (weather == null) {
      return;
    }

    final bool isFavorite = await _storageService.isFavoriteCity(
      weather.cityName,
    );

    if (isFavorite) {
      await _storageService.removeFavoriteCity(weather.cityName);
    } else {
      await _storageService.addFavoriteCity(weather.cityName);
    }

    _favoriteCities = await _storageService.getFavoriteCities();
    notifyListeners();
  }

  bool isCityFavorite(String cityName) {
    final String normalizedCity = cityName.trim().toLowerCase();

    return _favoriteCities.any(
      (String city) => city.toLowerCase() == normalizedCity,
    );
  }

  Future<void> clearRecentSearches() async {
    await _storageService.clearRecentSearches();
    _recentSearches = [];
    notifyListeners();
  }

  Future<void> updateTemperatureUnit(String unit) async {
    _temperatureUnit = unit;
    await _storageService.saveTemperatureUnit(unit);
    notifyListeners();
  }

  Future<void> updateWindSpeedUnit(String unit) async {
    _windSpeedUnit = unit;
    await _storageService.saveWindSpeedUnit(unit);
    notifyListeners();
  }

  Future<void> updateTimeFormat(String format) async {
    _timeFormat = format;
    await _storageService.saveTimeFormat(format);
    notifyListeners();
  }

  Future<void> updateLanguage(String languageCode) async {
    _languageCode = languageCode;
    await _storageService.saveLanguage(languageCode);
    notifyListeners();
  }

  double convertTemperature(double celsiusValue) {
    if (_temperatureUnit == 'fahrenheit') {
      return celsiusValue * 9 / 5 + 32;
    }

    return celsiusValue;
  }

  String getTemperatureSymbol() {
    if (_temperatureUnit == 'fahrenheit') {
      return '°F';
    }

    return '°C';
  }

  double convertWindSpeed(double meterPerSecondValue) {
    if (_windSpeedUnit == 'kmh') {
      return meterPerSecondValue * 3.6;
    }

    if (_windSpeedUnit == 'mph') {
      return meterPerSecondValue * 2.23694;
    }

    return meterPerSecondValue;
  }

  String getWindSpeedSymbol() {
    if (_windSpeedUnit == 'kmh') {
      return 'km/h';
    }

    if (_windSpeedUnit == 'mph') {
      return 'mph';
    }

    return 'm/s';
  }

  void clearError() {
    _errorMessage = '';

    if (_currentWeather != null) {
      _state = WeatherState.loaded;
    } else {
      _state = WeatherState.initial;
    }

    notifyListeners();
  }

  Future<void> _loadUserPreferences() async {
    _temperatureUnit = await _storageService.getTemperatureUnit();
    _windSpeedUnit = await _storageService.getWindSpeedUnit();
    _timeFormat = await _storageService.getTimeFormat();
    _languageCode = await _storageService.getLanguage();
  }

  Future<void> _loadFavoriteAndRecentCities() async {
    _favoriteCities = await _storageService.getFavoriteCities();
    _recentSearches = await _storageService.getRecentSearches();
  }

  Future<void> _handleFetchError(Object error) async {
    await loadCachedWeather();

    if (_currentWeather != null) {
      _isUsingCachedData = true;
      _state = WeatherState.loaded;
      _errorMessage = 'Không thể tải dữ liệu mới. Đang hiển thị dữ liệu cache.';
      return;
    }

    _setError(error.toString());
  }

  void _setLoading() {
    _state = WeatherState.loading;
    _errorMessage = '';
    notifyListeners();
  }

  void _setError(String message) {
    _state = WeatherState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
