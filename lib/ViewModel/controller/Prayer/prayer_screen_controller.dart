import 'package:get/get.dart';
import 'package:location/location.dart';

class PrayerScreenController extends GetxController {
  Location location = Location();
  LocationData? _currentPosition;
  double? latitude, longitude;
  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();

    latitude = _currentPosition?.latitude;
    longitude = _currentPosition?.longitude;
  }
}
