// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AbscenceM {
  AbscenceM({required this.matiere, required this.abscence});
  // ignore: prefer_typing_uninitialized_variables
  late var matiere, abscence;

  factory AbscenceM.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> d) {
    final data = d.data();
    return AbscenceM(
        matiere: data!['Matiere'].toString(),
        abscence: data['Abscence'].toString());
  }

  Map<String?, dynamic> toMap() => {
        'Matiere': matiere,
        'Abscence': abscence,
      };
}
