// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class SceanceM {
  SceanceM(
      {required this.id,
      required this.classe,
      required this.creneau,
      required this.matiere,
      required this.volume,
      required this.date});
  // ignore: prefer_typing_uninitialized_variables
  late var classe, creneau, matiere, volume, date, id;

  factory SceanceM.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> d) {
    final data = d.data();

    return SceanceM(
        id: data!['Id'].toString(),
        classe: data['Classe'].toString(),
        creneau: data['Creneau'].toString(),
        matiere: data['Matiere'].toString(),
        volume: data['Volume'].toString(),
        date: data['Date'].toString());
  }

  Map<String?, dynamic> toMap() => {
        'Id': id,
        'Classe': classe,
        'Creneau': creneau,
        'Matiere': matiere,
        'Volume': volume,
        'Date': date
      };
}
