// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ude_admin_panel/Model/Abscence.dart';
import 'package:ude_admin_panel/Model/Classe.dart';
import 'package:ude_admin_panel/Model/Enseignant.dart';
import 'package:ude_admin_panel/Model/Matiere.dart';
import 'package:ude_admin_panel/Model/Sceance.dart';
import 'package:ude_admin_panel/Model/Student.dart';
import 'package:ude_admin_panel/Model/User.dart';

class DBServices {
  static final CollectionReference lyceecol =
      FirebaseFirestore.instance.collection('Lycee');
  static Future getUser(String? lycee, String? id) async {
    try {
      final QuerySnapshot<Object?> snapshot = await lyceecol
          .doc(lycee)
          .collection('Admin')
          .where('id', isEqualTo: id)
          .get();
      final User userData = snapshot.docs
          .map((QueryDocumentSnapshot<Object?> e) =>
              User.fromSnapshot(e as DocumentSnapshot<Map<String?, dynamic>>))
          .single;
      return userData;
    } catch (e) {
      print('ADMIN NOT FOUND');
      print(e);
      throw Exception("$e");
    }
  }

  static Future getUserByToken(String token) async {
    try {
      final QuerySnapshot<Object?> snapshot = await lyceecol
          .doc(token.substring(0, 4))
          .collection('Admin')
          .where('token', isEqualTo: token)
          .get();
      final User userData = snapshot.docs
          .map((QueryDocumentSnapshot<Object?> e) =>
              User.fromSnapshot(e as DocumentSnapshot<Map<String?, dynamic>>))
          .single;
      return userData;
    } catch (e) {
      print('ADMIN NOT FOUND');
      print(e);
      throw Exception("$e");
    }
  }

  static Future<List<EnseignantM>> getEnseignantList(String lycee) async {
    final QuerySnapshot<Object?> snapshot =
        await lyceecol.doc(lycee).collection('Enseignant').get();

    List<EnseignantM> listeEnseignants = snapshot.docs
        .map((doc) => EnseignantM.fromSnapshot(
            doc as DocumentSnapshot<Map<String?, dynamic>>))
        .toList();

    return listeEnseignants;
  }

