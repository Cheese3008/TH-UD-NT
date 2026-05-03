import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/location_model.dart';

class LocationService {
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }
  Future<bool> checkAndRequestPermission() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw const LocationServiceException(
        'GPS đang tắt. Vui lòng bật vị trí trên thiết bị.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        'Bạn đã từ chối quyền truy cập vị trí.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Quyền vị trí đã bị từ chối vĩnh viễn. Vui lòng mở Settings để cấp quyền.',
      );
    }

    return true;
  }

  Future<Position> getCurrentPosition() async {
    await checkAndRequestPermission();

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (error) {
      throw LocationServiceException(
        'Không thể lấy vị trí hiện tại. Chi tiết: $error',
      );
    }
  }

  Future<String> getCityName({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return 'Unknown';
      }

      final Placemark place = placemarks.first;

      return place.locality?.isNotEmpty == true
          ? place.locality!
          : place.subAdministrativeArea?.isNotEmpty == true
          ? place.subAdministrativeArea!
          : place.administrativeArea?.isNotEmpty == true
          ? place.administrativeArea!
          : 'Unknown';
    } catch (error) {
      throw LocationServiceException(
        'Không thể chuyển tọa độ thành tên thành phố. Chi tiết: $error',
      );
    }
  }

  Future<LocationModel> getLocationModelFromCoordinates({
    required double latitude,
    required double longitude,
    bool isCurrentLocation = false,
  }) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return LocationModel(
          latitude: latitude,
          longitude: longitude,
          cityName: 'Unknown',
          country: '',
          fullAddress: '',
          isCurrentLocation: isCurrentLocation,
        );
      }

      final Placemark place = placemarks.first;

      final String cityName = _getBestCityName(place);
      final String country = place.country ?? '';
      final String fullAddress = _buildFullAddress(place);

      return LocationModel(
        latitude: latitude,
        longitude: longitude,
        cityName: cityName,
        country: country,
        fullAddress: fullAddress,
        isCurrentLocation: isCurrentLocation,
      );
    } catch (error) {
      throw LocationServiceException(
        'Không thể lấy thông tin địa chỉ. Chi tiết: $error',
      );
    }
  }

  Future<LocationModel> getCurrentLocationModel() async {
    final Position position = await getCurrentPosition();

    return getLocationModelFromCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
      isCurrentLocation: true,
    );
  }

  String _getBestCityName(Placemark place) {
    if (place.locality?.isNotEmpty == true) {
      return place.locality!;
    }

    if (place.subAdministrativeArea?.isNotEmpty == true) {
      return place.subAdministrativeArea!;
    }

    if (place.administrativeArea?.isNotEmpty == true) {
      return place.administrativeArea!;
    }

    return 'Unknown';
  }

  String _buildFullAddress(Placemark place) {
    final List<String> parts =
        [
              place.street,
              place.subLocality,
              place.locality,
              place.subAdministrativeArea,
              place.administrativeArea,
              place.country,
            ]
            .where((String? value) => value != null && value.trim().isNotEmpty)
            .map((String? value) => value!.trim())
            .toList();

    return parts.join(', ');
  }
}

class LocationServiceException implements Exception {
  final String message;

  const LocationServiceException(this.message);

  @override
  String toString() {
    return message;
  }
}
