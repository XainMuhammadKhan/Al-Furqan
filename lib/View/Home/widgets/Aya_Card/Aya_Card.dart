import 'package:alfurqan/ViewModel/controller/home/home_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AyaCard extends StatelessWidget {
  final HomeController controller;

  const AyaCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final ay = controller.aya.value;
      if (ay == null) return const SizedBox();

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.splashGrad1, AppColors.splashGrad2],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            /// ✅ CONTENT (drives height)
            Padding(
              padding: const EdgeInsets.all(40), // give space for border
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heading
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Ayah of the day',
                      textAlign: TextAlign.center,
                      style: AppFonts.montserratStyle(
                        weight: FontWeight.w700,
                        color: AppColors.primaryTextColor.withOpacity(0.95),
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Divider line below heading
                  SizedBox(
                    width: 80,
                    child: Divider(
                      color: AppColors.primaryTextColor.withOpacity(0.6),
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      ay.arabicText ?? '',
                      textAlign: TextAlign.center,
                      style: AppFonts.montserratStyle(
                        weight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '${ay.surahName ?? ''} • Aya ${ay.ayaNumber ?? ''}',
                      textAlign: TextAlign.center,
                      style: AppFonts.montserratStyle(
                        weight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      ay.englishTranslation ?? '',
                      textAlign: TextAlign.center,
                      style: AppFonts.montserratStyle(
                        weight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ✅ FRAME (on top like border)
            Positioned.fill(
              child: IgnorePointer(
                // allows clicks through
                child: Image.asset(
                  AppImages.ayaframe,
                  fit: BoxFit.fill, // ✅ NOW it's correct here
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
