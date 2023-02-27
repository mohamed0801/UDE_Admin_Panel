// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/Theme.dart';
import 'BlocState.dart';

class ThemeBloc extends Cubit<ThemeState> {
  ThemeBloc() : super(ThemeState(theme: AppTheme.Light)) {
    loadTheme();
  }
  void loadTheme() async {
    String str = await SharedPreferences.getInstance()
        .then((value) => value.getString('theme') ?? '');
    if (str == 'dark') {
      emit(ThemeState(theme: AppTheme.Dark));
    }
  }

  void setTheme(AppTheme theme) async {
    emit(ThemeState(theme: theme));
    await SharedPreferences.getInstance().then((value) =>
        value.setString('theme', theme == AppTheme.Dark ? 'dark ' : 'light'));
  }
}
