class LocationModel {
  final double latitude;
  final double longitude;
  final String cityName;
  final String country;
  final String fullAddress;
  final bool isCurrentLocation;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.country,
    required this.fullAddress,
    this.isCurrentLocation = false,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      cityName: (json['cityName'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
      fullAddress: (json['fullAddress'] ?? '').toString(),
      isCurrentLocation: json['isCurrentLocation'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'country': country,
      'fullAddress': fullAddress,
      'isCurrentLocation': isCurrentLocation,
    };
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? country,
    String? fullAddress,
    bool? isCurrentLocation,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      fullAddress: fullAddress ?? this.fullAddress,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
    );
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
}
