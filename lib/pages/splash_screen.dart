import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furkan/bloc/cubit/app_cubit.dart';
import 'package:furkan/models/surah_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _total = 0;
  int _received = 0;
  double? _percentage = 0;
  final http.Client _client = http.Client();


  Future<bool> _checkForUpdate() async{
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      String filePath = "$dir/resources.json";
      FileStat fileStat = File(filePath).statSync();
      int ts = (fileStat.changed.millisecondsSinceEpoch).toInt();
      var res = await _client.get(Uri.parse("https://webtrackers.co.in/furkan/api/index.php?check_for_update=OK&ts=$ts"));
      return res.body == "UPDATE_AVAILABLE";
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _getFile() async{
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/resources.json";
    bool fileExists = File(filePath).existsSync();
    setState((){
      setState(() {
        _percentage = null;
      });
    });
    if(fileExists && ! await _checkForUpdate()){
      Timer(const Duration(seconds: 2),(){
        _updateAppState();
      });

    } else {
      try {
        var d = File(filePath);
        await d.delete();
      } catch(e){
        debugPrint("Error while deleting file");
      }

      http.Request request = http.Request("GET", Uri.parse("https://webtrackers.co.in/furkan/api/json.php"));
      http.StreamedResponse response = await _client.send(request);
      setState((){
        _total = response.contentLength??0;
        _received = 0;
        _percentage= 0;
      });

      final List<int> bytes = [];
      response.stream.listen((value) {
        setState(() {
          bytes.addAll(value);
          _received += value.length;
          _percentage = (_received/_total);
        });
      }).onDone(() async {
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        _updateAppState();
      });
    }
  }
  Future<void> _updateAppState() async {
    AppCubit cubit  = context.read<AppCubit>();
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/resources.json";
    final file = File(filePath);
    Map<String, dynamic> data = jsonDecode(await file.readAsStringSync());
    List<Surah> surahs = List<Surah>.from(data["surahs"].map((dynamic json){
      Map<String, dynamic> surah = Map<String, dynamic>.from(json);
      surah["ayats"] = data["ayats"][surah["no"]];
      return Surah.fromJson(surah);
    }));

    cubit.setSurahs(surahs);
  }


  @override
  void initState() {
    _getFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
              child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Column(
                    children: [
                       Text("ফুরকান", style: TextStyle(color: Colors.white, fontFamily: GoogleFonts.galada().fontFamily, fontSize: 25),),
                      Container(
                          width: 90,
                          margin: const EdgeInsets.only(top:20),
                          child:  LinearProgressIndicator(color: Colors.white,  value: _percentage, backgroundColor: Colors.transparent,)
                      ),
                    ],
                  )
              )
          ),
        )
    );
  }

}