// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ude_admin_panel/Model/Enseignant.dart';
import 'package:ude_admin_panel/Model/Student.dart';
import 'package:ude_admin_panel/Repository/StudentRepo.dart';
import 'package:ude_admin_panel/module/estension.dart';

import '../Model/User.dart';
import '../Repository/ClasseRepo.dart';
import '../Repository/UserRepo.dart';
import 'BlocState.dart';

class UserBloc extends Cubit<BlocState> {
  UserBloc() : super(Initial()) {
    SharedPreferences.getInstance().then((value) {
      String token = value.getString('token') ?? '';
      if (token.isNotEmpty) {
        veryfyByToken(token);
      }
    });
  }

  User? _user;
  final BehaviorSubject<BlocState> _userlist = BehaviorSubject<BlocState>();
  Stream<BlocState> get userListStream => _userlist.stream;
  final BehaviorSubject<BlocState> _classelist = BehaviorSubject<BlocState>();
  Stream<BlocState> get classeListStream => _classelist.stream;
  final BehaviorSubject<BlocState> _userclasselist =
      BehaviorSubject<BlocState>();
  Stream<BlocState> get userClasseListStream => _userclasselist.stream;
  final BehaviorSubject<BlocState> _sceancelist = BehaviorSubject<BlocState>();
  Stream<BlocState> get sceanceListStream => _sceancelist.stream;
  final BehaviorSubject<BlocState> _studentlist = BehaviorSubject<BlocState>();
  Stream<BlocState> get studentListStream => _studentlist.stream;
  final BehaviorSubject<BlocState> _studentabscencelist =
      BehaviorSubject<BlocState>();
  Stream<BlocState> get studentAbscenceListStream =>
      _studentabscencelist.stream;

  Future<void> authenticate(
      String lycee, String matricule, bool remember) async {
    if (state is Loading) return;
    try {
      emit(Loading());
      _user = await UserRepo.authenticate(lycee, matricule);
      if (remember) {
        await SharedPreferences.getInstance()
            .then((value) => value.setString('token', _user!.token!));
      }
      emit(Authenticated(_user!));
    } catch (e) {
      emit(Failed(e as Exception));
    }
  }

  void veryfyByToken(String token) async {
    if (state is Loading) return;
    try {
      emit(Loading());
      _user = await UserRepo.authenticateByToken(token);
      emit(Authenticated(_user!));
    } catch (e) {
      emit(Initial());
    }
  }

  void signOut() async {
    await SharedPreferences.getInstance()
        .then((value) => value.remove('token'));
    emit(Initial());
  }

  Future<void> loadTeacherList(String lycee) async {
    try {
      _userlist.add(Loading());
      _userlist.add(LoadData(await UserRepo.getTeacherList(lycee)));
    } catch (e) {
      _userlist.add(Failed(Exception('$e')));
    }
  }

  Future<void> loadClasseList(String lycee) async {
    try {
      _classelist.add(Loading());
      _classelist.add(LoadData(await ClasseRepo.loadClasse(lycee)));
    } catch (e) {
      _classelist.add(Failed(Exception('$e')));
    }
  }

  Future<void> loadClasseStudentList(String lycee, String classe) async {
    if (_classelist.value is LoadData) {
      try {
        /*(_classelist.value as LoadData).rows.forEach((e) {
          (e as ClasseM).showdetail = e.name == classe;
        });
        _classelist.add(_classelist.value);*/
        _studentlist.add(Loading());
        _studentlist.add(LoadData(await ClasseRepo.loadStudent(lycee, classe)));
      } catch (e) {
        _studentlist.add(Failed(Exception('$e')));
      }
    }
  }

  Future<void> loadStudentAbscenceList(
      String lycee, String classe, String student) async {
    if (_studentlist.value is LoadData) {
      try {
        /*(_classelist.value as LoadData).rows.forEach((e) {
          (e as ClasseM).showdetail = e.name == classe;
        });
        _classelist.add(_classelist.value);*/
        _studentabscencelist.add(Loading());
        _studentabscencelist.add(LoadData(
            await ClasseRepo.loadStudentAbscence(lycee, classe, student)));
      } catch (e) {
        _studentabscencelist.add(Failed(Exception('$e')));
      }
    }
  }

  Future<void> loadTeacherClasseList(String lycee, String teacher) async {
    if (_userlist.value is LoadData) {
      try {
        /*(_classelist.value as LoadData).rows.forEach((e) {
          (e as ClasseM).showdetail = e.name == classe;
        });
        _classelist.add(_classelist.value);*/
        _userclasselist.add(Loading());
        _userclasselist
            .add(LoadData(await ClasseRepo.loadTeacherClasse(lycee, teacher)));
      } catch (e) {
        _userclasselist.add(Failed(Exception('$e')));

        rethrow;
      }
    }
  }

  Future<void> loadTeacherSceanceList(String lycee, String teacher) async {
    if (_userlist.value is LoadData) {
      try {
        /*(_classelist.value as LoadData).rows.forEach((e) {
          (e as ClasseM).showdetail = e.name == classe;
        });
        _classelist.add(_classelist.value);*/
        _sceancelist.add(Loading());
        _sceancelist.add(LoadData(await UserRepo.loadSceance(lycee, teacher)));
      } catch (e) {
        _sceancelist.add(Failed(Exception('$e')));
      }
    }
  }

  Future<bool> addStudentToClasse(BuildContext context, String classe,
      String student, String firstname, String lastname, String sexe) async {
    try {
      StudentM? newst = await StudentRepo.addStudent(
          context.user!.id!.substring(0, 4),
          classe,
          student,
          firstname,
          lastname,
          sexe);
      if (_studentlist.value is LoadData) {
        if ((_studentlist.value as LoadData)
            .rows
            .where((element) => element.id == newst!.id)
            .isNotEmpty) {
          (_studentlist.value as LoadData).rows.insert(0, newst);
          _studentlist.add(_studentlist.value);
        }
      }
      if (_classelist.value is LoadData) {
        _classelist.add(_classelist.value);
      }
      return true;
    } catch (e) {
      context.snackBar(e.toString());
      return false;
    }
  }

  Future<bool> addTeacher(
      BuildContext context,
      String student,
      String firstname,
      String lastname,
      DocumentReference classeReference) async {
    try {
      EnseignantM? newen = await UserRepo.addTeacher(
          context.user!.id!.substring(0, 4),
          student,
          firstname,
          lastname,
          classeReference);
      if (_userlist.value is LoadData) {
        if ((_userlist.value as LoadData)
            .rows
            .where((element) => element.id == newen!.id)
            .isNotEmpty) {
          (_userlist.value as LoadData).rows.insert(0, newen);
          _userlist.add(_studentlist.value);
        }
      }

      return true;
    } catch (e) {
      context.snackBar(e.toString());
      return false;
    }
  }

  User? get user => _user;
}
