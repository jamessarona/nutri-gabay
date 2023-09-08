import 'dart:convert';

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
        "fistname": firstname,
        "lastname": lastname,
        "email": email,
      };
}
