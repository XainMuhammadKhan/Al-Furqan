import 'package:alfurqan/Model/Qari/qari.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';

class QariCustomTile extends StatefulWidget {
  final Qari qari;
  final VoidCallback ontap;
  const QariCustomTile({super.key, required this.qari, required this.ontap});

  @override
  State<QariCustomTile> createState() => _QariCustomTileState();
}

class _QariCustomTileState extends State<QariCustomTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: widget.ontap,
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
                            (widget.qari.name != null &&
                                    widget.qari.name!.isNotEmpty)
                                ? widget.qari.name!
                                      .substring(0, 1)
                                      .toUpperCase()
                                : "Q",
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
                                widget.qari.name ?? "Unknown Qari",
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
                                widget.qari.format ?? widget.qari.path ?? "",
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

                        // Removed duplicate right-side name to give full space
                        // for the main title and format.
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
