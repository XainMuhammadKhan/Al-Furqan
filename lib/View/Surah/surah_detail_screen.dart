import 'package:alfurqan/Model/Translation/translation.dart';
import 'package:alfurqan/View/Surah/widgets/Translation_tile.dart';
import 'package:alfurqan/ViewModel/controller/surah_detail/surah_detail_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alfurqan/View/Quran/constants/surah_const.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class SurahDetailScreen extends StatelessWidget {
  const SurahDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SurahDetailController c = Get.put(SurahDetailController());

    final args = Get.arguments as Map<String, dynamic>?;
    final int selectedIndex = (args != null && args['index'] != null)
        ? args['index'] as int
        : (SurahConst.surahIndex ?? 0);

    return Scaffold(
      body: Column(
        children: [
          // 🔽 Main Content
          Expanded(
            child: Obx(() {
              return FutureBuilder<SurahTranslationList>(
                future: c.getTranslation(
                  selectedIndex,
                  c.selectedTranslation.value.index,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load Surah Translation'),
                    );
                  }

                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 90),
                      child: ListView.builder(
                        // padding: const EdgeInsets.only(bottom: 60),
                        itemCount: data.translationList.length,
                        itemBuilder: (context, index) {
                          final verse = data.translationList[index];
                          return TranslationTile(
                            index: index,
                            surahTranslation: verse,
                          );
                        },
                      ),
                    );
                  }

                  return const Center(child: Text('No translation available'));
                },
              );
            }),
          ),

          // bottom sheet moved to scaffold.bottomSheet below
        ],
      ),
      bottomSheet: SolidBottomSheet(
        headerBar: SizedBox(
          height: 84,
          width: double.infinity,
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
              Center(
                child: Text(
                  'Swipe Me!',
                  style: AppFonts.montserratStyle(
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          height: 160,
          color: AppColors.primaryBgColor,
          child: Obx(() {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Urdu"),
                    leading: Radio<Translation>(
                      value: Translation.urdu,
                      groupValue: c.selectedTranslation.value,
                      onChanged: c.onTranslationChanged,
                    ),
                  ),
                  ListTile(
                    title: const Text("Spanish"),
                    leading: Radio<Translation>(
                      value: Translation.spanish,
                      groupValue: c.selectedTranslation.value,
                      onChanged: c.onTranslationChanged,
                    ),
                  ),
                  ListTile(
                    title: const Text("English"),
                    leading: Radio<Translation>(
                      value: Translation.english,
                      groupValue: c.selectedTranslation.value,
                      onChanged: c.onTranslationChanged,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
