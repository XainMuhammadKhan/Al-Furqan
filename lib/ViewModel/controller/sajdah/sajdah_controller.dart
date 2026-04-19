import 'dart:convert';
import 'package:alfurqan/Model/Sajdah/Sajdah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SajdahController extends GetxController {
  Future<SajdahList> getSajdah() async {
    String url = "http://api.alquran.cloud/v1/sajda/en.asad";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return SajdahList.fromJSON(json.decode(response.body));
    } else {
      print("Failed to load Sajdahs");
      throw Exception('Failed to load Sajdahs: ${response.statusCode}');
    }
  }
}
