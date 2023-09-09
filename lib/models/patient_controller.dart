import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Patient patientFromJson(String str) => Patient.fromJson(json.decode(str));

String patientToJson(Patient data) => json.encode(data.toJson());

class Patient {
  final String uid;
  final String firstname;
  final String lastname;
  final String email;

  Patient({
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        uid: json["uid"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
      };

  factory Patient.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Patient(
      uid: data?["uid"],
      firstname: data?["firstname"],
      lastname: data?["lastname"],
      email: data?["email"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
    };
  }
}
