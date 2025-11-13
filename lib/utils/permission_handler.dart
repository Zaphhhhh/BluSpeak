import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionHandler {
  Future<void> requestPermissionsOnFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();

    bool hasBeenRequested = prefs.getBool('permissions_requested') ?? false;

    if (!hasBeenRequested) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();

      await prefs.setBool('permissions_requested', true);
    }
  }
}
