import 'dart:convert';

import 'package:alfurqan/Model/Qari/qari.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class QariController extends GetxController {
  final RxList<Qari> allQaris = <Qari>[].obs;
  final RxList<Qari> filteredQaris = <Qari>[].obs;
  final RxBool isLoading = false.obs;
  final url = "https://quranicaudio.com/api/qaris";

  Future<void> loadQaris() async {
    try {
      isLoading.value = true;
      final res = await http.get(Uri.parse(url));
      final List decoded = jsonDecode(res.body);
      allQaris.clear();
      for (var element in decoded) {
        allQaris.add(Qari.fromJson(element));
      }
      allQaris.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
      // initially show all
      filteredQaris.assignAll(allQaris);
    } finally {
      isLoading.value = false;
    }
  }

  void search(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) {
      filteredQaris.assignAll(allQaris);
    } else {
      filteredQaris.assignAll(
        allQaris.where((item) {
          final name = (item.name ?? '').toLowerCase();
          return name.contains(query);
        }).toList(),
      );
    }
  }
}
