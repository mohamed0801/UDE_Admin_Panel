// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AbscenceM {
  AbscenceM({
    required this.mathematique,
  });
  // ignore: prefer_typing_uninitialized_variables
  late var mathematique, creneau, matiere, volume, date;

  factory AbscenceM.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> d) {
    final data = d.data();
    return AbscenceM(mathematique: data!['Mathematique'].toString());
  }

  Map<String?, dynamic> toMap() => {
        'Mathematique': mathematique,
      };
}
