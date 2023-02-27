// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ude_admin_panel/Bloc/BlocState.dart';
import 'package:ude_admin_panel/Bloc/ThemeBloc.dart';
import 'package:ude_admin_panel/Bloc/UserBlocState.dart';
import 'package:ude_admin_panel/module/Theme.dart';
import 'package:ude_admin_panel/module/widgets.dart';
import 'package:ude_admin_panel/screens/Dashboard/Dashboard.dart';
import 'package:ude_admin_panel/screens/Login.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
    ),
    BlocProvider<UserBloc>(
      create: (_) => UserBloc(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyAFwSHlYaxB0A-sR9AfqZD3Fc7ud7MAP2I",
    projectId: "ude-project-138be",
    messagingSenderId: "969766420243",
    appId: "1:969766420243:web:37987b34c07e44b9da64e6",
  ));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, BlocState>(
      builder: (_, state) => MaterialApp(
        title: 'UDE Admin Panel',
        theme: appThemeData[state is ThemeState ? state.theme : AppTheme.Light],
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<UserBloc, BlocState>(
          builder: ((context, state) {
            if (state is Authenticated) {
              return FutureBuilder(
                future: _initialization,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Dashboard();
                  }
                  return const MWaiting();
                }),
              );
            }
            return FutureBuilder(
              future: _initialization,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Login(
                    state: state,
                  );
                }
                return const MWaiting();
              }),
            );
          }),
        ),
      ),
    );
  }
}
