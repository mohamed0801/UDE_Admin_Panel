// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:ude_admin_panel/Model/Student.dart';

import 'package:ude_admin_panel/module/estension.dart';

import '../Model/Enseignant.dart';
import '../Model/Sceance.dart';
import '../Model/User.dart';
import '../Services/db.dart';

class UserRepo {
  static Future<User> authenticate(String lycee, String matricule) async {
    return await Future.delayed(const Duration(seconds: 1)).then((value) async {
      final User user = await DBServices.getUser(lycee, matricule);
      if (matricule == user.id) {
        return user;
      }
      throw Exception("Matricule ou Mot de passe incorrecte");
    });
  }

  static Future<DocumentReference<Object?>> getClasseRef(
    BuildContext context,
    String lycee,
    String classe,
  ) async {
    try {
      DocumentReference<Object?> ref =
          await DBServices.getClasseRef(lycee, classe);
      return ref;
    } catch (e) {
      context.snackBar(e.toString());
      rethrow;
    }
  }

  static Future<List<EnseignantM>> getTeacherList(String lycee) async {
    late final List<EnseignantM> enseignant;
    enseignant = await DBServices.getEnseignantList(lycee);
    Future.delayed(const Duration(seconds: 2));
    return enseignant;
  }

  static Future<EnseignantM?> addTeacher(String lycee, String ensgnt,
      String firstname, String lastname, List<dynamic> classeReferences) async {
    late final EnseignantM? enseignant;
    enseignant = (await DBServices.addTeacher(
        lycee, firstname, lastname, ensgnt, classeReferences));
    Future.delayed(const Duration(seconds: 2));
    return enseignant;
  }

  static Future<List<SceanceM>> loadSceance(
      String lycee, String teacher) async {
    late final List<SceanceM> sceances;
    sceances = await DBServices.getSceances(lycee, teacher);
    Future.delayed(const Duration(seconds: 2));
    return sceances;
  }

  static Future<List<StudentM>> loadSceanceAbscence(
      String lycee, String enseignant, String sceance) async {
    late final List<StudentM> student;
    student = await DBServices.getSceanceAbscence(lycee, enseignant, sceance);
    Future.delayed(const Duration(seconds: 2));
    return student;
  }

  static Future<User> authenticateByToken(String token) async {
    return await Future.delayed(const Duration(seconds: 3)).then((value) async {
      final User user = await DBServices.getUserByToken(token);
      if (token == user.token) {
        return user;
      }
      throw Exception("Matricule ou Mot de passe incorrecte");
    });
  }

  static Future<bool> resetAll(
    String lycee,
    String code,
  ) async {
    try {
      var reset = await DBServices.resetAll(
        lycee,
        code,
      );

      return reset;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
