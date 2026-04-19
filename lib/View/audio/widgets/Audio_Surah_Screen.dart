import 'package:alfurqan/Model/Qari/qari.dart';
import 'package:alfurqan/Model/Surah/Surah.dart';
import 'package:alfurqan/View/Quran/widgets/Surah_Custom_List_Tile.dart';
import 'package:alfurqan/View/audio/widgets/Audio_Tile.dart';
import 'package:alfurqan/ViewModel/controller/Quran/quran_controller.dart';
import 'package:alfurqan/ViewModel/controller/surah_detail/surah_detail_controller.dart';
import 'package:alfurqan/resources/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alfurqan/View/audio/Audio_Screen.dart';

class AudioSurahScreen extends StatefulWidget {
  final Qari qari;
  const AudioSurahScreen({super.key, required this.qari});

  @override
  State<AudioSurahScreen> createState() => _AudioSurahScreenState();
}

class _AudioSurahScreenState extends State<AudioSurahScreen> {
  QuranController _c = QuranController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _c.getSurah(),
        builder: (BuildContext context, AsyncSnapshot<List<Surah>> snapshot) {
          if (snapshot.hasData) {
            List<Surah>? surah = snapshot.data;
            return ListView.builder(
              itemCount: surah!.length,
              itemBuilder: (context, index) {
                final s = surah[index];
                return SurahCustomListTile(
                  surah: s,
                  onTap: () {
                    Get.to(
                      () => AudioScreen(
                        qari: widget.qari,
                        index: s.number,
                        surahList: surah,
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
