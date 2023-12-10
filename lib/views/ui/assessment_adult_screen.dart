import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/models/patient_nutrition_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';
import 'package:nutri_gabay/views/ui/assessment_result_screen.dart';

class AssessmentAdultScreen extends StatefulWidget {
  final BaseAuth auth;
  final String height;
  final String weight;
  final String age;
  final String sex;
  final int category;
  const AssessmentAdultScreen(
      {super.key,
      required this.auth,
      required this.height,
      required this.weight,
      required this.age,
      required this.sex,
      required this.category});

  @override
  State<AssessmentAdultScreen> createState() => _AssessmentAdultScreenState();
}

class _AssessmentAdultScreenState extends State<AssessmentAdultScreen> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usual = TextEditingController();
  final TextEditingController _ideal = TextEditingController();
  final TextEditingController _actual = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var patient, nutritionProfile;
  bool hasData = false;
  String assessmentId = "";

  getPatientInfo() async {
    String uid = await widget.auth.currentUser();
    final ref =
        FirebaseFirestore.instance.collection("patient").doc(uid).withConverter(
              fromFirestore: Patient.fromFirestore,
              toFirestore: (Patient patient, _) => patient.toFirestore(),
            );
    final docSnap = await ref.get();
    patient = docSnap.data();
    hasData = patient != null;
    setState(() {});
  }

  getPatientNutritionInfo() async {
    String uid = await FireBaseAuth().currentUser();
    final collection = FirebaseFirestore.instance
        .collection('patient_nutritional_profile')
        .where("uid", isEqualTo: uid)
        .withConverter(
          fromFirestore: PatientNutrition.fromFirestore,
          toFirestore: (PatientNutrition ptn, _) => ptn.toFirestore(),
        );

    collection.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (uid == docSnapshot.data().uid) {
            nutritionProfile = docSnapshot.data();
            break;
          }
        }
      },
    );
  }

  double calculateBmi() {
    double height = (double.parse(widget.height) / 100) * 2;
    double weight = double.parse(widget.weight);
    return double.parse((weight / height).toStringAsFixed(2));
  }

  String getBmiStatus() {
    String status;
    double bmi = calculateBmi();
    if (bmi < 18.5) {
      status = 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      status = 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      status = 'Overweight';
    } else {
      status = 'Obese';
    }
    return status;
  }

  double calculateUsualBodyWeight() {
    String percent =
        ((double.parse(_actual.text) / double.parse(_usual.text)) * 100)
            .toStringAsFixed(2);
    return double.parse(percent) < 100 ? double.parse(percent) : 100;
  }

  String getUsualBodyWeightResult() {
    String result = "";
    double percent = calculateUsualBodyWeight();

    if (percent < 75) {
      result = "Risk of severe malnutrition";
    } else if (percent < 85) {
      result = "Risk of moderate malnutrition";
    } else if (percent <= 95) {
      result = "Risk of mild malnutrition";
    } else {
      result = 'No risk of malnutrition';
    }
    return result;
  }

  double calculateIdealBodyWeight() {
    String percent =
        ((double.parse(_actual.text) / double.parse(_ideal.text)) * 100)
            .toStringAsFixed(2);
    return double.parse(percent) < 100 ? double.parse(percent) : 100;
  }

  String getIdealBodyWeightResult() {
    String result = "";
    double percent = calculateUsualBodyWeight();

    if (percent < 70) {
      result = "Risk of severe malnutrition";
    } else if (percent < 80) {
      result = "Risk of moderate malnutrition";
    } else if (percent <= 90) {
      result = "Risk of mild malnutrition";
    } else {
      result = 'No risk of malnutrition';
    }
    return result;
  }

  void submitNutritionalProfile() {
    if (_formKey.currentState!.validate()) {
      saveNutritionalProfile().then((value) {
        if (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AssessmentResultScreen(
                auth: widget.auth,
                assessmentId: assessmentId,
                isDefaultNotifierIndex: false,
              ),
            ),
          );
        }
      });
    }
  }

  Future<bool> saveNutritionalProfile() async {
    bool isDone = false;
    String uid = await widget.auth.currentUser();

    DocumentReference docNutrition;
    if (nutritionProfile == null) {
      docNutrition = FirebaseFirestore.instance
          .collection('patient_nutritional_profile')
          .doc();
    } else {
      docNutrition = FirebaseFirestore.instance
          .collection('patient_nutritional_profile')
          .doc(nutritionProfile.id);
    }

    assessmentId = docNutrition.id;
    PatientNutrition user = PatientNutrition(
      id: docNutrition.id,
      uid: uid,
      height: double.parse(widget.height),
      weight: double.parse(widget.weight),
      date: DateFormat('MM/dd/yyyy').format(DateTime.now()),
      birthdate: '',
      age: int.parse(widget.age),
      sex: widget.sex,
      bmi: calculateBmi(),
      category: widget.category,
      status: getBmiStatus(),
      points: calculateUsualBodyWeight(),
      result: getUsualBodyWeightResult(),
      idealPoints: calculateIdealBodyWeight(),
      idealResult: getIdealBodyWeightResult(),
    );

    final json = user.toJson();
    if (nutritionProfile == null) {
      await docNutrition.set(json).then((value) {
        isDone = true;
      });
    } else {
      await docNutrition.update(json).then((value) {
        isDone = true;
      });
    }

    return isDone;
  }

  @override
  void initState() {
    getPatientInfo();
    getPatientNutritionInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 100),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
                  height: 90,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo-name.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                UserCredentialTextField(
                  controller: _usual,
                  screenSize: screenSize,
                  label: "Usual Body Weight (kg):",
                  isObscure: false,
                  keyboardType: TextInputType.number,
                  validation: (value) {
                    if (value == "") {
                      return "Please enter your usual body weight";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                UserCredentialTextField(
                  controller: _ideal,
                  screenSize: screenSize,
                  label: "Ideal Body Weight (kg):",
                  isObscure: false,
                  keyboardType: TextInputType.number,
                  validation: (value) {
                    if (value == "") {
                      return "Please enter your ideal body weight";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                UserCredentialTextField(
                  controller: _actual,
                  screenSize: screenSize,
                  label: "Actual Body Weight (kg):",
                  isObscure: false,
                  keyboardType: TextInputType.number,
                  validation: (value) {
                    if (value == "") {
                      return "Please enter your actual body weight";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.2),
                  height: 50,
                  child: UserCredentialPrimaryButton(
                    onPress: () {
                      submitNutritionalProfile();
                    },
                    label: "Proceed",
                    labelSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
