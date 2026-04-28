import 'forecast_model.dart';

class HourlyWeatherModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final double precipitationProbability;

  const HourlyWeatherModel({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.precipitationProbability,
  });

  factory HourlyWeatherModel.fromForecast(ForecastModel forecast) {
    return HourlyWeatherModel(
      dateTime: forecast.dateTime,
      temperature: forecast.temperature,
      description: forecast.description,
      icon: forecast.icon,
      precipitationProbability: forecast.precipitationProbability,
    );
  }

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$icon@2x.png';
  }
}
