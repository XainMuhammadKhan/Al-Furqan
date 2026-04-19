class SajdahList {
  final List<SajdahAyat> sajdahAyahs;

  SajdahList({required this.sajdahAyahs});

  factory SajdahList.fromJSON(Map<String, dynamic> json) {
    Iterable allSajdas = json['data']['ayahs'];
    List<SajdahAyat> sajdahs = allSajdas
        .map((s) => SajdahAyat.fromJSON(s))
        .toList();
    return SajdahList(sajdahAyahs: sajdahs);
  }
}

class SajdahAyat {
  final int number;
  final String text;
  final String surahName;
  final String surahEnglishName;
  final String englishNameTranslation;
  final String revelationType;
  final int juzNumber;
  final int manzilNumber;
  final int rukuNumber;
  final int sajdaNumber;

  SajdahAyat({
    required this.number,
    required this.text,
    required this.surahName,
    required this.surahEnglishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.juzNumber,
    required this.manzilNumber,
    required this.rukuNumber,
    required this.sajdaNumber,
  });

  factory SajdahAyat.fromJSON(Map<String, dynamic> json) {
    return SajdahAyat(
      number: json['number'],
      text: json['text'],
      surahName: json['surah']['name'],
      surahEnglishName: json['surah']['englishName'],
      englishNameTranslation: json['surah']['englishNameTranslation'],
      revelationType: json['surah']['revelationType'],
      juzNumber: json['juz'],
      manzilNumber: json['manzil'],
      rukuNumber: json['ruku'],
      sajdaNumber: json['sajda']['id'],
    );
  }
}
