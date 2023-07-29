import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furkan/bloc/cubit/app_cubit.dart';
import 'package:furkan/models/ayat_model.dart';
import 'package:furkan/models/surah_model.dart';
import 'package:furkan/utils/utils.dart';
import 'package:furkan/widgets/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
class SurahDetailsScreen extends StatefulWidget {
  const SurahDetailsScreen({Key? key, required this.surah_no}) : super(key: key);
  final String surah_no;
  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  String _surahNo = "";
  List<Surah> _surahs = [];
  late Surah  _surah;
  final YoutubePlayerController _videoController = YoutubePlayerController(
    params: const YoutubePlayerParams(
      mute: false,
      showControls: false,
    ),
  );
  bool _isVideoVisible = true;
  @override
  void initState() {
    super.initState();
    AppCubit cubit = context.read<AppCubit>();
    setState((){
      _surahs = cubit.state.surahs!;
      changeSurah(widget.surah_no);
    });
  }

  void changeSurah(String surahNo){
    setState(() {
      _surahNo = surahNo;
      _surah = _surahs.firstWhere((element) => element.no == _surahNo);
      if(_surah.videos.isNotEmpty) {
        if (_isVideoVisible) {
          _videoController.loadVideoById(videoId: _surah.videos[0].yt_video_id).then((value) => _videoController.playVideo());
          _videoController.playVideo();
        } else {
          _videoController.loadVideoById(videoId: _surah.videos[0].yt_video_id).then((value) => _videoController.pauseVideo());
        }
      } else {
        _videoController.pauseVideo();
      }

    });
  }
  nextSurah(){
    int next = int.parse(_surahNo) + 1;
    if(next <= _surahs.length) {
      changeSurah(next.toString());
    }
  }
  prevSurah(){
    int prev = int.parse(_surahNo) -1;
    if(prev >= 1) {
      changeSurah(prev.toString());
    }
  }

  toggleVideo(){
    setState(() {
      if(_isVideoVisible){
        _isVideoVisible = false;
      } else {
        _isVideoVisible = true;
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: DropdownButtonHideUnderline(
            child: DropdownButton(
                iconEnabledColor: Colors.white,
                iconDisabledColor: Colors.grey,
                value: _surahNo,
                onChanged: (value) {
                  changeSurah(value.toString());
                },
                selectedItemBuilder: (BuildContext context) {
                  return _surahs.map((Surah value) {
                    return DropdownMenuItem<String>(
                      value: _surah.no,
                      child: SizedBox(
                          child: Text(
                            "${Utils.toBNNumber(_surah.no)}. ${_surah.nameBn}",
                            style:  TextStyle(
                                color: Colors.white,
                                fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 18
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                    );
                  }).toList();
                },
                items: _surahs.map((Surah surah) {
                  return DropdownMenuItem<String>(
                    value: surah.no,
                    child: SizedBox(
                        child: Text(
                          "${Utils.toBNNumber(surah.no)}. ${surah.nameBn}",
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                              fontFamily: GoogleFonts.notoSerifBengali().fontFamily
                          ),
                        )
                    ),
                  );

                }).toList()
            )
        ),
        actions: [
          IconButton(onPressed: prevSurah, icon: const Icon(Icons.chevron_left)),
          IconButton(onPressed: nextSurah, icon: const Icon(Icons.chevron_right)),
        ],
        elevation: 0,
        // centerTitle: true,
      ),
      body: _surah != null?Column(
          children: [
            AnimatedContainer (
              clipBehavior: Clip.hardEdge,
              duration: const Duration (milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              height: _isVideoVisible? ((MediaQuery.of(context).size.width / 16)*9) + 50 : 0,
              width: double.infinity,
              color: Colors.red,
              child: VideoPlayer(controller: _videoController, videos: _surah.videos),
              onEnd: (){
                if(_isVideoVisible){
                  _videoController.playVideo();
                } else{
                  _videoController.pauseVideo();
                }

              },
            ),
            Expanded(
                child: Stack(
                  children: [
                    ListView.separated(
                      itemCount: _surah.ayats.length,
                      itemBuilder: (BuildContext context, int index) {
                        Ayat ayat = _surah.ayats[index];
                        return Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.00,
                                      horizontal: 15.00
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          index == 0 ? Padding(
                                              padding: EdgeInsets.only(bottom: 5),
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage :const AssetImage("assets/images/sura_background.png"),
                                                backgroundColor: Colors.transparent,
                                                child: Text(Utils.toBNNumber(_surahNo), style: const TextStyle( fontWeight: FontWeight.w600, fontSize: 12),)
                                            ),
                                          ) : SizedBox(),
                                          CircleAvatar(
                                              radius: 15,
                                              backgroundImage :const AssetImage("assets/images/ayat_background.png"),
                                              backgroundColor: Colors.transparent,
                                              child: Text(Utils.toBNNumber(ayat.ayatNo), style: const TextStyle( fontWeight: FontWeight.w600, fontSize: 12),)
                                          )
                                        ],
                                      )
                                      ,
                                      const SizedBox(width: 15,),
                                      Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  width: double.infinity,
                                                  child:Text(ayat.textAr,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontSize: 24,
                                                        fontFamily: GoogleFonts.amiriQuran().fontFamily//"Al-Qalam Quran"
                                                    ),
                                                  )
                                              ),
                                              const SizedBox(height: 20,),
                                              SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    ayat.textBn,
                                                    style:  TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontFamily: GoogleFonts.notoSerifBengali().fontFamily
                                                    ),
                                                  )
                                              ),

                                            ],
                                          )
                                      )
                                    ],
                                  )
                              ),
                            ]
                        );
                      },
                      separatorBuilder: (BuildContext context, index){
                        return Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.3),
                        );
                      },
                    ),
                    Positioned(
                        left: (MediaQuery.of(context).size.width/2) - 25,
                        top: 0,
                        child: Container(
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)
                            ),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.withOpacity(0.2)
                            )
                          ),
                          child: InkWell(
                          onTap: toggleVideo,
                          child:  Icon(_isVideoVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                        )
                        )
                    )
                  ],
                )
            )
          ]
      ):const Text("Nothing to show"),
    );
  }
}

