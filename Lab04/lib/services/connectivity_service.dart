import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  Future<bool> hasInternetConnection() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();

    return _isConnectedResult(result);
  }

  Stream<bool> get connectionStatusStream {
    return _connectivity.onConnectivityChanged.map(_isConnectedResult);
  }

  bool _isConnectedResult(ConnectivityResult result) {
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn;
  }
}
