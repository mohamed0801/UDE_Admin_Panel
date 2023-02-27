// ignore_for_file: file_names

import 'package:ude_admin_panel/Model/Student.dart';
import 'package:ude_admin_panel/Services/db.dart';

class StudentRepo {
  static Future<StudentM?> addStudent(String lycee, String classe,
      String stdent, String firstname, String lastname, String sexe) async {
    late final StudentM? student;
    student = (await DBServices.addStudent(
        lycee, classe, firstname, lastname, stdent, sexe));
    Future.delayed(const Duration(seconds: 2));
    return student;
  }
}
