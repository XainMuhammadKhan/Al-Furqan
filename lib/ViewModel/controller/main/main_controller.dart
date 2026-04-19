import 'package:alfurqan/View/Home/Home_Screen.dart';
import 'package:alfurqan/View/Prayer/Prayer_Screen.dart';
import 'package:alfurqan/View/Quran/Quran_Screen.dart';
import 'package:alfurqan/View/Qari_List/Qari_List_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt currentIndex = 0.obs;
  List<Widget> widgetList = [
    HomeScreen(),
    QuranScreen(),
    QariListScreen(),
    PrayerScreen(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
