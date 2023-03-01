// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class MatiereM {
  MatiereM({
    required this.matiere,
  });
  // ignore: prefer_typing_uninitialized_variables
  late var matiere;

  factory MatiereM.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> d) {
    final data = d.data();
    return MatiereM(matiere: data!['Matiere'].toString());
  }

  Map<String?, dynamic> toMap() => {
        'Matiere': matiere,
      };
}
