// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class StudentM {
  StudentM(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.abscence});
  // ignore: prefer_typing_uninitialized_variables
  late var id, firstname, lastname, abscence;

  factory StudentM.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> d) {
    final data = d.data();
    return StudentM(
        id: data!['id'].toString(),
        firstname: data['Nom'].toString(),
        lastname: data['Prénom'].toString(),
        abscence: data['TotalAbscence'].toString());
  }

  Map<String?, dynamic> toMap() => {
        'id': id,
        'Nom': firstname,
        'Prénom': lastname,
        'TotalAbscence': abscence,
      };
}
