import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/root_page.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/bmi_container.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/loading_screen.dart';

class AssessmentResultScreen extends StatefulWidget {
  final BaseAuth auth;
  final String assessmentId;
  const AssessmentResultScreen(
      {super.key, required this.auth, required this.assessmentId});

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

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Here is the results',
                    style: appstyle(35, Colors.black, FontWeight.w800),
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BmiContainer(
                          width: screenSize.width * 0.22,
                          title: "Underweight",
                          detail: "Below 18.5",
                          icon: "doctor",
                        ),
                        BmiContainer(
                          width: screenSize.width * 0.22,
                          title: "Normal",
                          detail: "18.5 - 24.9",
                          icon: "doctor",
                        ),
                        BmiContainer(
                          width: screenSize.width * 0.22,
                          title: "Overweight",
                          detail: "25.0 - 29.9",
                          icon: "doctor",
                        ),
                        BmiContainer(
                          width: screenSize.width * 0.22,
                          title: "Obese",
                          detail: "30.0 above",
                          icon: "doctor",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Nutritional Status",
                    style: appstyle(13, Colors.black, FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  const CircularContainer(
                    height: 50,
                    weight: 250,
                    title: "obese",
                    fontSize: 25,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Your BMI",
                    style: appstyle(13, Colors.black, FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  const CircularContainer(
                    height: 50,
                    weight: 250,
                    title: "23.3",
                    fontSize: 25,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    basis[1],
                    style: appstyle(13, Colors.black, FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Your mini Nutritional Assessment",
                    style: appstyle(12, Colors.black, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const CircularContainer(
                    height: 50,
                    weight: 250,
                    title: "7 points - Malnourished",
                    fontSize: 15,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: UserCredentialPrimaryButton(
                      onPress: () {
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
  }
}
