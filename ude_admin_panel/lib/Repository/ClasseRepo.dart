// ignore_for_file: file_names

import '../Model/Abscence.dart';
import '../Model/Classe.dart';
import '../Model/Student.dart';
import '../Services/db.dart';

class ClasseRepo {
  static Future<List<ClasseM>> loadClasse(String lycee) async {
    late final List<ClasseM> classe;
    classe = await DBServices.getClasseList(lycee);
    Future.delayed(const Duration(seconds: 2));
    return classe;
  }

  static Future<List<StudentM>> loadStudent(String lycee, String classe) async {
    late final List<StudentM> students;
    students = await DBServices.getStudentList(lycee, classe);
    Future.delayed(const Duration(seconds: 2));
    return students;
  }

  static Future<List<AbscenceM>> loadStudentAbscence(
      String lycee, String classe, String student) async {
    late final List<AbscenceM> abscence;
    abscence = await DBServices.getStudentAbscence(lycee, classe, student);
    Future.delayed(const Duration(seconds: 2));
    return abscence;
  }

  static Future<List<ClasseM>> loadTeacherClasse(
      String lycee, String teacher) async {
    late final List<ClasseM> classe;
    classe = await DBServices.getTeacherClasseList(lycee, teacher);
    Future.delayed(const Duration(seconds: 2));
    return classe;
  }
}
