import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/location_model.dart';

class LocationService {
  /// Mô tả:
  /// Kiểm tra dịch vụ GPS của thiết bị có đang bật hay không.
  ///
  /// Output:
  /// - true: GPS đang bật.
  /// - false: GPS đang tắt.
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// Mô tả:
  /// Kiểm tra và yêu cầu quyền truy cập vị trí.
  ///
  /// Logic:
  /// - Nếu GPS chưa bật thì báo lỗi.
  /// - Nếu quyền đang bị từ chối thì xin quyền.
  /// - Nếu quyền bị từ chối vĩnh viễn thì báo lỗi để người dùng mở Settings.
  ///
  /// Output:
  /// - true nếu app có quyền lấy vị trí.
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

  /// Mô tả:
  /// Lấy tọa độ GPS hiện tại của thiết bị.
  ///
  /// Output:
  /// - Position chứa latitude, longitude và các thông tin GPS khác.
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

  /// Mô tả:
  /// Chuyển tọa độ GPS thành tên thành phố.
  ///
  /// Input:
  /// - latitude: vĩ độ.
  /// - longitude: kinh độ.
  ///
  /// Output:
  /// - Tên thành phố hoặc khu vực gần nhất.
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

  /// Mô tả:
  /// Chuyển tọa độ GPS thành LocationModel đầy đủ.
  ///
  /// Input:
  /// - latitude: vĩ độ.
  /// - longitude: kinh độ.
  /// - isCurrentLocation: đánh dấu đây có phải vị trí hiện tại không.
  ///
  /// Output:
  /// - LocationModel gồm tọa độ, thành phố, quốc gia và địa chỉ đầy đủ.
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

  /// Mô tả:
  /// Lấy vị trí hiện tại và trả về LocationModel.
  ///
  /// Output:
  /// - LocationModel của vị trí hiện tại.
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
