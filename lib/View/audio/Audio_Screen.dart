import 'package:alfurqan/Model/Qari/qari.dart';
import 'package:alfurqan/Model/Surah/Surah.dart';
import 'package:alfurqan/View/audio/widgets/seek_bar.dart';
import 'package:alfurqan/ViewModel/controller/audio/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AudioScreen extends GetView<AudioController> {
  final Qari? qari;
  final int? index;
  final List<Surah>? surahList;

  const AudioScreen({Key? key, this.qari, this.index, this.surahList})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioController c = Get.isRegistered<AudioController>() ? Get.find<AudioController>() : Get.put(AudioController());

    // Initialize controller if arguments were passed
    if (qari != null && index != null) {
      c.initPlayer(qari: qari!, index: index!, list: surahList);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          'Now Playing',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Obx(() {
                final idx = c.currentIndex.value;
                final item =
                    (c.surahList != null &&
                        idx >= 0 &&
                        idx < c.surahList!.length)
                    ? c.surahList![idx]
                    : null;
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                      colors: [AppColors.splashGrad1, AppColors.splashGrad2],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        color: AppColors.vigGrad2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item?.name ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item != null ? 'Total Aya : ${item.numberOfAyahs}' : '',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // Seek bar
              StreamBuilder<PositionData>(
                stream: c.positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? c.defaultDuration,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChanged: c.seek,
                  );
                },
              ),

              SizedBox(height: 10),

              // Controls row
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: c.previous,
                      icon: FaIcon(
                        FontAwesomeIcons.stepBackward,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),

                    StreamBuilder<PlayerState>(
                      stream: c.player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing ?? false;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.splashGrad2,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        } else if (!playing) {
                          return InkWell(
                            onTap: c.play,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.splashGrad2,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.play,
                                color: Colors.black,
                                size: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return InkWell(
                            onTap: c.pause,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.splashGrad2,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.pause,
                                color: Colors.black,
                                size: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () => c.seek(Duration.zero),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.splashGrad2,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.shuffle,
                                color: Colors.black,
                                size: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    IconButton(
                      onPressed: c.next,
                      icon: FaIcon(
                        FontAwesomeIcons.stepForward,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.volume_up,
                        size: MediaQuery.of(context).size.width * 0.1,
                      ),
                      onPressed: () {
                        showSliderDialog(
                          context: context,
                          title: "Adjust volume",
                          divisions: 10,
                          min: 0.0,
                          max: 1.0,
                          value: c.player.volume,
                          stream: c.player.volumeStream,
                          onChanged: c.player.setVolume,
                        );
                      },
                    ),

                    // Speed dialog
                    StreamBuilder<double>(
                      stream: c.player.speedStream,
                      builder: (context, snapshot) => IconButton(
                        icon: Text(
                          "${snapshot.data?.toStringAsFixed(1)}x",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          showSliderDialog(
                            context: context,
                            title: "Adjust speed",
                            divisions: 10,
                            min: 0.5,
                            max: 1.5,
                            value: c.player.speed,
                            stream: c.player.speedStream,
                            onChanged: c.player.setSpeed,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // Upcoming list
              Obx(() {
                final idx = c.currentIndex.value;
                if (idx >= 113 || c.surahList == null) return Container();
                return Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 0.01,
                          offset: Offset(0.0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UPCOMING SURAH',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          if (idx <= 112)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.play_circle_fill,
                                  color: AppColors.splashGrad2,
                                ),
                                Text(
                                  c.surahList![idx + 1].name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 12),
                          if (idx <= 111)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.play_circle_fill,
                                  color: AppColors.splashGrad2,
                                ),
                                Text(
                                  c.surahList![idx + 2].name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
