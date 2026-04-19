class JuzModel {
  final int juzNumber;
  final String name;
  final List<JuzAyahs> juzAyahs;

  // Convenience fields for UI (derived)
  final String displayArabicTitle;
  final String displayEnglishSubtitle;

  JuzModel({
    required this.juzNumber,
    required this.name,
    required this.juzAyahs,
    required this.displayArabicTitle,
    required this.displayEnglishSubtitle,
  });

  factory JuzModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    Iterable juzAyahsRaw = data['ayahs'] ?? [];
    List<JuzAyahs> juzAyahsList = juzAyahsRaw
        .map((ayah) => JuzAyahs.fromJson(ayah))
        .toList();

    // API may return 'juz_number' or 'number'
    final rawJuzNumber = data['juz_number'] ?? data['number'];
    int parsedJuzNumber = 1;
    if (rawJuzNumber is int) {
      parsedJuzNumber = rawJuzNumber;
    } else {
      parsedJuzNumber = int.tryParse(rawJuzNumber?.toString() ?? '') ?? 1;
    }

    final name = (data['name'] ?? '').toString();

    // Build display titles from first ayah if available
    String arabicSnippet = '';
    String englishSubtitle = 'Juz $parsedJuzNumber';
    if (juzAyahsList.isNotEmpty) {
      final first = juzAyahsList.first;

      // Arabic snippet: first few words of the ayah (strip Bismillah if present)
      arabicSnippet = _buildArabicSnippet(first.ayahsText);

      // English subtitle: transliterate Arabic snippet if possible, otherwise use surah english name
      if (arabicSnippet.isNotEmpty) {
        englishSubtitle = _simpleTransliterate(arabicSnippet);
      } else if (first.surahEnglishName.isNotEmpty) {
        englishSubtitle = first.surahEnglishName;
      }
    }

    if (arabicSnippet.isEmpty) {
      arabicSnippet = 'الجزء $parsedJuzNumber';
    }

    return JuzModel(
      juzNumber: parsedJuzNumber,
      name: name,
      juzAyahs: juzAyahsList,
      displayArabicTitle: arabicSnippet,
      displayEnglishSubtitle: englishSubtitle,
    );
  }

  static String _buildArabicSnippet(String text) {
    if (text.trim().isEmpty) return '';
    String t = text.trim();

    // Remove common Bismillah prefix if present
    if (t.startsWith('بِسْمِ')) {
      final idx = t.indexOf('ٱللَّه');
      if (idx != -1) {
        final after = t.indexOf(' ', idx);
        if (after != -1 && after + 1 < t.length) {
          t = t.substring(after + 1).trim();
        } else if (idx + 'ٱللَّهِ'.length < t.length) {
          t = t.substring(idx + 'ٱللَّهِ'.length).trim();
        }
      }
    }

    final words = t.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    return words.take(3).join(' ');
  }

  // Very small transliteration fallback for short snippets (not perfect but usable)
  static String _simpleTransliterate(String arabic) {
    final map = {
      'ا': 'a',
      'أ': 'a',
      'إ': 'i',
      'آ': 'a',
      'ب': 'b',
      'ت': 't',
      'ث': 'th',
      'ج': 'j',
      'ح': 'h',
      'خ': 'kh',
      'د': 'd',
      'ذ': 'dh',
      'ر': 'r',
      'ز': 'z',
      'س': 's',
      'ش': 'sh',
      'ص': 's',
      'ض': 'd',
      'ط': 't',
      'ظ': 'z',
      'ع': "'",
      'غ': 'gh',
      'ف': 'f',
      'ق': 'q',
      'ك': 'k',
      'ل': 'l',
      'م': 'm',
      'ن': 'n',
      'ه': 'h',
      'و': 'w',
      'ي': 'y',
      'ى': 'a',
      'ئ': 'y',
      'ء': "'",
    };
    final buffer = StringBuffer();
    for (var rune in arabic.runes) {
      final ch = String.fromCharCode(rune);
      buffer.write(map[ch] ?? (RegExp(r'\s').hasMatch(ch) ? ' ' : ch));
    }
    final s = buffer.toString();
    // collapse multiple spaces
    return s.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

class JuzAyahs {
  final String ayahsText;
  final int ayahNumber;

  // Surah info
  final String surahName;
  final String surahEnglishName;
  final String surahEnglishNameTranslation;
  final int surahNumber;

  JuzAyahs({
    required this.ayahsText,
    required this.ayahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.surahEnglishNameTranslation,
    required this.surahNumber,
  });

  factory JuzAyahs.fromJson(Map<String, dynamic> json) {
    final rawText = json['text'] ?? '';
    final rawNumber = json['number'] ?? json['ayah_number'];
    final rawSurah = json['surah'];

    final ayahNumber = rawNumber is int
        ? rawNumber
        : int.tryParse(rawNumber?.toString() ?? '') ?? 0;
    final ayahsText = rawText?.toString() ?? '';

    String surahName = '';
    String surahEnglishName = '';
    String surahEnglishNameTranslation = '';
    int surahNumber = 0;

    if (rawSurah != null && rawSurah is Map) {
      surahName = (rawSurah['name'] ?? '').toString();
      surahEnglishName = (rawSurah['englishName'] ?? '').toString();
      surahEnglishNameTranslation = (rawSurah['englishNameTranslation'] ?? '')
          .toString();
      final rawSurahNum = rawSurah['number'] ?? rawSurah['surah_number'];
      surahNumber = rawSurahNum is int
          ? rawSurahNum
          : int.tryParse(rawSurahNum?.toString() ?? '') ?? 0;
    } else {
      surahName = (json['surahName'] ?? '').toString();
      surahEnglishName = (json['surahEnglishName'] ?? '').toString();
      surahEnglishNameTranslation = (json['surahEnglishNameTranslation'] ?? '')
          .toString();
      final rawSurahNum = json['surahNumber'] ?? json['surah_number'];
      surahNumber = rawSurahNum is int
          ? rawSurahNum
          : int.tryParse(rawSurahNum?.toString() ?? '') ?? 0;
    }

    return JuzAyahs(
      ayahsText: ayahsText,
      ayahNumber: ayahNumber,
      surahName: surahName,
      surahEnglishName: surahEnglishName,
      surahEnglishNameTranslation: surahEnglishNameTranslation,
      surahNumber: surahNumber,
    );
  }
}
