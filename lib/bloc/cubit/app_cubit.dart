import 'package:bloc/bloc.dart';
import 'package:furkan/models/surah_model.dart';

class AppState{
  List<Surah>? surahs;
  bool isInitialized = false;
}
class AppCubit extends Cubit<AppState>{
  AppCubit() : super(AppState());
  void setSurahs(List<Surah> surahs) async {
    state.surahs = surahs;
    state.isInitialized = true;
    emit(state);
  }
}