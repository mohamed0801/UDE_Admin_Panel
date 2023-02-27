// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ude_admin_panel/Model/Abscence.dart';
import 'package:ude_admin_panel/Model/Classe.dart';
import 'package:ude_admin_panel/Model/Enseignant.dart';
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
      DocumentReference classeReference) async {
    try {
      Map<String, dynamic> newdata = {
        'Nom': firstname,
        'Prenom': lastname,
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

      Map<String, dynamic> data = {'reference': classeReference};
      await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(enseignant)
          .collection('Classes')
          .doc('classe')
          .set(data, SetOptions(merge: true));

      return EnseignantM.fromSnapshot(teacherSnapshot);
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'étudiant : $e');
      return null;
    }
  }

  static Future getTeacherClasseList(String? lycee, String? teacher) async {
    try {
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
          List<ClasseM> listeclasse = [];
          listeclasse.add(ClasseM.fromSnapshot(
              classRoom as DocumentSnapshot<Map<String?, dynamic>>));
          return listeclasse;
        } else {
          print('Impossible de charger les classes affilees a cet enseignant');
        }
      }
    } catch (e) {
      print(e);
      rethrow;
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

  static Future<DocumentReference> getClasseRef(
      String lycee, String classe) async {
    var snapshot =
        await lyceecol.doc(lycee).collection('Classes').doc(classe).get();
    var ref = snapshot.reference;

    return ref;
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
      var etudiantRef = await lyceecol
          .doc(lycee)
          .collection('Classes')
          .doc(classe)
          .collection('Etudiants')
          .add({
        'Nom': firstname,
        'Prenom': lastname,
        'id': student,
        'TotalAbscence': '0'
      });

      var etudiantSnapshot = await etudiantRef.get();
      var newetudiant = await lyceecol
          .doc(lycee)
          .collection('Classes')
          .doc(classe)
          .collection('Etudiants')
          .where('id', isEqualTo: etudiantSnapshot.data()!['id'])
          .get();
      var docRef = newetudiant.docs.first.reference;
      Map<String, dynamic> data = {'Mathematique': '0'};
      await docRef
          .collection('Abscence')
          .doc('Matieres')
          .set(data, SetOptions(merge: true));

      print('Etudiant ajouté avec succès');

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
            .update({'Garcon': newFille.toString()});
        print('Nouvel eleve fille ajoutee');
        await lyceecol
            .doc(lycee)
            .collection('Classes')
            .doc(classe)
            .update({'NBEleves': newNBEleve.toString()});
      }
      return StudentM.fromSnapshot(etudiantSnapshot);
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'étudiant : $e');
      return null;
    }
  }

  static Future<List<SceanceM>> getSceances(
      String lycee, String teacher) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await lyceecol
        .doc(lycee)
        .collection('Enseignant')
        .doc(teacher)
        .collection('Sceances')
        .get();

    List<SceanceM> listeSceances =
        snapshot.docs.map((doc) => SceanceM.fromSnapshot(doc)).toList();

    return listeSceances;
  }

  static Future getClasseName(
      String? lycee, String? id, List<String> paths, List<String> list) async {
    try {
      String classeName;
      final snapshot = await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(id)
          .collection('Classes')
          .get();
      for (var classe in snapshot.docs) {
        DocumentReference<Map<String, dynamic>> classeRef =
            classe.data()["reference"];
        DocumentSnapshot<Map<String, dynamic>>? classRoom;
        //await DBServices.getClasse(classeRef.path, classRoom);
        try {
          await FirebaseFirestore.instance
              .doc(classeRef.path)
              .get()
              .then((snapshot) {
            if (snapshot.exists) {
              debugPrint('SNAPSHOTTTT: ${snapshot.data()!["Nom"]}');
              classRoom = snapshot;
              paths.add(classeRef.path); //.data()!["Nom"];
            } else {
              debugPrint("Document not found");
            }
          });
          debugPrint('CLASSROOMMMM: ${classRoom!.data()!["Nom"]}');
        } catch (e) {
          debugPrint('CLASSE Not EXIST');
          print(e);
          rethrow;
        }
        if (classRoom != null) {
          print('CLASSENAME ${classRoom!.data()!["Nom"]}');
          classeName = classRoom!.data()!["Nom"];
          list.add(classeName);
        } else {
          print('Impossible de charger les classes affilees a cet enseignant');
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future updateHours(String? lycee, id, volume) async {
    try {
      var snapshot = await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .where('Id', isEqualTo: id)
          .get();
      final EnseignantM userData = snapshot.docs
          .map((QueryDocumentSnapshot<Object?> e) => EnseignantM.fromSnapshot(
              e as DocumentSnapshot<Map<String?, dynamic>>))
          .single;

// Convertir les chaînes de caractères en objets DateTime
      String prefixe = "";
      if (userData.hours.length > 0 &&
          int.tryParse(userData.hours[0]) != null &&
          userData.hours[1] == ':') {
        prefixe = "0";
      }
      String resultat = prefixe + userData.hours;

      DateTime dateTime1 = DateTime.parse("${"2023-01-01 " + resultat}:00");
      DateTime dateTime2 = DateTime.parse("${"2023-01-01 " + volume}:00");

// Ajouter les deux heures en utilisant la classe Duration
      Duration sum = Duration(
          hours: dateTime1.hour + dateTime2.hour,
          minutes: dateTime1.minute + dateTime2.minute);

// Convertir le résultat en objet DateTime
      DateTime result = DateTime(2023, 1, 1, 0, 0).add(sum);

// Formater le résultat sous forme de chaîne de caractères
      String formattedResult =
          "${result.hour}:${result.minute.toString().padLeft(2, '0')}";

      print('RESULTTTTT $formattedResult');

      await lyceecol
          .doc(lycee)
          .collection('Enseignant')
          .doc(id)
          .update({'nbHeures': formattedResult});
    } catch (e) {
      debugPrint("Nombre dheure de l'enseignant non modifier");
      rethrow;
    }
  }

  static Future updateStudentAbscence(
      StudentM student, String? path, String matiere) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .doc(path!)
          .collection('Etudiants')
          .doc(student.id)
          .collection('Abscence')
          .doc('Matieres')
          .get();
      print('MATH ABSCENCENSE ${snapshot.data()}');
      print('MATH ABSCENCENSE $matiere}');
      var abscenceValue = int.parse('${snapshot.data()![matiere]}') + 1;
      DocumentReference docRef = snapshot.reference;
      await docRef.update({matiere: abscenceValue.toString()});

      var total = await FirebaseFirestore.instance
          .doc(path)
          .collection('Etudiants')
          .doc(student.id)
          .get();
      var totalAbscence = int.parse('${total.data()!['TotalAbscence']}') + 1;
      DocumentReference absRef = total.reference;
      await absRef.update({'TotalAbscence': totalAbscence.toString()});
    } catch (e) {
      debugPrint('Impossible de modifier les abscence des etudiants');
      rethrow;
    }
  }
}
