import 'package:alfurqan/ViewModel/controller/onBoard/onBoarding_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController controller = OnboardingController();

  PageViewModel _buildPage({
    required String title,
    required String body,
    required String image,
  }) {
    return PageViewModel(
      title: title,
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          body,
          textAlign: TextAlign.center,
          style: AppFonts.montserratStyle(
            size: 15,
            weight: FontWeight.w400,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ),
      image: Center(child: Image.asset(image, fit: BoxFit.fitWidth)),
      decoration: PageDecoration(
        pageColor: Colors.transparent,
        imagePadding: const EdgeInsets.only(top: 40),
        titleTextStyle: AppFonts.montserratStyle(
          size: 24,
          weight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyTextStyle: AppFonts.montserratStyle(
          size: 15,
          weight: FontWeight.w400,
          color: Colors.white.withOpacity(0.85),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
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

              // Watermark pattern — fades in from mid to bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 400,
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
              ),

              // Onboarding content on top
              SafeArea(
                child: IntroductionScreen(
                  globalBackgroundColor: Colors.transparent,
                  showSkipButton: true,
                  skip: Text(
                    'Skip',
                    style: AppFonts.montserratStyle(
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  onSkip: () => controller.NavigateToMain(),
                  pages: [
                    _buildPage(
                      title: "Read Quran",
                      body:
                          "Customize your reading and listening experience with our intuitive interface.",
                      image: AppImages.Quran,
                    ),
                    _buildPage(
                      title: "Prayer Alerts",
                      body:
                          "Never miss a prayer with our timely alerts and reminders.",
                      image: AppImages.Namaz,
                    ),
                    _buildPage(
                      title: "Spend In The Way Of Allah",
                      body:
                          "Spend in the way of Allah and contribute to meaningful causes, while multiplying your rewards.",
                      image: AppImages.Zakat,
                    ),
                  ],
                  showNextButton: true,
                  next: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.secondaryTextColor,
                  ),
                  done: Text(
                    "Done",
                    style: AppFonts.montserratStyle(
                      color: AppColors.secondaryTextColor,
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  onDone: () => controller.NavigateToMain(),
                  dotsDecorator: DotsDecorator(
                    size: const Size.square(10.0),
                    activeSize: const Size(20.0, 10.0),
                    activeColor: AppColors.splashGrad1,
                    color: AppColors.splashGrad1_2ndshade,
                    spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
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
