import 'dart:convert';

PatientNutrition patientNutritionFromJson(String str) =>
    PatientNutrition.fromJson(json.decode(str));

String patientNutritionToJson(PatientNutrition data) =>
    json.encode(data.toJson());

class PatientNutrition {
  final String id;
  final String uid;
  final double height;
  final double weight;
  final int age;
  final String sex;
  final double bmi;
  final String status;

  PatientNutrition({
    required this.id,
    required this.uid,
    required this.height,
    required this.weight,
    required this.age,
    required this.sex,
    required this.bmi,
    required this.status,
  });

  factory PatientNutrition.fromJson(Map<String, dynamic> json) =>
      PatientNutrition(
        id: json["id"],
        uid: json["uid"],
        height: json["height"],
        weight: json["weight"],
        age: json["age"],
        sex: json["sex"],
        bmi: json["bmi"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "height": height,
        "weight": weight,
        "age": age,
        "sex": sex,
        "bmi": bmi,
        "status": status,
      };
}
