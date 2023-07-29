import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furkan/bloc/cubit/app_cubit.dart';
import 'package:furkan/models/surah_model.dart';
import 'package:furkan/pages/sura_details_screen.dart';
import 'package:furkan/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("ফুরকান", style: TextStyle(color: Colors.white, fontFamily: GoogleFonts.galada().fontFamily, fontSize: 25),),
        centerTitle: true,
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state){
          List<Surah> surahs = state.surahs!;
          return  ListView.separated(
            itemCount: surahs.length,
            itemBuilder: (BuildContext context, int index) {
              Surah surah = surahs[index];
              return ListTile(
                dense: true,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SurahDetailsScreen(surah_no: surah.no)));
                },
                leading: CircleAvatar(
                    radius: 16,
                    backgroundImage :AssetImage("assets/images/sura_background.png"),
                    backgroundColor: Colors.transparent,
                    child: Text(Utils.toBNNumber(surah.no), style:  TextStyle( fontSize: 11, fontWeight: FontWeight.bold,fontFamily: GoogleFonts.tiroBangla().fontFamily),)
                ),
                title: Text(
                  surah.nameBn,
                  style:  TextStyle(
                      color: Colors.black,
                      fontSize: 20 ,
                      fontFamily: GoogleFonts.notoSerifBengali().fontFamily
                  ),
                ),
                subtitle:Text("${surah.totalAyats} আয়াত", style: const TextStyle(fontSize: 11)),
                trailing: Text(surah.nameAr,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 24,
                      fontFamily:GoogleFonts.amiriQuran().fontFamily,// "Al-Qalam Quran",
                      fontWeight: FontWeight.w100
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, index){
              return Container(
                margin: const EdgeInsets.only(left: 80, right: 15),
                height: 1,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.3),
              );
            },
          );
        },
      )
    );
  }

}