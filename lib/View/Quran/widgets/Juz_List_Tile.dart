import 'package:flutter/material.dart';
import 'package:alfurqan/ViewModel/controller/juz/juz_controller.dart';
import 'package:alfurqan/ViewModel/controller/Quran/quran_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:alfurqan/Model/juz/juz_names.dart';
import 'package:get/get.dart';

class JuzListTile extends StatefulWidget {
  final int juzNumber;
  const JuzListTile({Key? key, required this.juzNumber}) : super(key: key);

  @override
  State<JuzListTile> createState() => _JuzListTileState();
}

class _JuzListTileState extends State<JuzListTile> {
  final JuzController _jc = Get.put(JuzController());
  final QuranController _qc = Get.put(QuranController());
  late final Future _future;

  @override
  void initState() {
    super.initState();
    _future = _jc.getJuz(widget.juzNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          // Use hard-coded Juz names to avoid inconsistent API-derived titles
          final arabic = JuzNames.getArabic(widget.juzNumber);
          final english = JuzNames.getEnglish(widget.juzNumber);

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                _qc.selectJuzByZeroIndex(widget.juzNumber - 1);
                _qc.navigateToJuzScreen();
              },
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
                                widget.juzNumber.toString(),
                                textAlign: TextAlign.center,
                                style: AppFonts.montserratStyle(
                                  color: Colors.white,
                                  size: 14,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            // English column (allows two lines if needed)
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    english,
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
                                    'Juz ${widget.juzNumber}',
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

                            // Arabic area fixed width on the right, right-aligned and wraps
                            LayoutBuilder(builder: (context, constraints) {
                              final arabicWidth = MediaQuery.of(context).size.width * 0.30;
                              return SizedBox(
                                width: arabicWidth,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    arabic,
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.montserratStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      weight: FontWeight.bold,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
