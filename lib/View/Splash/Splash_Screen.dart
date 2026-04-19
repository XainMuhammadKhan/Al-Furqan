import 'package:alfurqan/ViewModel/controller/splash/splash_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SplashController());
    _controller.initAnimations(this); // pass TickerProvider from the State
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.vigGrad1,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.splashGrad1, AppColors.splashGrad2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Vignette overlay
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [AppColors.vigGrad1, AppColors.vigGrad2],
                    radius: 1.2,
                    center: Alignment.center,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 400, // covers bottom half of screen
                child: ShaderMask(
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.vigGrad1, // fully invisible at top
                      AppColors.primaryBgColor, // fully visible at bottom
                    ],
                    stops: [0.0, 1.0],
                  ).createShader(rect),
                  blendMode: BlendMode.dstIn, // masks using gradient alpha
                  child: Opacity(
                    opacity: 0.12,
                    child: Image.asset(
                      AppImages.geometricPattern,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      color: AppColors.primaryBgColor,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              // Logo + glow
              Center(
                child: FadeTransition(
                  opacity: _controller.fadeAnimation,
                  child: ScaleTransition(
                    scale: _controller.scaleAnimation,
                    child: SizedBox(
                      width: 350,
                      height: 420,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow behind circular part of logo
                          Positioned(
                            top: 0,
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.splashLogoGlow.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 40,
                                    spreadRadius: 8,
                                  ),
                                  BoxShadow(
                                    color: AppColors.splashLogoGlow.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 80,
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Full logo — no clipping, stand feet fully visible
                          Image.asset(
                            AppImages.SplashImage,
                            width: 320,
                            height: 400,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // App name
              Positioned(
                bottom: 70,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _controller.fadeAnimation,
                  child: Center(
                    child: Text(
                      "Al Furqan",
                      style: AppFonts.montserratStyle(
                        size: 22,
                        weight: FontWeight.w400,
                        color: AppColors.primaryTextColor.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),

              // Arabic tagline
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _controller.fadeAnimation,
                  child: Center(
                    child: Text(
                      "القرآن الكريم",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFonts.arabic,
                        color: AppColors.primaryTextColor.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
