import 'package:alfurqan/Model/Surah/Surah.dart';
import 'package:alfurqan/View/Quran/widgets/Sajdah_Custom_Tile.dart';
import 'package:alfurqan/View/Quran/widgets/Surah_Custom_List_Tile.dart';
import 'package:alfurqan/View/Quran/widgets/Juz_List_Tile.dart';
import 'package:alfurqan/ViewModel/controller/Quran/quran_controller.dart';
// removed unused import
import 'package:alfurqan/ViewModel/controller/sajdah/sajdah_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alfurqan/View/Quran/constants/surah_const.dart';
import 'package:alfurqan/resources/routes/route_names.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  @override
  Widget build(BuildContext context) {
    final QuranController c = Get.put(QuranController());
    final SajdahController sc = Get.put(SajdahController());
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white, // IMPORTANT: set explicitly
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: AppBar(
              toolbarHeight: 50,
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              centerTitle: true,

              title: Text(
                "Quran",
                style: AppFonts.montserratStyle(
                  size: 22,
                  weight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),

              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.splashGrad1, AppColors.splashGrad2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                  // Pattern
                  Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      AppImages.geometricPatternGold,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

              bottom: TabBar(
                indicatorColor: AppColors.splashGrad2,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent, // 🔥 removes hidden line
                tabs: [
                  Text(
                    "Surah",
                    style: AppFonts.montserratStyle(
                      color: AppColors.primaryTextColor,
                      weight: FontWeight.w600,
                      size: 18,
                    ),
                  ),
                  Text(
                    "Juz",
                    style: AppFonts.montserratStyle(
                      color: AppColors.primaryTextColor,
                      weight: FontWeight.w600,
                      size: 18,
                    ),
                  ),
                  Text(
                    "Sajdah",
                    style: AppFonts.montserratStyle(
                      color: AppColors.primaryTextColor,
                      weight: FontWeight.w600,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder(
              future: c.getSurah(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Surah>> snapshot) {
                    if (snapshot.hasData) {
                      List<Surah>? surah = snapshot.data;
                      return ListView.builder(
                        itemCount: surah!.length,
                        itemBuilder: (context, index) => SurahCustomListTile(
                          surah: surah[index],
                          onTap: () {
                            // Store selected surah index and navigate to detail
                            SurahConst.surahIndex = index;
                            Get.toNamed(
                              RouteNames.surahDetail,
                              arguments: {'index': index},
                            );
                          },
                        ),
                      );
                    }
                    return Center(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: ShaderMask(
                          shaderCallback: (rect) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.splashGrad1,
                              AppColors.splashGrad2,
                            ],
                          ).createShader(rect),
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
            ),
            // Juz list: use JuzListTile (matches Surah tiles)
            FutureBuilder(
              future: Future.value(true),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return JuzListTile(juzNumber: index + 1);
                  },
                );
              },
            ),
            FutureBuilder(
              future: sc.getSajdah(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading Sajdahs"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.sajdahAyahs.length,
                  itemBuilder: (context, index) => SajdahCustomTile(
                    sajdahAyat: snapshot.data!.sajdahAyahs[index],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
