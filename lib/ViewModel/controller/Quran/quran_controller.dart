import 'dart:convert';

import 'package:alfurqan/Model/Surah/Surah.dart';
import 'package:alfurqan/Model/Translation/translation.dart';
import 'package:alfurqan/View/Quran/constants/juz_const.dart';
import 'package:alfurqan/resources/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class QuranController extends GetxController {
  final endPointUrl = "https://api.alquran.cloud/v1/surah";
  List<Surah> surahs = [];
  // selected juz (1..30)
  RxInt selectedJuz = 1.obs;

  /// Set selected juz by zero-based index from UI (index), store to JuzConst as 1-based
  void selectJuzByZeroIndex(int index) {
    final oneBased = index + 1;
    JuzConst.juzIndex = oneBased;
    selectedJuz.value = oneBased;
  }

  Future<List<Surah>> getSurah() async {
    final res = await http.get(Uri.parse(endPointUrl));
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);
      json['data'].forEach((element) {
        if (surahs.length < 114) {
          surahs.add(Surah.fromJson(element));
        }
      });
      print('ol ${surahs.length}');
      return surahs;
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  void navigateToJuzScreen() {
    // Use push navigation so existing controllers aren't disposed.
    Get.toNamed(RouteNames.juz);
  }

  void navigateToSurahDetailScreen() {
    Get.toNamed(RouteNames.surahDetail);
  }
}
