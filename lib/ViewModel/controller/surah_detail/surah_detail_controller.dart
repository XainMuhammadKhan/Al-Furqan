import 'dart:convert';

import 'package:alfurqan/Model/Translation/translation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum Translation { urdu, spanish, english }

class SurahDetailController extends GetxController {
  final _endpointBase = "https://quranenc.com/api/translation/sura";

  // reactive selected translation
  final selectedTranslation = Translation.urdu.obs;

  void onTranslationChanged(Translation? value) {
    if (value != null) {
      selectedTranslation.value = value;
    }
  }

  String _keyFor(Translation t) {
    switch (t) {
      case Translation.urdu:
        return 'urdu_junagarhi';
      case Translation.spanish:
        return 'spanish_garcia';
      case Translation.english:
        return 'english_saheeh';
    }
  }

  Future<SurahTranslationList> getTranslation(
    int index,
    int translationIndex,
  ) async {
    // API expects 1-based surah number

    final surahNumber = index <= 0 ? 1 : index + 1;
    final Translation t =
        (translationIndex >= 0 && translationIndex < Translation.values.length)
        ? Translation.values[translationIndex]
        : selectedTranslation.value;
    final key = _keyFor(t);
    final url = "$_endpointBase/$key/$surahNumber";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(res.body);
      return SurahTranslationList.fromJson(body);
    } else {
      throw Exception('Failed to load translation: ${res.statusCode}');
    }
  }
}
