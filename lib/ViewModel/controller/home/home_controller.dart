import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:alfurqan/Model/Aya_Of_The_Day/Aya_Of_The_Day.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final aya = Rxn<AyaOfTheDay>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRandomAya();
  }

  Future<void> loadRandomAya() async {
    try {
      isLoading.value = true;
      final id = _random(1, 6237);
      final url =
          'https://api.alquran.cloud/v1/ayah/$id/editions/quran-uthmani,en.asad,en.pickthall';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final Map<String, dynamic> body =
            json.decode(res.body) as Map<String, dynamic>;
        aya.value = AyaOfTheDay.fromJson(body);
      } else {
        Get.snackbar('Oh Blimey!', 'Failed to load Aya of the Day');
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        "Something went wrong while fetching the Aya of the Day",
      );
    } finally {
      isLoading.value = false;
    }
  }

  int _random(int min, int max) {
    final rn = Random();
    return min + rn.nextInt(max - min);
  }

  void setData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('alreadyUsed', true);
  }
}
