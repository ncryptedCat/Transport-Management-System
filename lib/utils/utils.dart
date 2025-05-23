import 'package:permission_handler/permission_handler.dart';

class Utils {
  /// Request only notification permission
  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      await Permission.notification.request();
    }
  }

  /// Request only location permission (when in use)
  Future<void> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      await Permission.locationWhenInUse.request();
    }
  }
}
