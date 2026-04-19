import 'package:alfurqan/View/Home/widgets/Aya_Card/Aya_Card.dart';
import 'package:alfurqan/ViewModel/controller/home/home_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController c = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    HijriCalendar.setLocal("ar");
    final hijri = HijriCalendar.now();
    final formatted = DateFormat('EEE, d MMM yyyy').format(DateTime.now());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔷 HEADER
            Container(
              height: size.height * 0.30,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(AppImages.background, fit: BoxFit.cover),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatted,
                            style: AppFonts.montserratStyle(
                              color: AppColors.primaryTextColor,
                              size: 22,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),

                          Row(
                            children: [
                              Text(
                                hijri.hDay.toString(),
                                style: AppFonts.montserratStyle(
                                  color: AppColors.primaryTextColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                hijri.longMonthName,
                                style: AppFonts.montserratStyle(
                                  color: AppColors.primaryTextColor,
                                  size: 18,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${hijri.hYear} AH',
                                style: AppFonts.montserratStyle(
                                  color: AppColors.primaryTextColor,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🔥 OVERLAP EFFECT (NO STACK NEEDED)
            Transform.translate(
              offset: const Offset(0, -40), // overlap amount
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AyaCard(controller: c),
              ),
            ),

            /// spacing after overlap
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
