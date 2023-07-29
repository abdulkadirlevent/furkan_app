class Ayat {
  final String textBn;
  final String textEn;
  final String textAr;
  final String ayatNo;
  final String surahNo;

  Ayat(this.textBn, this.textEn, this.textAr, this.ayatNo, this.surahNo);

  Ayat.fromJson(Map<String, dynamic> json)
      : textBn = json['text_bn'],
        textEn = json['text_en'],
        textAr = json['text_ar'],
        ayatNo = json['ayat_no'],
        surahNo = json['surah_no'];

  Map<String, dynamic> toJson() => {
    'text_bn':textBn,
    'text_en':textEn,
    'text_ar':textAr,
    'ayat_no':ayatNo,
    'surah_no':surahNo,
  };
}