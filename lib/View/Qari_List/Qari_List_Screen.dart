import 'package:alfurqan/Model/Qari/qari.dart';
import 'package:alfurqan/View/Qari_List/widgets/Qari_CustomTile.dart';
import 'package:alfurqan/ViewModel/controller/Qari/qari_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:alfurqan/View/audio/widgets/Audio_Surah_Screen.dart';
import 'package:alfurqan/View/audio/Audio_Screen.dart';
import 'package:get/get.dart';

class QariListScreen extends StatelessWidget {
  const QariListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QariController _c = Get.put(QariController());
    // load once if not loaded
    if (_c.allQaris.isEmpty && !_c.isLoading.value) {
      _c.loadQaris();
    }
    return Scaffold(
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
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.only(top: 20, left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: AppColors.primaryBgColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vigGrad2,
                    blurRadius: 1,
                    spreadRadius: 0.0,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: AppColors.secondaryTextColor),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: AppColors.secondaryTextColor.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.splashGrad2,
                    ),
                  ),
                  onChanged: _c.search,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (_c.isLoading.value)
                  return Center(child: CircularProgressIndicator());
                if (_c.filteredQaris.isEmpty)
                  return Center(child: Text('No Qaris found'));
                return ListView.builder(
                  itemCount: _c.filteredQaris.length,
                  itemBuilder: (context, index) {
                    final q = _c.filteredQaris[index];
                    return QariCustomTile(
                      qari: q,
                      ontap: () => Get.to(() => AudioSurahScreen(qari: q)),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
