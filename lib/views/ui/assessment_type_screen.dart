import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/assessment_type_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/ui/assessment_elderly_screen.dart';

class AssessmentTypeScreen extends StatefulWidget {
  final BaseAuth auth;
  final String height;
  final String weight;
  final String age;
  final String sex;
  const AssessmentTypeScreen({
    super.key,
    required this.auth,
    required this.height,
    required this.weight,
    required this.age,
    required this.sex,
  });

  @override
  State<AssessmentTypeScreen> createState() => _AssessmentTypeScreenState();
}

class _AssessmentTypeScreenState extends State<AssessmentTypeScreen> {
  late Size screenSize;

  int selectedType = 0;
  Stream<List<AssessmentType>> readPatientType() => FirebaseFirestore.instance
      .collection('assessment_type')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AssessmentType.fromJson(doc.data()))
          .toList());

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
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenSize.height * 0.1,
                      ),
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
                      Text(
                        'Select your category',
                        style: appstyle(18, Colors.grey, FontWeight.bold)
                            .copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: StreamBuilder<List<AssessmentType>>(
                stream: readPatientType(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final assessmentType = snapshot.data!;
                    return ListView(
                        children: assessmentType.map(
                      (AssessmentType document) {
                        return GestureDetector(
                          onTap: () {
                            selectedType = int.parse(document.id);
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: selectedType == int.parse(document.id)
                                  ? Border.all(color: customColor, width: 2)
                                  : null,
                              color: int.parse(document.id) < 3
                                  ? customColor[20]
                                  : int.parse(document.id) > 3
                                      ? customColor[40]
                                      : customColor[30],
                            ),
                            height: 100,
                            width: screenSize.width,
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 20),
                                child: Image.asset(
                                    'assets/icons/assessment_category_${document.id}.png'),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: screenSize.width * 0.6,
                                    child: Text(
                                      document.description,
                                      style: appstyle(
                                          30, Colors.black, FontWeight.bold),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                            ]),
                          ),
                        );
                      },
                    ).toList());
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
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
                      width: screenSize.width * 0.15,
                      child: UserCredentialPrimaryButton(
                        onPress: () {
                          if (selectedType == 1) {
                          } else if (selectedType == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssessmentElderlyScreen(
                                  auth: widget.auth,
                                  height: widget.height,
                                  weight: widget.weight,
                                  age: widget.age,
                                  sex: widget.sex,
                                  category: selectedType,
                                ),
                              ),
                            );
                          } else if (selectedType == 3) {
                          } else if (selectedType == 4) {
                          } else if (selectedType == 5) {
                          } else if (selectedType == 6) {}
                        },
                        label: "Next",
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
