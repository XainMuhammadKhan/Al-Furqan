import 'package:alfurqan/resources/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  bool alreadyUsed = false;

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    alreadyUsed = prefs.getBool('alreadyUsed') ?? false;
  }

  void initAnimations(TickerProvider vsync) {
    // initialize animations immediately so build can use them
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      animationController.forward();
    });

    Future.delayed(const Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();
      final used = prefs.getBool('alreadyUsed') ?? false;

      // If onboarding hasn't been seen, show it next
      if (!used) {
        Get.offAllNamed(RouteNames.onboarding);
        return;
      }

      // Otherwise, send user to main screen
      Get.offAllNamed(RouteNames.main);
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
