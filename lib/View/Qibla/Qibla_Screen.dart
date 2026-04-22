import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/ViewModel/controller/Qibla/qibla_controller.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';

/// Main screen displaying Qibla direction with compass
class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  static const double _compassContainerWidth = 350.0;
  static const double _compassContainerHeight = 420.0;
  static const double _glowSize = 340.0;
  static const double _compassSize = 320.0;
  static const double _compassVerticalOffset = -24.0;
  static const double _watermarkHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        backgroundColor: AppColors.primaryBgColor,
        body: _buildBody(),
      ),
    );
  }

  /// Builds transparent app bar with title
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'Qibla Direction',
        style: AppFonts.montserratStyle(
          color: AppColors.primaryTextColor,
          size: 18,
          weight: FontWeight.w700,
        ),
      ),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.primaryTextColor),
    );
  }

  /// Builds main body with gradient background and compass
  Widget _buildBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: _buildGradientBackground(),
      child: Stack(
        children: [
          _buildVignetteOverlay(),
          _buildWatermarkPattern(),
          _buildCompassSection(),
        ],
      ),
    );
  }

  /// Creates gradient background decoration
  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.splashGrad1, AppColors.splashGrad2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Builds radial vignette overlay
  Widget _buildVignetteOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [AppColors.vigGrad1, AppColors.vigGrad2],
          radius: 1.2,
          center: Alignment.center,
        ),
      ),
    );
  }

  /// Builds fading watermark pattern at bottom
  Widget _buildWatermarkPattern() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: _watermarkHeight,
      child: ShaderMask(
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.white],
          stops: [0.0, 1.0],
        ).createShader(rect),
        blendMode: BlendMode.dstIn,
        child: Opacity(
          opacity: 0.12,
          child: Image.asset(
            AppImages.geometricPattern,
            width: double.infinity,
            fit: BoxFit.cover,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  /// Builds centered compass section with glow effect
  Widget _buildCompassSection() {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, _compassVerticalOffset),
        child: SizedBox(
          width: _compassContainerWidth,
          height: _compassContainerHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [_buildCompassGlow(), _buildCompassWidget()],
          ),
        ),
      ),
    );
  }

  /// Builds circular glow effect behind compass
  Widget _buildCompassGlow() {
    return Center(
      child: Container(
        width: _glowSize,
        height: _glowSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.splashLogoGlow.withOpacity(0.5),
              blurRadius: 40,
              spreadRadius: 8,
            ),
            BoxShadow(
              color: AppColors.splashLogoGlow.withOpacity(0.3),
              blurRadius: 80,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds compass widget container
  Widget _buildCompassWidget() {
    return SizedBox(
      width: _compassSize,
      height: _compassContainerHeight,
      child: Center(child: QiblahCompass()),
    );
  }
}
