import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionsUtil {
  // 갤러리 접근 권한 요청
  static Future<bool> requestGalleryPermission() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isGranted) {
        return true;
      } else {
        status = await Permission.photos.request();
        return status.isGranted;
      }
    } else if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      }

      if (await Permission.storage.request().isGranted) {
        return true;
      }

      // Android 11 이상일 경우 MANAGE_EXTERNAL_STORAGE 권한 요청
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return false;
  }

  // 카메라 접근 권한 요청
  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.camera.request();
      return status.isGranted;
    }
  }
}
