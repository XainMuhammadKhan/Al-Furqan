import 'package:alfurqan/View/Splash/Splash_Screen.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alfurqan/firebase_options.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before using any Firebase services
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Make status bar transparent as early as possible
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al Furqan',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryBgColor,
        indicatorColor: AppColors.splashLogoGlow,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.primaryTextColor),
          bodyMedium: TextStyle(color: AppColors.primaryTextColor),
          bodySmall: TextStyle(color: AppColors.primaryTextColor),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.splashLogoGlow, // Blinking pointer color
          selectionHandleColor:
              AppColors.splashLogoGlow, // Handle below the pointer
          selectionColor:
              AppColors.splashGrad1_2ndshade, // Background highlight
        ),
      ),
      home: SplashScreen(),
      getPages: AppRoutes.routes,
    );
  }
}
