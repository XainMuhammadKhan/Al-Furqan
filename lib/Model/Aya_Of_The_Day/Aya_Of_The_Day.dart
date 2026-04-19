class AyaOfTheDay {
  final String? arabicText;
  final String? englishTranslation;
  final String? surahName;
  final int? surahNumber;
  final int? ayaNumber;

  AyaOfTheDay({
    this.arabicText,
    this.englishTranslation,
    this.surahName,
    this.surahNumber,
    this.ayaNumber,
  });

  factory AyaOfTheDay.fromJson(Map<String, dynamic> json) {
    // using the fixed ordering your brother relied on:
    // data[0] = Arabic edition, data[2] = chosen English translation
    return AyaOfTheDay(
      arabicText: json['data'][0]['text'],
      englishTranslation: json['data'].length > 2
          ? json['data'][2]['text']
          : json['data'][1]['text'],
      surahName: json['data'][0]['surah']['englishName'],
      surahNumber: json['data'][0]['surah']['number'],
      // ayaNumber here is the verse index inside the surah (numberInSurah)
      ayaNumber: json['data'][0]['numberInSurah'],
    );
  }
}
