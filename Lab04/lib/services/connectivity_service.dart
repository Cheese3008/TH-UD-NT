import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Mô tả:
  /// Kiểm tra thiết bị hiện tại có kết nối mạng hay không.
  ///
  /// Output:
  /// - true nếu có WiFi, mobile data hoặc ethernet.
  /// - false nếu không có mạng.
  Future<bool> hasInternetConnection() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();

    return _isConnectedResult(result);
  }

  /// Mô tả:
  /// Theo dõi thay đổi trạng thái mạng.
  ///
  /// Output:
  /// - Luồng trạng thái kết nối mạng dạng true/false.
  /// - true khi có mạng.
  /// - false khi mất mạng.
  Stream<bool> get connectionStatusStream {
    return _connectivity.onConnectivityChanged.map(_isConnectedResult);
  }

  /// Mô tả:
  /// Kiểm tra loại kết nối có phải là kết nối hợp lệ không.
  ///
  /// Input:
  /// - result: trạng thái kết nối từ connectivity_plus.
  ///
  /// Output:
  /// - true nếu có kết nối mạng.
  /// - false nếu không có kết nối.
  bool _isConnectedResult(ConnectivityResult result) {
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn;
  }
}
