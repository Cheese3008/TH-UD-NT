import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static const String currentWeatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';

  static const String defaultUnit = 'metric';
  static const String defaultLanguage = 'vi';

  static String get apiKey {
    final String? directKey = dotenv.env['74e6170a93f4f76df2451506bd47c4e3'];

    if (directKey != null && directKey.trim().isNotEmpty) {
      return directKey.trim();
    }

    for (final MapEntry<String, String> entry in dotenv.env.entries) {
      final String normalizedKey = entry.key.replaceAll('\uFEFF', '').trim();

      if (normalizedKey == 'OPENWEATHER_API_KEY' &&
          entry.value.trim().isNotEmpty) {
        return entry.value.trim();
      }
    }

    return '';
  }

  static bool get hasApiKey {
    return apiKey.trim().isNotEmpty;
  }

  static String buildUrl({
    required String endpoint,
    required Map<String, dynamic> queryParameters,
  }) {
    if (!hasApiKey) {
      throw Exception('OPENWEATHER_API_KEY chưa được cấu hình trong file .env');
    }

    final Map<String, String> finalQueryParameters = {
      ...queryParameters.map((key, value) => MapEntry(key, value.toString())),
      'appid': apiKey,
      'units': defaultUnit,
      'lang': defaultLanguage,
    };

    final Uri uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: finalQueryParameters);

    return uri.toString();
  }

  static String buildCurrentWeatherByCityUrl(String cityName) {
    return buildUrl(
      endpoint: currentWeatherEndpoint,
      queryParameters: {'q': cityName},
    );
  }

  static String buildCurrentWeatherByCoordinatesUrl({
    required double latitude,
    required double longitude,
  }) {
    return buildUrl(
      endpoint: currentWeatherEndpoint,
      queryParameters: {'lat': latitude, 'lon': longitude},
    );
  }

  static String buildForecastByCityUrl(String cityName) {
    return buildUrl(
      endpoint: forecastEndpoint,
      queryParameters: {'q': cityName},
    );
  }

  static String buildForecastByCoordinatesUrl({
    required double latitude,
    required double longitude,
  }) {
    return buildUrl(
      endpoint: forecastEndpoint,
      queryParameters: {'lat': latitude, 'lon': longitude},
    );
  }

  static String buildWeatherIconUrl(String iconCode, {String size = '2x'}) {
    return 'https://openweathermap.org/img/wn/$iconCode@$size.png';
  }
}