  static Future<EnseignantM?> addTeacher(
      String lycee,
      String firstname,
      String lastname,
      String enseignant,
      List<dynamic> classeReferences) async {
    try {
      Map<String, dynamic> newdata = {
        'Nom': firstname,
        'Pr??nom': lastname,
        'Id': enseignant,
        'nbHeures': '0:00'
      };
      await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(enseignant)
          .set(newdata, SetOptions(merge: true));
      Future.delayed(const Duration(seconds: 2));
      var teacherSnapshot = await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(enseignant)
          .get();

      for (var classeRef in classeReferences) {
        print('CLASSEREF:$classeRef');
        Map<String, dynamic> data = {
          'reference': classeRef as DocumentReference
        };
        await lyceecol
            .doc(lycee)
            .collection('Enseignant')
            .doc(enseignant)
            .collection('Classes')
            .doc(classeRef.path.toString().substring(19))
            .set(data, SetOptions(merge: true));
      }
      return EnseignantM.fromSnapshot(teacherSnapshot);
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'??tudiant : $e');
      return null;
    }
  }

  static Future getTeacherClasseList(String? lycee, String? teacher) async {
    try {
      List<ClasseM> listeclasse = [];
      final snapshot = await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(teacher)
          .collection('Classes')
          .get();
      for (var classe in snapshot.docs) {
        var classeRef = classe.data()["reference"];
        DocumentSnapshot<Map<String, dynamic>>? classRoom;

        try {
          await FirebaseFirestore.instance
              .doc(classeRef.path)
              .get()
              .then((snapshot) {
            if (snapshot.exists) {
              classRoom = snapshot;
            } else {
              debugPrint("Document not found");
            }
          });
        } catch (e) {
          debugPrint('CLASSE Not EXIST');
          print(e);
          rethrow;
        }
        if (classRoom != null) {
          listeclasse.add(ClasseM.fromSnapshot(
              classRoom as DocumentSnapshot<Map<String?, dynamic>>));
        } else {
          print('Impossible de charger les classes affilees a cet enseignant');
        }
      }
      return listeclasse;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<bool> addTeacherClasse(
      String lycee, String enseignant, List<dynamic> classeReferences) async {
    try {
      for (var classeRef in classeReferences) {
        print('CLASSEREF:$classeRef');
        Map<String, dynamic> data = {
          'reference': classeRef as DocumentReference
        };
        await lyceecol
            .doc(lycee)
            .collection('Enseignant')
            .doc(enseignant.toUpperCase())
            .collection('Classes')
            .doc(classeRef.path.toString().substring(19))
            .set(data, SetOptions(merge: true));
      }
      return true;
    } catch (e) {
      print('Erreur lors de l\'ajout de la classe : $e');
      return false;
    }
  }

  static Future<List<ClasseM>> getClasseList(String lycee) async {
    final QuerySnapshot<Object?> snapshot =
        await lyceecol.doc(lycee).collection('Classes').get();

    List<ClasseM> listeClasses = snapshot.docs
        .map((doc) => ClasseM.fromSnapshot(
            doc as DocumentSnapshot<Map<String?, dynamic>>))
        .toList();

    return listeClasses;
  }

  static Future<bool> deleteTeacherById(String lycee, String documentId) async {
    try {
      // Supprime le document Classe
      var classeSnapshot = await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(documentId)
          .collection('Classes')
          .get();
      for (var doc in classeSnapshot.docs) {
        doc.reference.delete();
      }

      // Supprimer le document Sceances
      var sceanceSnapshot = await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(documentId)
          .collection('Sceances')
          .get();
      for (var doc in sceanceSnapshot.docs) {
        doc.reference.delete();
      }
      // Supprimer le document lui meme
      await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(documentId)
          .delete();
      print('Le document a ??t?? supprim?? avec succ??s !');
      return true;
    } catch (e) {
      print('Une erreur est survenue lors de la suppression du document : $e');
      return false;
    }
  }

  static Future<bool> deleteTeacherClasse(
      String lycee, String documentId, String classe) async {
    try {
      // Supprime le document
      await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(documentId)
          .collection('Classes')
          .doc(classe)
          .delete();

      print('Le document a ??t?? supprim?? avec succ??s !');
      return true;
    } catch (e) {
      print('Une erreur est survenue lors de la suppression du document : $e');
      return false;
    }
  }

  static Future<bool> deleteTeacherSceance(
      String lycee, String documentId, String sceanceId) async {
    try {
      // Supprime le document
      var snapshot = await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(documentId)
          .collection('Sceances')
          .where('Id', isEqualTo: sceanceId)
          .get();
      for (var document in snapshot.docs) {
        var docRef = document.reference;
        FirebaseFirestore.instance
            .doc(docRef.path)
            .collection('Abscences')
            .doc()
            .delete();
        document.reference.delete();
      }
      print('Le document a ??t?? supprim?? avec succ??s !');
      return true;
    } catch (e) {
      print('Une erreur est survenue lors de la suppression du document : $e');
      return false;
    }
  }

  static Future<DocumentReference> getClasseRef(
      String lycee, String classe) async {
    var snapshot =
        await lyceecol.doc(lycee).collection('Classes').doc(classe).get();
    var ref = snapshot.reference;

    return ref;
  }

  static Future<List<MatiereM>> getClasseMatiere(
      String lycee, String classe) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await lyceecol
        .doc(lycee)
        .collection('Classes')
        .doc(classe)
        .collection('Matieres')
        .get();
    List<MatiereM> listeMatieres =
        snapshot.docs.map((doc) => MatiereM.fromSnapshot(doc)).toList();

    return listeMatieres;
  }

  static Future<List<StudentM>> getStudentList(
      String lycee, String classe) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await lyceecol
        .doc(lycee)
        .collection('Classes')
        .doc(classe)
        .collection('Etudiants')
        .get();

    List<StudentM> listeStudents =
        snapshot.docs.map((doc) => StudentM.fromSnapshot(doc)).toList();

    return listeStudents;
  }

  static Future<List<AbscenceM>> getStudentAbscence(
      String lycee, String classe, String student) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await lyceecol
        .doc(lycee)
        .collection('Classes')
        .doc(classe)
        .collection('Etudiants')
        .where('id', isEqualTo: student)
        .get();
    DocumentSnapshot documentSnapshot = snapshot.docs[0];
    CollectionReference abscenceRef =
        documentSnapshot.reference.collection('Abscence');
    QuerySnapshot abscenceQuerySnapshot = await abscenceRef.get();

    List<AbscenceM> abscences = abscenceQuerySnapshot.docs
        .map((doc) => AbscenceM.fromSnapshot(
            doc as DocumentSnapshot<Map<String?, dynamic>>))
        .toList();

    return abscences;
  }

  static Future<StudentM?> addStudent(String lycee, String classe,
      String firstname, String lastname, String student, String sexe) async {
    try {
      await lyceecol
          .doc(lycee)
          .collection('Classes')
          .doc(classe)
          .collection('Etudiants')
          .doc(student)
          .set({
        'Nom': firstname,
        'Pr??nom': lastname,
        'id': student.toUpperCase(),
        'TotalAbscence': '0',
        'Sexe': sexe
      });
      var etudiantRef = lyceecol
          .doc(lycee)
          .collection('Classes')
          .doc(classe)
          .collection('Etudiants')
          .doc(student);
      var etudiantSnapshot = await etudiantRef.get();
      var newetudiant = await lyceecol
          .doc(lycee)
          .collection('Classes')
          .doc(classe)
          .collection('Etudiants')
          .where('id', isEqualTo: etudiantSnapshot.data()!['id'])
          .get();
      var docRef = newetudiant.docs.first.reference;
      var matieres = await lyceecol
          .doc(lycee)
          .collection('Classes')
          .doc(classe)
          .collection('Matieres')
          .get();
      for (var mts in matieres.docs) {
        var matname = mts.data()['Matiere'];
        DocumentReference matRef = lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .collection('Matieres')
            .doc(matname);
        await docRef.collection('Abscence').doc(matname).set(
            {'Matiere': matRef.path, 'Abscence': '0'}, SetOptions(merge: true));
      }

      print('Etudiant ajout?? avec succ??s');

      var classeSnap =
          await lyceecol.doc(lycee).collection('Classes').doc(classe).get();

      if (sexe == 'Masculin') {
        var newNBEleve = int.parse(classeSnap.data()!['NBEleves']) + 1;
        var newGarcon = int.parse(classeSnap.data()!['Garcon']) + 1;
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'Garcon': newGarcon.toString()});
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'NBEleves': newNBEleve.toString()});
        print('Nouvel eleve garcon ajoutee');
      } else {
        var newNBEleve = int.parse(classeSnap.data()!['NBEleves']) + 1;
        var newFille = int.parse(classeSnap.data()!['Fille']) + 1;
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'Fille': newFille.toString()});
        print('Nouvel eleve fille ajoutee');
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'NBEleves': newNBEleve.toString()});
      }
      return StudentM.fromSnapshot(etudiantSnapshot);
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'??tudiant : $e');
      return null;
    }
  }

  static Future<bool> deleteStudentById(
      String lycee, String classe, String documentId) async {
    try {
      var etudiantRef = lyceecol
          .doc(lycee)
          .collection('Classes')
          .doc(classe)
          .collection('Etudiants')
          .doc(documentId);
      var etudiantSnapshot = await etudiantRef.get();
      StudentM std = StudentM.fromSnapshot(etudiantSnapshot);
      var classeSnap =
          await lyceecol.doc(lycee).collection('Classes').doc(classe).get();
      //Actualiser le nombre d'eleve de la classe si un garcon est suprime
      if (std.sexe == 'Masculin') {
        var newNBEleve = int.parse(classeSnap.data()!['NBEleves']) - 1;
        var newGarcon = int.parse(classeSnap.data()!['Garcon']) - 1;
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'Garcon': newGarcon.toString()});
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'NBEleves': newNBEleve.toString()});
        print(' Eleve garcon suprimee');
      }
      //Actualiser le nombre d'eleve de la classe si une fille est suprimee
      else {
        var newNBEleve = int.parse(classeSnap.data()!['NBEleves']) - 1;
        var newFille = int.parse(classeSnap.data()!['Fille']) - 1;
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'Fille': newFille.toString()});
        print(' Eleve fille suprimee');
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'NBEleves': newNBEleve.toString()});
      }
      // Supprime le document
      await lyceecol
          .doc(lycee)
          .collection('Classes')
          .doc(classe)
          .collection('Etudiants')
          .doc(documentId)
          .delete();
      print('Le document a ??t?? supprim?? avec succ??s !');
      return true;
    } catch (e) {
      print('Une erreur est survenue lors de la suppression du document : $e');
      return false;
    }
  }

  static Future<List<SceanceM>> getSceances(
      String lycee, String teacher) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await lyceecol
        .doc(lycee)
        .collection('Enseignant')
        .doc(teacher)
        .collection('Sceances')
        .orderBy('Date', descending: true)
        .get();

    List<SceanceM> listeSceances =
        snapshot.docs.map((doc) => SceanceM.fromSnapshot(doc)).toList();

    return listeSceances;
  }

  static Future<List<StudentM>> getSceanceAbscence(
      String lycee, String enseignant, String sceance) async {
    final snapshot = await lyceecol
        .doc(lycee)
        .collection('Enseignant')
        .doc(enseignant)
        .collection('Sceances')
        .where('Id', isEqualTo: int.parse(sceance))
        .get();
    DocumentSnapshot documentSnapshot = snapshot.docs[0];
    CollectionReference abscenceRef =
        documentSnapshot.reference.collection('Abscences');
    QuerySnapshot abscenceQuerySnapshot = await abscenceRef.get();

    List<StudentM> students = abscenceQuerySnapshot.docs
        .map((doc) => StudentM.fromSnapshot(
            doc as DocumentSnapshot<Map<String?, dynamic>>))
        .toList();

    return students;
  }

  static Future<bool> resetAll(
    String lycee,
    String code,
  ) async {
    if (code == 'RESETALLDATA2023') {
      try {
        final QuerySnapshot<Object?> enseignants =
            await lyceecol.doc(lycee).collection('Enseignant').get();
        for (var enseignant in enseignants.docs) {
          var enseignantRef = enseignant.reference;
          var enseignantSceancesAbscences = await FirebaseFirestore.instance
              .doc(enseignantRef.path)
              .collection('Sceances')
              .doc()
              .collection('Abscences')
              .get();
          for (var abscence in enseignantSceancesAbscences.docs) {
            await abscence.reference.delete();
          }

          await FirebaseFirestore.instance
              .doc(enseignantRef.path)
              .update({'nbHeures': '0:00'});
          var enseignantSceances = await FirebaseFirestore.instance
              .doc(enseignantRef.path)
              .collection('Sceances')
              .get();
          for (var sceance in enseignantSceances.docs) {
            await sceance.reference.delete();
          }
        }

        final QuerySnapshot<Object?> classes =
            await lyceecol.doc(lycee).collection('Classes').get();
        for (var classe in classes.docs) {
          var classeRef = classe.reference;
          await FirebaseFirestore.instance
              .doc(classeRef.path)
              .update({'Fille': '0', 'Garcon': '0', 'NBEleves': '0'});
          var classeStudents = await FirebaseFirestore.instance
              .doc(classeRef.path)
              .collection('Etudiants')
              .get();
          for (var student in classeStudents.docs) {
            await student.reference.delete();
          }
        }
        return true;
      } catch (e) {
        print(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }
}
