class WeatherModel {
  final String cityName;
  final String country;
  final double latitude;
  final double longitude;

  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;

  final int humidity;
  final double windSpeed;
  final int? windDegree;
  final int pressure;
  final int? visibility;
  final int? cloudiness;

  final String description;
  final String icon;
  final String mainCondition;

  final DateTime dateTime;
  final DateTime? sunrise;
  final DateTime? sunset;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.dateTime,
    this.windDegree,
    this.visibility,
    this.cloudiness,
    this.sunrise,
    this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final coord = _asMap(json['coord']);
    final main = _asMap(json['main']);
    final wind = _asMap(json['wind']);
    final sys = _asMap(json['sys']);
    final clouds = _asMap(json['clouds']);

    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty
        ? _asMap(weatherList.first)
        : <String, dynamic>{};

    return WeatherModel(
      cityName: (json['name'] ?? 'Unknown').toString(),
      country: (sys['country'] ?? '').toString(),

      latitude: _toDouble(coord['lat']),
      longitude: _toDouble(coord['lon']),

      temperature: _toDouble(main['temp']),
      feelsLike: _toDouble(main['feels_like']),
      tempMin: _toDouble(main['temp_min']),
      tempMax: _toDouble(main['temp_max']),

      humidity: _toInt(main['humidity']),
      windSpeed: _toDouble(wind['speed']),
      windDegree: wind['deg'] == null ? null : _toInt(wind['deg']),
      pressure: _toInt(main['pressure']),
      visibility: json['visibility'] == null
          ? null
          : _toInt(json['visibility']),
      cloudiness: clouds['all'] == null ? null : _toInt(clouds['all']),

      description: (weather['description'] ?? '').toString(),
      icon: (weather['icon'] ?? '').toString(),
      mainCondition: (weather['main'] ?? '').toString(),

      dateTime: _fromUnixTime(json['dt']),
      sunrise: sys['sunrise'] == null ? null : _fromUnixTime(sys['sunrise']),
      sunset: sys['sunset'] == null ? null : _fromUnixTime(sys['sunset']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'coord': {'lat': latitude, 'lon': longitude},
      'sys': {
        'country': country,
        'sunrise': sunrise?.millisecondsSinceEpoch == null
            ? null
            : sunrise!.millisecondsSinceEpoch ~/ 1000,
        'sunset': sunset?.millisecondsSinceEpoch == null
            ? null
            : sunset!.millisecondsSinceEpoch ~/ 1000,
      },
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {'speed': windSpeed, 'deg': windDegree},
      'weather': [
        {'description': description, 'icon': icon, 'main': mainCondition},
      ],
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'visibility': visibility,
      'clouds': {'all': cloudiness},
    };
  }

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$icon@2x.png';
  }

  bool get isNight {
    return icon.endsWith('n');
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
