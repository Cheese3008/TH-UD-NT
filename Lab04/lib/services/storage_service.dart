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

  /// Mô tả:
  /// Lưu dữ liệu thời tiết hiện tại vào bộ nhớ máy.
  ///
  /// Input:
  /// - weather: dữ liệu WeatherModel lấy từ API.
  ///
  /// Output:
  /// - Không trả về dữ liệu, chỉ lưu cache.
  Future<void> saveWeatherData(WeatherModel weather) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_cachedWeatherKey, jsonEncode(weather.toJson()));
    await prefs.setInt(
      _lastWeatherUpdateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Mô tả:
  /// Lấy dữ liệu thời tiết đã cache.
  ///
  /// Output:
  /// - WeatherModel nếu có cache.
  /// - null nếu chưa có cache hoặc cache bị lỗi.
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

  /// Mô tả:
  /// Lưu danh sách forecast vào cache.
  ///
  /// Input:
  /// - forecasts: danh sách ForecastModel.
  Future<void> saveForecastData(List<ForecastModel> forecasts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> forecastJsonList = forecasts
        .map((ForecastModel forecast) => forecast.toJson())
        .toList();

    await prefs.setString(_cachedForecastKey, jsonEncode(forecastJsonList));
  }

  /// Mô tả:
  /// Đọc danh sách forecast đã cache.
  ///
  /// Output:
  /// - Danh sách ForecastModel nếu có cache.
  /// - [] nếu chưa có cache hoặc dữ liệu lỗi.
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

  /// Mô tả:
  /// Kiểm tra cache thời tiết có còn hợp lệ không.
  ///
  /// Logic:
  /// - Mặc định cache hợp lệ trong 30 phút.
  ///
  /// Output:
  /// - true nếu cache còn mới.
  /// - false nếu cache đã cũ hoặc chưa có cache.
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

  /// Mô tả:
  /// Lấy thời điểm cập nhật cache gần nhất.
  ///
  /// Output:
  /// - DateTime nếu có.
  /// - null nếu chưa từng lưu cache.
  Future<DateTime?> getLastWeatherUpdateTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastUpdate = prefs.getInt(_lastWeatherUpdateKey);

    if (lastUpdate == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(lastUpdate);
  }

  /// Mô tả:
  /// Xóa cache thời tiết và forecast.
  Future<void> clearWeatherCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_cachedWeatherKey);
    await prefs.remove(_cachedForecastKey);
    await prefs.remove(_lastWeatherUpdateKey);
  }

  /// Mô tả:
  /// Lưu danh sách thành phố yêu thích.
  ///
  /// Logic:
  /// - Tối đa 5 thành phố.
  /// - Tự loại bỏ city rỗng.
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

  /// Mô tả:
  /// Lấy danh sách thành phố yêu thích.
  Future<List<String>> getFavoriteCities() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  /// Mô tả:
  /// Thêm một thành phố vào danh sách yêu thích.
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

  /// Mô tả:
  /// Xóa một thành phố khỏi danh sách yêu thích.
  Future<void> removeFavoriteCity(String cityName) async {
    final String city = cityName.trim();

    final List<String> cities = await getFavoriteCities();

    cities.removeWhere(
      (String item) => item.toLowerCase() == city.toLowerCase(),
    );

    await saveFavoriteCities(cities);
  }

  /// Mô tả:
  /// Kiểm tra một thành phố có nằm trong danh sách yêu thích không.
  Future<bool> isFavoriteCity(String cityName) async {
    final String city = cityName.trim().toLowerCase();
    final List<String> cities = await getFavoriteCities();

    return cities.any((String item) => item.toLowerCase() == city);
  }

  /// Mô tả:
  /// Lưu lịch sử tìm kiếm.
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

  /// Mô tả:
  /// Lấy lịch sử tìm kiếm.
  Future<List<String>> getRecentSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_recentSearchesKey) ?? [];
  }

  /// Mô tả:
  /// Thêm một thành phố vào lịch sử tìm kiếm.
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

  /// Mô tả:
  /// Xóa toàn bộ lịch sử tìm kiếm.
  Future<void> clearRecentSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_recentSearchesKey);
  }

  /// Mô tả:
  /// Lưu đơn vị nhiệt độ.
  ///
  /// Giá trị đề xuất:
  /// - celsius
  /// - fahrenheit
  Future<void> saveTemperatureUnit(String unit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_temperatureUnitKey, unit);
  }

  /// Mô tả:
  /// Lấy đơn vị nhiệt độ.
  Future<String> getTemperatureUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_temperatureUnitKey) ?? 'celsius';
  }

  /// Mô tả:
  /// Lưu đơn vị tốc độ gió.
  ///
  /// Giá trị đề xuất:
  /// - ms
  /// - kmh
  /// - mph
  Future<void> saveWindSpeedUnit(String unit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_windSpeedUnitKey, unit);
  }

  /// Mô tả:
  /// Lấy đơn vị tốc độ gió.
  Future<String> getWindSpeedUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_windSpeedUnitKey) ?? 'ms';
  }

  /// Mô tả:
  /// Lưu định dạng giờ.
  ///
  /// Giá trị đề xuất:
  /// - 24h
  /// - 12h
  Future<void> saveTimeFormat(String format) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_timeFormatKey, format);
  }

  /// Mô tả:
  /// Lấy định dạng giờ.
  Future<String> getTimeFormat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_timeFormatKey) ?? '24h';
  }

  /// Mô tả:
  /// Lưu ngôn ngữ hiển thị.
  ///
  /// Ví dụ:
  /// - vi
  /// - en
  Future<void> saveLanguage(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_languageKey, languageCode);
  }

  /// Mô tả:
  /// Lấy ngôn ngữ hiển thị.
  Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_languageKey) ?? 'vi';
  }
}
