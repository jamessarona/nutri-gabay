import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/models/patient_nutrition_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/assessment_question.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/custom_container.dart';
import 'package:nutri_gabay/views/ui/assessment_result_screen.dart';

class AssessmentElderlyScreen extends StatefulWidget {
  final BaseAuth auth;
  final String height;
  final String weight;
  final String age;
  final String sex;
  final int category;
  const AssessmentElderlyScreen(
      {super.key,
      required this.auth,
      required this.height,
      required this.weight,
      required this.age,
      required this.sex,
      required this.category});

  @override
  State<AssessmentElderlyScreen> createState() =>
      _AssessmentElderlyScreenState();
}

class _AssessmentElderlyScreenState extends State<AssessmentElderlyScreen> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _question1 = TextEditingController();
  final TextEditingController _question2 = TextEditingController();
  final TextEditingController _question3 = TextEditingController();
  final TextEditingController _question4 = TextEditingController();
  final TextEditingController _question5 = TextEditingController();
  final TextEditingController _question6 = TextEditingController();
  final TextEditingController _question7 = TextEditingController();

  var patient;
  bool hasData = false;
  bool isSuccessful = false;
  String assessmentId = "";

  void checkUserAssessment() async {
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

  double calculateAssessment() {
    double total = 0;
    total = double.parse(_question1.text) +
        double.parse(_question2.text) +
        double.parse(_question3.text) +
        double.parse(_question4.text) +
        double.parse(_question5.text);

    if (double.parse(_question6.text) > 0) {
      total += double.parse(_question6.text);
    } else {
      total += double.parse(_question7.text);
    }
    return total;
  }

  String getAssessmentResult() {
    String result = "";
    double total = calculateAssessment();

    if (total >= 12) {
      result = "Normal nutritional status";
    } else if (total >= 8) {
      result = "At risk  of malnutrition";
    } else {
      result = "Malnourished";
    }
    return result;
  }

  void submitNutritionalProfile() {
    isSuccessful = false;
    if (_formKey.currentState!.validate()) {
      saveNutritionalProfile();
    }
  }

  Future<void> saveNutritionalProfile() async {
    String uid = await widget.auth.currentUser();
    final docNutrition = FirebaseFirestore.instance
        .collection('patient_nutritional_profile')
        .doc();
    assessmentId = docNutrition.id;
    PatientNutrition user = PatientNutrition(
      id: docNutrition.id,
      uid: uid,
      height: double.parse(widget.height),
      weight: double.parse(widget.weight),
      age: int.parse(widget.age),
      sex: widget.sex,
      bmi: calculateBmi(),
      category: widget.category,
      status: getBmiStatus(),
      points: calculateAssessment(),
      result: getAssessmentResult(),
    );

    final json = user.toJson();
    await docNutrition.set(json).then((value) {
      setState(() {
        isSuccessful = true;
      });
    });
  }

  @override
  void initState() {
    checkUserAssessment();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 60,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo-name.png"),
                    fit: BoxFit.fitHeight,
                  ),
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                  child: Form(
                key: _formKey,
                child: !hasData
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ContainerWithLabel(
                                      leading: "Lastname:",
                                      title: patient.lastname,
                                      height: screenSize.height * 0.05,
                                      width: screenSize.width * 0.45),
                                  ContainerWithLabel(
                                      leading: "Firstname:",
                                      title: patient.firstname,
                                      height: screenSize.height * 0.05,
                                      width: screenSize.width * 0.45),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ContainerWithLabel(
                                      leading: "Sex:",
                                      title: widget.sex,
                                      height: screenSize.height * 0.05,
                                      width: 85),
                                  ContainerWithLabel(
                                      leading: "Age:",
                                      title: widget.age,
                                      height: screenSize.height * 0.05,
                                      width: 60),
                                  ContainerWithLabel(
                                      leading: "Weight:",
                                      title: "${widget.weight}kg",
                                      height: screenSize.height * 0.05,
                                      width: 100),
                                  ContainerWithLabel(
                                      leading: "Height:",
                                      title: "${widget.height}cm",
                                      height: screenSize.height * 0.05,
                                      width: 100),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Complete the screen by filling in the boxes with the appropriate numbers. Total the numbers for the final screening score.",
                                style: appstyle(
                                    10, Colors.black, FontWeight.normal),
                              ),
                              const SizedBox(height: 15),
                              QuestionContainer(
                                question: [
                                  Text(
                                    "Has food intake declined over the past 3 months due to loss appetite, digestive problems, chewing or swallowing difficulties?",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                choices: [
                                  Text(
                                    "0 = severe decrease in food intake",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "1 = moderate decrease in food intake",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "2 = no decrease in food intake",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                ],
                                controller: _question1,
                                range: r"[0-2]",
                                minimum: 0,
                                maximum: 2,
                                isRequired: true,
                              ),
                              const SizedBox(height: 15),
                              QuestionContainer(
                                question: [
                                  Text(
                                    "Weight loss during the last 3 months",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                choices: [
                                  Text(
                                    "0 = weight loss greater than 3 kg (6.6 lbs)",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "1 = does not know",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "2 = weight loss between 1 and 3 kg (2.2 and 6.6 lbs)",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "3 = no weight loss",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                ],
                                controller: _question2,
                                range: r"[0-3]",
                                minimum: 0,
                                maximum: 3,
                                isRequired: true,
                              ),
                              const SizedBox(height: 15),
                              QuestionContainer(
                                question: [
                                  Text(
                                    "Mobility",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                choices: [
                                  Text(
                                    "0 = bed or chair bound",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "1 = able to get out of bed / chair but does not go out",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "2 = goes out",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                ],
                                controller: _question3,
                                range: r"[0-2]",
                                minimum: 0,
                                maximum: 2,
                                isRequired: true,
                              ),
                              const SizedBox(height: 15),
                              QuestionContainer(
                                question: [
                                  Text(
                                    "Has suffered psychological stress or acute disease in the past 3 months?",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                choices: [
                                  Text(
                                    "0 = yes",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "2 = no",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                ],
                                controller: _question4,
                                range: r"[0-2]",
                                minimum: 0,
                                maximum: 2,
                                isRequired: true,
                              ),
                              const SizedBox(height: 15),
                              QuestionContainer(
                                question: [
                                  Text(
                                    "Neuropsychological problems",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                choices: [
                                  Text(
                                    "0 = severe dementia or depression",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "1 = mild dementia",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "2 = no psychological problems",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                ],
                                controller: _question5,
                                range: r"[0-2]",
                                minimum: 0,
                                maximum: 2,
                                isRequired: true,
                              ),
                              const SizedBox(height: 15),
                              QuestionContainer(
                                question: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'F1 ',
                                          style: appstyle(15, Colors.black,
                                              FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              'Body Mass Index (BMI) (weight in kg) / (height in m) 2',
                                          style: appstyle(15, Colors.black,
                                              FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                choices: [
                                  Text(
                                    "0 = BMI less than 19",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "1 = BMI 19 to less than 21",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "2 = BMI 21 to less than 23",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "3 = BMI 23 or greater",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                ],
                                controller: _question6,
                                range: r"[0-3]",
                                minimum: 0,
                                maximum: 3,
                                isRequired: false,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "IF BMI IS NOT AVAILABLE, REPLACE QUESTION F1 WITH QUESTION F2. DO NOT ANSWER QUESTION F2 IF QUESTION F1 IS ALREADY COMPLETED.",
                                  style: appstyle(
                                      14, Colors.black, FontWeight.normal),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 10),
                              QuestionContainer(
                                question: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'F2 ',
                                          style: appstyle(15, Colors.black,
                                              FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              ' Calf circumference (CC) in cm',
                                          style: appstyle(15, Colors.black,
                                              FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                choices: [
                                  Text(
                                    "0 = CC less than 31",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                  Text(
                                    "3 = CC 31 or greater",
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                ],
                                controller: _question7,
                                range: r"[0-3]",
                                minimum: 0,
                                maximum: 3,
                                isRequired: false,
                              ),
                              const SizedBox(height: 100)
                            ],
                          ),
                        ),
                      ]),
              )),
              Container(
                height: screenSize.height * 0.05,
                width: screenSize.width,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      height: 25,
                      width: screenSize.width * 0.18,
                      child: UserCredentialPrimaryButton(
                        onPress: () {
                          // submitNutritionalProfile();
                          // if (isSuccessful) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AssessmentResultScreen(
                                auth: widget.auth,
                                assessmentId: assessmentId,
                              ),
                            ),
                          );
                          // }
                        },
                        label: "Submit",
                        labelSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
