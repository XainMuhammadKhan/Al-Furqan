import 'package:alfurqan/View/Home/Home_Screen.dart';
import 'package:alfurqan/View/Juz/Juz_Screen.dart';
import 'package:alfurqan/View/Main/Main_Screen.dart';
import 'package:alfurqan/View/Prayer/Prayer_Screen.dart';
import 'package:alfurqan/View/Qari_List/Qari_List_Screen.dart';
import 'package:alfurqan/View/Quran/Quran_Screen.dart';
import 'package:alfurqan/View/Splash/Splash_Screen.dart';
import 'package:alfurqan/View/Surah/surah_detail_screen.dart';
import 'package:alfurqan/View/audio/Audio_Screen.dart';
import 'package:alfurqan/View/onboarding/Onboarding_Screen.dart';
// auth-related screens removed
import 'package:alfurqan/resources/routes/route_names.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: RouteNames.splash,
      page: () => const SplashScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.onboarding,
      page: () => const OnboardingScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.main,
      page: () => const MainScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.home,
      page: () => HomeScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.quran,
      page: () => const QuranScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.qari,
      page: () => const QariListScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.audio,
      page: () => const AudioScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.prayer,
      page: () => PrayerScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.juz,
      page: () => JuzScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.surahDetail,
      page: () => SurahDetailScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.fadeIn,
    ),
    // auth routes removed
  ];
}
