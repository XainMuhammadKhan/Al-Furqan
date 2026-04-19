class JuzNames {
  static const List<String> english = [
    'Alif Lam Meem',
    'Sayaqool',
    'Tilkal Rusul',
    'Lan Tana Loo',
    'Wal Mohsanat',
    'La Yuhibbullah',
    'Wa Iza Samiu',
    'Wa Lau Annana',
    'Qalal Malao',
    'Wa A\'lamu',
    'Yatazeroon',
    'Wa Mamin Da\'abat',
    'Wa Ma Ubrioo',
    'Rubama',
    'Subhanallazi',
    'Qal Alam',
    'Aqtarabo',
    'Qadd Aflaha',
    'Wa Qalallazina',
    'A\'man Khalaq',
    'Utlu Ma Oohi',
    'Wa Manyaqnut',
    'Wa Mali',
    'Faman Azlam',
    'Elahe Yuruddo',
    'Ha\'a Meem',
    'Qala Fama Khatbukum',
    'Qadd Sami Allah',
    'Tabarakallazi',
    'Amma Yatasa\'aloon',
  ];

  static const List<String> arabic = [
    'آلم',
    'سَيَقُولُ',
    'تِلْكَ الرُّسُلُ',
    'لَنْ تَنَالُوا',
    'وَالْمُحْصَنَاتُ',
    'لَا يُحِبُّ اللَّهُ',
    'وَإِذَا سَمِعُوا',
    'وَلَوْ أَنَّنَا',
    'قَالَ الْمَلَأُ',
    'وَاعْلَمُوا',
    'يَعْتَذِرُونَ',
    'وَمَا مِنْ دَابَّةٍ',
    'وَمَا أُبَرِّئُ',
    'رُبَمَا',
    'سُبْحَانَ الَّذِي',
    'قَالَ أَلَمْ',
    'اقْتَرَبَ لِلنَّاسِ',
    'قَدْ أَفْلَحَ',
    'وَقَالَ الَّذِينَ',
    'أَمَّنْ خَلَقَ',
    'اتْلُ مَا أُوحِيَ',
    'وَمَنْ يَقْنُتْ',
    'وَمَا لِيَ',
    'فَمَنْ أَظْلَمُ',
    'إِلَيْهِ يُرَدُّ',
    'حم',
    'قَالَ فَمَا خَطْبُكُمْ',
    'قَدْ سَمِعَ اللَّهُ',
    'تَبَارَكَ الَّذِي',
    'عَمَّ يَتَسَاءَلُونَ',
  ];

  static String getEnglish(int juzNumber) {
    if (juzNumber < 1 || juzNumber > english.length) return 'Juz $juzNumber';
    return english[juzNumber - 1];
  }

  static String getArabic(int juzNumber) {
    if (juzNumber < 1 || juzNumber > arabic.length) return 'الجزء $juzNumber';
    return arabic[juzNumber - 1];
  }
}
