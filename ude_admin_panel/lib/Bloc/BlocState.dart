// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

import '../Model/User.dart';
import '../module/Theme.dart';

@immutable
abstract class BlocState {}

class Initial extends BlocState {}

class Loading extends BlocState {}

class ThemeState extends BlocState {
  final AppTheme theme;
  ThemeState({required this.theme});
}

class Failed extends BlocState {
  final Exception exception;
  Failed(this.exception);
}

class Authenticated extends BlocState {
  final User user;
  Authenticated(this.user);
}

class LoadData<t> extends BlocState {
  final List<dynamic> rows;
  LoadData(this.rows);
}
