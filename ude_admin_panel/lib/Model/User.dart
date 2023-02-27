// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? firstname;
  String? lastname;
  String? token;
  bool? active;
  String? lastlogin;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.token,
      this.active,
      this.lastlogin});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    token = json['token'];
    active = json['active'] == 1;
    lastlogin = json['lastlogin'];
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> d) {
    final data = d.data();
    return User(
        id: data!['id'].toString(),
        firstname: data['Nom'].toString(),
        lastname: data['Prenom'].toString(),
        token: data['token'].toString(),
        active: data['active'],
        lastlogin: data['lastlogin'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['token'] = token;
    data['active'] = active! ? 1 : 0;
    data['lastlogin'] = lastlogin;
    return data;
  }
}
