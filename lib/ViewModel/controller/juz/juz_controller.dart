import 'dart:convert';

import 'package:alfurqan/Model/juz/juz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class JuzController extends GetxController {
  final endPointUrl = 'https://api.alquran.cloud/v1/juz/';
  // simple in-memory cache to avoid repeated API calls and reduce rate-limit hits
  final Map<int, JuzModel> _cache = {};

  Future<JuzModel> getJuz(int index) async {
    // return cached if available
    if (_cache.containsKey(index)) {
      return _cache[index]!;
    }

    final url = endPointUrl + "$index/quran-uthmani";
    print('getJuz: requesting $url');
    try {
      final response = await http.get(Uri.parse(url));
      print('getJuz: status=${response.statusCode}');
      final body = response.body;
      print(
        'getJuz: body snippet: ${body.length > 200 ? body.substring(0, 200) + '...' : body}',
      );

      if (response.statusCode == 200) {
        final model = JuzModel.fromJson(json.decode(response.body));
        _cache[index] = model;
        return model;
      } else if (response.statusCode == 429) {
        print('failed to load juz: 429 (rate limited)');
        // If we have a cached version, return it; otherwise return a lightweight fallback model
        if (_cache.containsKey(index)) return _cache[index]!;
        final fallback = JuzModel(
          juzNumber: index,
          name: '',
          juzAyahs: [],
          displayArabicTitle: 'الجزء $index',
          displayEnglishSubtitle: 'Juz $index',
        );
        _cache[index] = fallback;
        return fallback;
      } else {
        print("failed to load juz: ${response.statusCode}");
        throw Exception('Failed to load Juz: ${response.statusCode}');
      }
    } catch (e) {
      print('getJuz: exception: $e');
      // Return cached fallback if present, otherwise return minimal fallback to keep UI responsive
      if (_cache.containsKey(index)) return _cache[index]!;
      final fallback = JuzModel(
        juzNumber: index,
        name: '',
        juzAyahs: [],
        displayArabicTitle: 'الجزء $index',
        displayEnglishSubtitle: 'Juz $index',
      );
      _cache[index] = fallback;
      return fallback;
    }
  }
}
