import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final String trimmedCityName = cityName.trim();

    if (trimmedCityName.isEmpty) {
      throw WeatherServiceException('Tên thành phố không được để trống.');
    }

    final String url = ApiConfig.buildCurrentWeatherByCityUrl(trimmedCityName);
    final Map<String, dynamic> data = await _getJson(url);

    return WeatherModel.fromJson(data);
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final String url = ApiConfig.buildCurrentWeatherByCoordinatesUrl(
      latitude: latitude,
      longitude: longitude,
    );

    final Map<String, dynamic> data = await _getJson(url);

    return WeatherModel.fromJson(data);
  }

  Future<List<ForecastModel>> getForecastByCity(String cityName) async {
    final String trimmedCityName = cityName.trim();

    if (trimmedCityName.isEmpty) {
      throw WeatherServiceException('Tên thành phố không được để trống.');
    }

    final String url = ApiConfig.buildForecastByCityUrl(trimmedCityName);
    final Map<String, dynamic> data = await _getJson(url);

    return _parseForecastList(data);
  }

  Future<List<ForecastModel>> getForecastByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final String url = ApiConfig.buildForecastByCoordinatesUrl(
      latitude: latitude,
      longitude: longitude,
    );

    final Map<String, dynamic> data = await _getJson(url);

    return _parseForecastList(data);
  }

  String getIconUrl(String iconCode, {String size = '2x'}) {
    return ApiConfig.buildWeatherIconUrl(iconCode, size: size);
  }

  Future<Map<String, dynamic>> _getJson(String url) async {
    try {
      final http.Response response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw WeatherServiceException(
          _getErrorMessage(response.statusCode, response.body),
          statusCode: response.statusCode,
        );
      }

      final dynamic decodedData = jsonDecode(response.body);

      if (decodedData is Map<String, dynamic>) {
        return decodedData;
      }

      if (decodedData is Map) {
        return Map<String, dynamic>.from(decodedData);
      }

      throw WeatherServiceException('Dữ liệu API trả về không hợp lệ.');
    } on WeatherServiceException {
      rethrow;
    } on TimeoutException {
      throw WeatherServiceException(
        'Kết nối quá thời gian chờ. Vui lòng thử lại.',
      );
    } on FormatException {
      throw WeatherServiceException(
        'Không thể đọc dữ liệu thời tiết từ máy chủ.',
      );
    } catch (error) {
      throw WeatherServiceException(
        'Không thể kết nối đến API thời tiết. Chi tiết: $error',
      );
    }
  }

  List<ForecastModel> _parseForecastList(Map<String, dynamic> data) {
    final dynamic rawList = data['list'];

    if (rawList is! List) {
      throw WeatherServiceException('Dữ liệu dự báo thời tiết không hợp lệ.');
    }

    return rawList.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return ForecastModel.fromJson(item);
      }

      if (item is Map) {
        return ForecastModel.fromJson(Map<String, dynamic>.from(item));
      }

      throw WeatherServiceException('Một mục forecast không hợp lệ.');
    }).toList();
  }

  String _getErrorMessage(int statusCode, String responseBody) {
    String apiMessage = '';

    try {
      final dynamic decodedData = jsonDecode(responseBody);

      if (decodedData is Map && decodedData['message'] != null) {
        apiMessage = decodedData['message'].toString();
      }
    } catch (_) {
      apiMessage = '';
    }

    switch (statusCode) {
      case 400:
        return 'Yêu cầu không hợp lệ. $apiMessage';
      case 401:
        return 'API key không hợp lệ hoặc chưa được kích hoạt. $apiMessage';
      case 404:
        return 'Không tìm thấy thành phố. Vui lòng kiểm tra lại tên.';
      case 429:
        return 'Bạn đã vượt quá giới hạn gọi API. Vui lòng thử lại sau.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Máy chủ thời tiết đang gặp sự cố. Vui lòng thử lại sau.';
      default:
        return 'Không thể tải dữ liệu thời tiết. Mã lỗi: $statusCode. $apiMessage';
    }
  }
}

class WeatherServiceException implements Exception {
  final String message;
  final int? statusCode;

  const WeatherServiceException(this.message, {this.statusCode});

  @override
  String toString() {
    return message;
  }
}
