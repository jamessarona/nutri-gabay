import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/controllers/mainscreen_provider.dart';
import 'package:nutri_gabay/models/patient_nutrition_controller.dart';
import 'package:nutri_gabay/root_page.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/bmi_container.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/loading_screen.dart';
import 'package:provider/provider.dart';

class AssessmentResultScreen extends StatefulWidget {
  final BaseAuth auth;
  final String assessmentId;
  final bool isDefaultNotifierIndex;
  const AssessmentResultScreen(
      {super.key,
      required this.auth,
      required this.assessmentId,
      required this.isDefaultNotifierIndex});

  @override
  State<AssessmentResultScreen> createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen> {
  late Size screenSize;
  List<String> basis = [
    "",
    "12-14 points: Normal nutritional status \n8-11 points: At risk of malnutrition \n0-7 points: Malnourished",
    "",
    "",
    "",
    "",
  ];

  // ignore: prefer_typing_uninitialized_variables
  var patientNutrition;
  bool hasData = false;

  void getAssessmentResultbyId() async {
    final ref = FirebaseFirestore.instance
        .collection("patient_nutritional_profile")
        .doc(widget.assessmentId)
        .withConverter(
          fromFirestore: PatientNutrition.fromFirestore,
          toFirestore: (PatientNutrition patientNutrition, _) =>
              patientNutrition.toFirestore(),
        );
    final docSnap = await ref.get();
    patientNutrition = docSnap.data();
    hasData = patientNutrition != null;
    setState(() {});
  }

  @override
  void initState() {
    getAssessmentResultbyId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<MainScreenNotifier>(
        builder: (context, mainScreenNotifier, child) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SizedBox(
                height: screenSize.height,
                width: screenSize.width,
                child: !hasData
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                'Here is the results',
                                style:
                                    appstyle(35, Colors.black, FontWeight.w800),
                              ),
                              const SizedBox(height: 100),
                              SizedBox(
                                height: 130,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BmiContainer(
                                      width: screenSize.width * 0.22,
                                      title: "Underweight",
                                      detail: "Below 18.5",
                                      icon: "underweight.png",
                                    ),
                                    BmiContainer(
                                      width: screenSize.width * 0.22,
                                      title: "Normal",
                                      detail: "18.5 - 24.9",
                                      icon: "normal.png",
                                    ),
                                    BmiContainer(
                                      width: screenSize.width * 0.22,
                                      title: "Overweight",
                                      detail: "25.0 - 29.9",
                                      icon: "overweight.png",
                                    ),
                                    BmiContainer(
                                      width: screenSize.width * 0.22,
                                      title: "Obese",
                                      detail: "30.0 above",
                                      icon: "obese.png",
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Nutritional Status",
                                style:
                                    appstyle(13, Colors.black, FontWeight.w800),
                              ),
                              const SizedBox(height: 5),
                              CircularContainer(
                                height: 50,
                                weight: 250,
                                title: patientNutrition.status.toUpperCase(),
                                fontSize: 25,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Your BMI",
                                style:
                                    appstyle(13, Colors.black, FontWeight.w800),
                              ),
                              const SizedBox(height: 5),
                              CircularContainer(
                                height: 50,
                                weight: 250,
                                title: patientNutrition.bmi.toString(),
                                fontSize: 25,
                              ),
                              const SizedBox(height: 30),
                              Text(
                                basis[1],
                                style:
                                    appstyle(13, Colors.black, FontWeight.w800),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),
                              Text(
                                "Your mini Nutritional Assessment",
                                style:
                                    appstyle(12, Colors.black, FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              CircularContainer(
                                height: 50,
                                weight: 250,
                                title:
                                    "${patientNutrition.points.toInt()} points - ${patientNutrition.result}",
                                fontSize: 15,
                              ),
                              const SizedBox(height: 60),
                              SizedBox(
                                height: 50,
                                width: 250,
                                child: UserCredentialPrimaryButton(
                                  onPress: () {
                                    if (widget.isDefaultNotifierIndex) {
                                      mainScreenNotifier.pageIndex = 0;
                                    }
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Root(auth: widget.auth),
                                      ),
                                    );
                                  },
                                  label: "Continue",
                                  labelSize: 15,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
