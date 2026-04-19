import 'package:alfurqan/Model/juz/juz.dart';
import 'package:alfurqan/View/Juz/widgets/Juz_Custom_Tile.dart';
import 'package:alfurqan/View/Quran/constants/juz_const.dart';
import 'package:alfurqan/View/Juz/widgets/Juz_Custom_Tile.dart';
import 'package:alfurqan/ViewModel/controller/juz/juz_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JuzScreen extends StatelessWidget {
  static const String id = 'juz_screen';
  final JuzController c = Get.put(JuzController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<JuzModel>(
        // guard against null; default to juz 1 if not set
        future: c.getJuz(JuzConst.juzIndex ?? 1),
        builder: (context, AsyncSnapshot<JuzModel> snapshot) {
          print('snapshot: ${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // show the error message to help debugging
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            print('${snapshot.data!.juzAyahs.length} length');
            return ListView.builder(
              itemCount: snapshot.data!.juzAyahs.length,
              itemBuilder: (context, index) {
                return JuzCustomTile(
                  list: snapshot.data!.juzAyahs,
                  index: index,
                );
              },
            );
          } else {
            return const Center(child: Text("No Data"));
          }
        },
      ),
    );
  }
}
