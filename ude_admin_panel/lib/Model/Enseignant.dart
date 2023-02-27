// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class EnseignantM {
  EnseignantM(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.hours});
  // ignore: prefer_typing_uninitialized_variables
  late var id, firstname, lastname, hours;

  factory EnseignantM.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> d) {
    final data = d.data();
    return EnseignantM(
        id: data!['Id'].toString(),
        firstname: data['Nom'].toString(),
        lastname: data['Prenom'].toString(),
        hours: data['nbHeures'].toString());
  }

  Map<String?, dynamic> toMap() => {
        'Id': id,
        'Nom': firstname,
        'Prénom': lastname,
        'nbHeures': hours,
      };
}
