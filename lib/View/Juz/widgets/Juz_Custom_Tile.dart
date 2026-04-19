import 'package:flutter/material.dart';
import 'package:alfurqan/Model/juz/juz.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';

class JuzCustomTile extends StatelessWidget {
  final List<JuzAyahs> list;
  final int index;
  final VoidCallback? onTap;

  const JuzCustomTile({
    super.key,
    required this.list,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = list[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
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

            // CLIPPED CONTENT
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  // Gradient background
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.splashGrad1,
                            AppColors.splashGrad2,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),

                  // Pattern overlay (subtle)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        AppImages.ayacardpattern,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        // Number circle (ayah number)
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
                            item.ayahNumber.toString(),
                            style: AppFonts.montserratStyle(
                              color: Colors.white,
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Middle column: surah name + snippet
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.surahName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.montserratStyle(
                                  color: Colors.white,
                                  weight: FontWeight.bold,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.ayahsText,
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

                        // Right: show a short Arabic/large snippet (use ayah text trimmed)
                        Flexible(
                          child: Text(
                            item.ayahsText,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.montserratStyle(
                              color: Colors.white.withOpacity(0.9),
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
