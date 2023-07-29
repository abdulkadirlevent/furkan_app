import 'ayat_model.dart';
import 'package:html_unescape/html_unescape.dart';
class Surah {
  final String nameBn;
  final String nameEn;
  final String nameAr;
  final String meaning;
  final String no;
  final String totalAyats;
  final String totalRuku;
  final List<SurahVideo> videos;
  final List<Ayat> ayats;

  Surah(this.nameBn, this.nameEn, this.nameAr, this.meaning, this.no, this.totalAyats, this.totalRuku, this.videos, this.ayats);

  Surah.fromJson(Map<String, dynamic> json)
      : nameBn = HtmlUnescape().convert(json['name_bn']),
        nameEn = json['name_en'],
        nameAr = json['name_ar'],
        meaning = json['meaning'],
        no = json['no'],
        totalAyats = json['total_ayats'],
        totalRuku = json['total_ruku'],
        videos = List<SurahVideo>.from(json['videos'].map((dynamic video) => SurahVideo.fromJson(Map<String, dynamic>.from(video)))),
        ayats = List<Ayat>.from(json['ayats'].map((dynamic ayat) => Ayat.fromJson(Map<String, dynamic>.from(ayat))));

  Map<String, dynamic> toJson() => {
    'name_bn':nameBn,
    'name_en':nameEn,
    'name_ar':nameAr,
    'meaning':meaning,
    'no':no,
    'total_ayats':totalAyats,
    'total_ruku':totalRuku,
    'videos':videos,
    "ayats": ayats
  };
}

class SurahVideo{
  final String title;
  final String url;
  final String type;
  final String yt_video_id;

  SurahVideo(this.title, this.url, this.type, this.yt_video_id);
  SurahVideo.fromJson(Map<String, dynamic> json)
      :
        title = json['title'],
        url = json['url'],
        type = json['type'],
        yt_video_id = json['yt_video_id']?? "";

  Map<String, dynamic> toJson() => {
    'title':title,
    'url':url,
    'type':type,
    'yt_video_id':yt_video_id,
  };
}