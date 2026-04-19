import 'package:alfurqan/Model/Qari/qari.dart';
import 'package:alfurqan/Model/Surah/Surah.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class AudioController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  final RxBool isLooping = false.obs;
  final RxInt currentIndex = 0.obs;
  Duration defaultDuration = Duration(milliseconds: 1);

  List<Surah>? surahList;
  Qari? currentQari;

  Stream<PositionData> get positionDataStream =>
      CombineLatestStream.combine3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  Future<void> initPlayer({
    required Qari qari,
    required int index,
    List<Surah>? list,
  }) async {
    currentQari = qari;
    surahList = list;
    currentIndex.value = index - 1;

    String ind = _formatIndex(index);
    await _initAudioPlayer(ind, qari);
  }

  String _formatIndex(int idx) {
    if (idx < 10) return '00' + idx.toString();
    if (idx < 100) return '0' + idx.toString();
    return idx.toString();
  }

  Future<void> _initAudioPlayer(String ind, Qari qari) async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Stop current playback before loading a new source
    try {
      await player.stop();
    } catch (_) {}

    // reset default duration while new source is loading
    defaultDuration = Duration.zero;

    try {
      var url = "https://download.quranicaudio.com/quran/${qari.path}$ind.mp3";
      // Load new source and start playback
      final dur = await player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      defaultDuration = dur ?? Duration.zero;
      await player.seek(Duration.zero);
      await player.play();
    } catch (e) {
      print("Error loading audio source: $e");
      defaultDuration = Duration.zero;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // single listener for playback errors
    player.playbackEventStream.listen((_) {}, onError: (e, st) {
      print('A stream error occurred: $e');
    });
  }

  Future<void> play() => player.play();
  Future<void> pause() => player.pause();
  Future<void> seek(Duration d) => player.seek(d);

  void toggleLooping() async {
    if (isLooping.value)
      await player.setLoopMode(LoopMode.one);
    else
      await player.setLoopMode(LoopMode.off);
    isLooping.value = !isLooping.value;
  }

  Future<void> previous() async {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      int dataIndex = currentIndex.value + 1;
      String ind = _formatIndex(dataIndex);
      if (currentQari != null) await _initAudioPlayer(ind, currentQari!);
    }
  }

  Future<void> next() async {
    if (currentIndex.value >= 0 && currentIndex.value < 113) {
      currentIndex.value++;
      int dataIndex = currentIndex.value + 1;
      String ind = _formatIndex(dataIndex);
      if (currentQari != null) await _initAudioPlayer(ind, currentQari!);
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
