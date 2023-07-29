import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furkan/bloc/cubit/app_cubit.dart';
import 'package:furkan/pages/splash_screen.dart';
import 'package:furkan/pages/surah_list_screen.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state){
      if(state.isInitialized){
        return const SurahListScreen();
      } else {
        return const SplashScreen();
      }
    });
  }

}