class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;

  final int humidity;
  final int pressure;
  final double windSpeed;

  final String description;
  final String icon;
  final String mainCondition;

  final double precipitationProbability;

  const ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.precipitationProbability,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final main = _asMap(json['main']);
    final wind = _asMap(json['wind']);

    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty
        ? _asMap(weatherList.first)
        : <String, dynamic>{};

    return ForecastModel(
      dateTime: _fromUnixTime(json['dt']),
      temperature: _toDouble(main['temp']),
      feelsLike: _toDouble(main['feels_like']),
      tempMin: _toDouble(main['temp_min']),
      tempMax: _toDouble(main['temp_max']),
      humidity: _toInt(main['humidity']),
      pressure: _toInt(main['pressure']),
      windSpeed: _toDouble(wind['speed']),
      description: (weather['description'] ?? '').toString(),
      icon: (weather['icon'] ?? '').toString(),
      mainCondition: (weather['main'] ?? '').toString(),
      precipitationProbability: _toDouble(json['pop']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {'description': description, 'icon': icon, 'main': mainCondition},
      ],
      'pop': precipitationProbability,
    };
  }

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$icon@2x.png';
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static DateTime _fromUnixTime(dynamic value) {
    final seconds = _toInt(value);
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }
}
