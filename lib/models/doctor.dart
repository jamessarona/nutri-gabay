import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Doctor dotorFromJson(String str) => Doctor.fromJson(json.decode(str));

String dotorToJson(Doctor data) => json.encode(data.toJson());

class Doctor {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String birthdate;
  final String address;
  final String specialization;
  final String image;
  final String file;
  final String about;
  final String specialties;
  final bool isOnline;
  final DateTime lastActive;
  Doctor({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.address,
    required this.specialization,
    required this.image,
    required this.file,
    required this.about,
    required this.specialties,
    required this.isOnline,
    required this.lastActive,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        birthdate: json["birthdate"],
        address: json["address"],
        specialization: json["specialization"],
        image: json["image"],
        file: json["file"],
        about: json["about"],
        specialties: json["specialties"],
        isOnline: json["isOnline"],
        lastActive: json["lastActive"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "phone": phone,
        "birthdate": birthdate,
        "address": address,
        "specialization": specialization,
        "image": image,
        "file": file,
        "about": about,
        "specialties": specialties,
        "isOnline": isOnline,
        "lastActive": lastActive,
      };

  factory Doctor.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Doctor(
      uid: data?["uid"],
      name: data?["name"],
      email: data?["email"],
      phone: data?["phone"],
      birthdate: data?["birthdate"],
      address: data?["address"],
      specialization: data?["specialization"],
      image: data?["image"],
      file: data?["file"],
      about: data?["about"],
      specialties: data?["specialties"],
      isOnline: data?["isOnline"],
      lastActive: data?["lastActive"].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "name": name,
      "phone": phone,
      "birthdate": birthdate,
      "address": address,
      "specialization": specialization,
      "image": image,
      "file": file,
      "about": about,
      "specialties": specialties,
      "isOnline": isOnline,
      "lastActive": lastActive,
    };
  }
}
