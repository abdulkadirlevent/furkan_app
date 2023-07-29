import 'package:flutter/material.dart';
import 'package:furkan/models/surah_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayer extends StatefulWidget{
  const VideoPlayer({super.key, required this.controller, required this.videos});
  final YoutubePlayerController controller;
  final List<SurahVideo> videos;

  @override
  State<StatefulWidget> createState()=>  _VideoPlayer();


}

class _VideoPlayer extends State<VideoPlayer>{
  SurahVideo? _value;
  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  void didUpdateWidget(covariant VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.videos != widget.videos){
      init();
    }
  }

  void init(){
    setState(() {
      if(widget.videos.isNotEmpty){
        _value = widget.videos[0];
      } else {
        _value = null;
      }
    });
  }

  void onChange(SurahVideo video){
    setState(() {
      _value = video;
      widget.controller.loadVideoById(videoId: video.yt_video_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YoutubePlayer(
          controller: widget.controller,
          aspectRatio: 16 / 9,
        ),
        Container(
            width: double.infinity,
            height: 50,

            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child:DropdownButtonHideUnderline(
                child:  DropdownButton<SurahVideo>(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  value: _value,
                  selectedItemBuilder: (BuildContext context){
                    return widget.videos.map((SurahVideo video) {
                      return DropdownMenuItem<SurahVideo>(
                        value: video,
                        child: SizedBox(width: 300,child:Text(video.title, overflow: TextOverflow.ellipsis,)),
                      );
                    }).toList();
                  },
                  items: widget.videos.map((SurahVideo video) {
                    return DropdownMenuItem<SurahVideo>(
                      value: video,
                      child: SizedBox(width: double.infinity,child:Text(video.title, overflow: TextOverflow.ellipsis,)),
                    );
                  }).toList(),
                  onChanged: (_) {
                    if(_ !=null) {
                      onChange(_);
                    }
                  },
                )
            )
        ),
      ],
    );
  }

}