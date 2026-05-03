import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _cachedWeatherKey = 'cached_weather';
  static const String _cachedForecastKey = 'cached_forecast';
  static const String _lastWeatherUpdateKey = 'last_weather_update';

  static const String _favoriteCitiesKey = 'favorite_cities';
  static const String _recentSearchesKey = 'recent_searches';

  static const String _temperatureUnitKey = 'temperature_unit';
  static const String _windSpeedUnitKey = 'wind_speed_unit';
  static const String _timeFormatKey = 'time_format';
  static const String _languageKey = 'language';

  static const int maxFavoriteCities = 5;
  static const int maxRecentSearches = 10;

  Future<void> saveWeatherData(WeatherModel weather) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_cachedWeatherKey, jsonEncode(weather.toJson()));
    await prefs.setInt(
      _lastWeatherUpdateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<WeatherModel?> getCachedWeather() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? rawWeather = prefs.getString(_cachedWeatherKey);

    if (rawWeather == null || rawWeather.isEmpty) {
      return null;
    }

    try {
      final dynamic decodedData = jsonDecode(rawWeather);

      if (decodedData is Map<String, dynamic>) {
        return WeatherModel.fromJson(decodedData);
      }

      if (decodedData is Map) {
        return WeatherModel.fromJson(Map<String, dynamic>.from(decodedData));
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveForecastData(List<ForecastModel> forecasts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> forecastJsonList = forecasts
        .map((ForecastModel forecast) => forecast.toJson())
        .toList();

    await prefs.setString(_cachedForecastKey, jsonEncode(forecastJsonList));
  }


  Future<List<ForecastModel>> getCachedForecast() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? rawForecast = prefs.getString(_cachedForecastKey);

    if (rawForecast == null || rawForecast.isEmpty) {
      return [];
    }

    try {
      final dynamic decodedData = jsonDecode(rawForecast);

      if (decodedData is! List) {
        return [];
      }

      return decodedData.map((dynamic item) {
        if (item is Map<String, dynamic>) {
          return ForecastModel.fromJson(item);
        }

        if (item is Map) {
          return ForecastModel.fromJson(Map<String, dynamic>.from(item));
        }

        throw const FormatException('Invalid forecast item');
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> isWeatherCacheValid({
    Duration maxAge = const Duration(minutes: 30),
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastUpdate = prefs.getInt(_lastWeatherUpdateKey);

    if (lastUpdate == null) {
      return false;
    }

    final DateTime lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(
      lastUpdate,
    );

    final Duration cacheAge = DateTime.now().difference(lastUpdateTime);

    return cacheAge <= maxAge;
  }


  Future<DateTime?> getLastWeatherUpdateTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastUpdate = prefs.getInt(_lastWeatherUpdateKey);

    if (lastUpdate == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(lastUpdate);
  }

  Future<void> clearWeatherCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_cachedWeatherKey);
    await prefs.remove(_cachedForecastKey);
    await prefs.remove(_lastWeatherUpdateKey);
  }

  Future<void> saveFavoriteCities(List<String> cities) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> normalizedCities = cities
        .map((String city) => city.trim())
        .where((String city) => city.isNotEmpty)
        .toSet()
        .take(maxFavoriteCities)
        .toList();

    await prefs.setStringList(_favoriteCitiesKey, normalizedCities);
  }

  Future<List<String>> getFavoriteCities() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  Future<void> addFavoriteCity(String cityName) async {
    final String city = cityName.trim();

    if (city.isEmpty) {
      return;
    }

    final List<String> cities = await getFavoriteCities();

    cities.removeWhere(
      (String item) => item.toLowerCase() == city.toLowerCase(),
    );

    cities.insert(0, city);

    await saveFavoriteCities(cities);
  }

  Future<void> removeFavoriteCity(String cityName) async {
    final String city = cityName.trim();

    final List<String> cities = await getFavoriteCities();

    cities.removeWhere(
      (String item) => item.toLowerCase() == city.toLowerCase(),
    );

    await saveFavoriteCities(cities);
  }

  Future<bool> isFavoriteCity(String cityName) async {
    final String city = cityName.trim().toLowerCase();
    final List<String> cities = await getFavoriteCities();

    return cities.any((String item) => item.toLowerCase() == city);
  }


  Future<void> saveRecentSearches(List<String> searches) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> normalizedSearches = searches
        .map((String city) => city.trim())
        .where((String city) => city.isNotEmpty)
        .toSet()
        .take(maxRecentSearches)
        .toList();

    await prefs.setStringList(_recentSearchesKey, normalizedSearches);
  }

  Future<List<String>> getRecentSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_recentSearchesKey) ?? [];
  }


  Future<void> addRecentSearch(String cityName) async {
    final String city = cityName.trim();

    if (city.isEmpty) {
      return;
    }

    final List<String> searches = await getRecentSearches();

    searches.removeWhere(
      (String item) => item.toLowerCase() == city.toLowerCase(),
    );

    searches.insert(0, city);

    await saveRecentSearches(searches);
  }


  Future<void> clearRecentSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_recentSearchesKey);
  }

  Future<void> saveTemperatureUnit(String unit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_temperatureUnitKey, unit);
  }

  Future<String> getTemperatureUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_temperatureUnitKey) ?? 'celsius';
  }

  Future<void> saveWindSpeedUnit(String unit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_windSpeedUnitKey, unit);
  }

  Future<String> getWindSpeedUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_windSpeedUnitKey) ?? 'ms';
  }


  Future<void> saveTimeFormat(String format) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_timeFormatKey, format);
  }

  Future<String> getTimeFormat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_timeFormatKey) ?? '24h';
  }

  Future<void> saveLanguage(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_languageKey, languageCode);
  }

  Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_languageKey) ?? 'vi';
  }
}
