import 'dart:async';
import 'dart:math' show pi;

import 'package:alfurqan/View/Qibla/Widgets/Location_Error_Widget.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class QiblahCompass extends StatefulWidget {
  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  Future<void> _checkLocationStatus() async {
    // before running the app please enable your location

    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else
      _locationStreamController.sink.add(locationStatus);
  }

  @override
  void initState() {
    _checkLocationStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _locationStreamController.close();
    FlutterQiblah().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.enabled == true) {
            switch (snapshot.data!.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                return QiblahCompassWidget();

              case LocationPermission.denied:
                return LocationErrorWidget(
                  error: "Location service permission denied",
                  callback: _checkLocationStatus,
                );
              case LocationPermission.deniedForever:
                return LocationErrorWidget(
                  error: "Location service Denied Forever !",
                  callback: _checkLocationStatus,
                );
              default:
                return Container();
            }
          } else {
            return LocationErrorWidget(
              error: "Please enable Location service",
              callback: _checkLocationStatus,
            );
          }
        },
      ),
    );
  }
}

class QiblahCompassWidget extends StatefulWidget {
  @override
  _QiblahCompassWidgetState createState() => _QiblahCompassWidgetState();
}

class _QiblahCompassWidgetState extends State<QiblahCompassWidget> {
  final _compassSvg = Image.asset(AppImages.Compass);
  final _needleSvg = Image.asset(
    AppImages.Needle,
    fit: BoxFit.contain,
    height: _needleHeight,
    alignment: Alignment.center,
  );

  static const double _vibrationThreshold = 5.0; // degrees threshold
  // Track alignment state to vibrate each time device enters alignment
  bool _isAligned = false;
  // throttle repeated vibrations: minimum interval between vibrate attempts (ms)
  int _lastVibrateAt = 0;
  static const int _vibrateThrottleMs = 1500;
  // If the needle artwork's default pointing direction is off, adjust here.
  // For example, if the needle points 90° clockwise from 'north', set to -90.0.
  static const double _needleArtworkRotationDeg =
      -90.0; // tune this (degrees). Set to -90 to correct +90° artwork offset.
  // Needle display size (change this to resize the needle image)
  static const double _needleHeight = 240.0;

  double _normalizeAngle(double a) {
    while (a > 180) a -= 360;
    while (a <= -180) a += 360;
    return a;
  }

  double _normalizeAngleDeg(double deg) {
    double a = deg;
    while (a > 180) a -= 360;
    while (a <= -180) a += 360;
    return a;
  }

  static const MethodChannel _platform = MethodChannel('com.alfurqan/vibrate');

  Future<void> _triggerVibration() async {
    try {
      // try platform channel first
      await _platform.invokeMethod('vibrate', {'duration': 80});
      // ignore: avoid_print
      print('Platform vibrate invoked');
      return;
    } catch (e) {
      // ignore: avoid_print
      print('Platform vibrate failed: $e');
    }

    // fallback to HapticFeedback
    try {
      HapticFeedback.vibrate();
      // ignore: avoid_print
      print('HapticFeedback.vibrate called');
    } catch (e) {
      // ignore: avoid_print
      print('HapticFeedback error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final qiblahDirection = snapshot.data!;

        // compute screen angles (degrees) for needle and compass 'W' marker
        // needle screen angle (deg) = - (qiblah - direction + artworkRotation)
        final double needleScreenDeg = _normalizeAngleDeg(
            -(qiblahDirection.qiblah - qiblahDirection.direction + _needleArtworkRotationDeg));

        // compass 'W' marker is at asset angle 270deg; compass rotates by -direction
        // so screen angle of W = -direction + 270
        final double compassWestScreenDeg = _normalizeAngleDeg(-qiblahDirection.direction + 270.0);

        // difference between needle visual angle and compass W marker on screen
        final double angleDelta = _normalizeAngleDeg(needleScreenDeg - compassWestScreenDeg);

        final bool aligned = angleDelta.abs() <= _vibrationThreshold;

        // debug: log the screen angles and delta
        try {
          // ignore: avoid_print
          print('needleScreenDeg:${needleScreenDeg.toStringAsFixed(2)} compassW:${compassWestScreenDeg.toStringAsFixed(2)} delta:${angleDelta.toStringAsFixed(2)} aligned:$aligned');
        } catch (_) {}

        // Try vibrating when aligned. Allow initial aligned state to vibrate (throttled).
        final int now = DateTime.now().millisecondsSinceEpoch;
        if (aligned && (now - _lastVibrateAt >= _vibrateThrottleMs)) {
          _lastVibrateAt = now;
          _triggerVibration();
        }
        _isAligned = aligned;

        // needle rotation relative to rotated compass: apply artwork correction
        final needleAngle =
            (qiblahDirection.qiblah -
                qiblahDirection.direction +
                _needleArtworkRotationDeg) *
            (pi / 180) *
            -1;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: (qiblahDirection.direction * (pi / 180) * -1),
              child: _compassSvg,
            ),
            Transform.rotate(
              angle: needleAngle,
              alignment: Alignment.center,
              child: _needleSvg,
            ),
            Positioned(
              bottom: 8,
              child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
            ),
          ],
        );
      },
    );
  }
}
