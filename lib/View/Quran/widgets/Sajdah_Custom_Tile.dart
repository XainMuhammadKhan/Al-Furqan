import 'package:alfurqan/Model/Sajdah/Sajdah.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';

class SajdahCustomTile extends StatelessWidget {
  final SajdahAyat sajdahAyat;

  const SajdahCustomTile({super.key, required this.sajdahAyat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.splashGrad1, AppColors.splashGrad2],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        AppImages.ayacardpattern,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Container(
                          height: 38,
                          width: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.splashLogoGlow,
                              width: 2.5,
                            ),
                            shape: BoxShape.circle,
                            color: AppColors.splashGrad2,
                          ),
                          child: Text(
                            sajdahAyat.juzNumber.toString(),
                            style: AppFonts.montserratStyle(
                              color: Colors.white,
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sajdahAyat.surahEnglishName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.montserratStyle(
                                  color: Colors.white,
                                  weight: FontWeight.bold,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sajdah ${sajdahAyat.sajdaNumber}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.montserratStyle(
                                  weight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  size: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        Flexible(
                          child: Text(
                            sajdahAyat.surahName,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.montserratStyle(
                              color: Colors.white.withOpacity(0.95),
                              weight: FontWeight.bold,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
