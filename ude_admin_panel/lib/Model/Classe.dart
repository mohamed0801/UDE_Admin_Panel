// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ClasseM {
  ClasseM(
      {required this.name,
      required this.fille,
      required this.garcon,
      required this.total,
      this.showdetail});
  // ignore: prefer_typing_uninitialized_variables
  late var name, fille, garcon, total;
  bool? showdetail;

  factory ClasseM.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> d) {
    final data = d.data();
    return ClasseM(
        name: data!['Nom'].toString(),
        fille: data['Fille'].toString(),
        garcon: data['Garcon'].toString(),
        total: data['NBEleves'].toString());
  }

  Map<String?, dynamic> toMap() => {
        'Nom': name,
        'Fille': fille,
        'Garcon': garcon,
        'NBEleves': total,
      };
}
