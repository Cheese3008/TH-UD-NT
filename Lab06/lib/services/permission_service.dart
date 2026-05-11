import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestAudioPermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return true;
    }

    final audioStatus = await Permission.audio.request();
    if (audioStatus.isGranted || audioStatus.isLimited) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted || storageStatus.isLimited) {
      return true;
    }

    if (audioStatus.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  Future<bool> hasPermissions() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return true;
    }

    final audioGranted = await Permission.audio.isGranted;
    final storageGranted = await Permission.storage.isGranted;
    return audioGranted || storageGranted;
  }
}
