import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nutri_gabay/models/patient_nutrition_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';
import 'package:nutri_gabay/views/ui/assessment_result_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _weightdate = TextEditingController();
  final TextEditingController _birthdate = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _age = TextEditingController();
  bool gender = false;
  bool unit = false;

  // ignore: prefer_typing_uninitialized_variables
  var nutritionProfile;
  bool hasData = false;
  bool isDone = false;

  void getPatientNutritionInfo() async {
    String uid = await FireBaseAuth().currentUser();
    final collection = FirebaseFirestore.instance
        .collection('patient_nutritional_profile')
        .where("uid", isEqualTo: uid)
        .withConverter(
          fromFirestore: PatientNutrition.fromFirestore,
          toFirestore: (PatientNutrition city, _) => city.toFirestore(),
        );

    collection.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (uid == docSnapshot.data().uid) {
            nutritionProfile = docSnapshot.data();
            hasData = nutritionProfile != null;
            setState(() {
              _weightdate.text =
                  DateFormat('MM/dd/yyyy').format(DateTime.now());
              _birthdate.text = nutritionProfile.birthdate;
              _height.text = nutritionProfile.height.toStringAsFixed(2);
              _weight.text = nutritionProfile.weight.toStringAsFixed(2);
              _age.text = nutritionProfile.age.toStringAsFixed(0);
            });
            break;
          }
        }
      },
    );
  }

  void submitChanges() {
    if (_formKey.currentState!.validate()) {
      saveNutritionalProfile().then((value) {
        if (value) {
          isDone = true;
          setState(() {});
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AssessmentResultScreen(
                auth: FireBaseAuth(),
                assessmentId: nutritionProfile.id,
                isDefaultNotifierIndex: true,
              ),
            ),
          );
        }
      });
    }
  }

  double calculateBmi() {
    double height = (double.parse(_height.text) / 100);
    height = height * height;
    double weight = double.parse(_weight.text) / (unit ? 2.2 : 1);
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

  Future<bool> saveNutritionalProfile() async {
    bool isDone = false;
    User? user = FirebaseAuth.instance.currentUser;

    DocumentReference docNutrition;
    docNutrition = FirebaseFirestore.instance
        .collection('patient_nutritional_profile')
        .doc(nutritionProfile.id);

    PatientNutrition nutrition = PatientNutrition(
      id: docNutrition.id,
      uid: user!.uid,
      height: double.parse(_height.text),
      weight: double.parse(_weight.text) / (unit ? 2.2 : 1),
      date: _weightdate.text,
      birthdate: _birthdate.text,
      age: int.parse(_age.text),
      sex: gender ? "Male" : "Female",
      bmi: calculateBmi(),
      category: nutritionProfile.category,
      status: getBmiStatus(),
      points: nutritionProfile.points,
      result: nutritionProfile.result,
      idealPoints: nutritionProfile.idealPoints,
      idealResult: nutritionProfile.idealResult,
    );

    final json = nutrition.toJson();
    await docNutrition.update(json).then((value) {
      isDone = true;
    });

    return isDone;
  }

  @override
  void initState() {
    getPatientNutritionInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.infinity,
          width: screenSize.width,
          child: !hasData
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenSize.height * 0.07,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.02),
                            height: 100,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo-name.png"),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Text(
                            'Date of weighing',
                            style: appstyle(25, Colors.black, FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: screenSize.width * 0.15,
                              right: screenSize.width * 0.15,
                            ),
                            height: 40,
                            child: TextFormField(
                              controller: _weightdate,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.calendar_month,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: customColor),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: customColor,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('MM/dd/yyyy')
                                          .format(pickedDate);

                                  setState(() {
                                    _weightdate.text = formattedDate;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Date of birth',
                            style: appstyle(25, Colors.black, FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: screenSize.width * 0.15,
                              right: screenSize.width * 0.15,
                            ),
                            height: 40,
                            child: TextFormField(
                              controller: _birthdate,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.calendar_month,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: customColor),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              readOnly: true,
                              style:
                                  appstyle(18, Colors.black, FontWeight.w400),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: customColor,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  _age.text =
                                      (AgeCalculator.age(pickedDate).years + 1)
                                          .toString();
                                  String formattedDate =
                                      DateFormat('MM/dd/yyyy')
                                          .format(pickedDate);

                                  setState(() {
                                    _birthdate.text = formattedDate;
                                  });
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sex:",
                                style:
                                    appstyle(18, Colors.black, FontWeight.bold),
                              ),
                              SizedBox(
                                width: 100,
                                height: 80,
                                child: FittedBox(
                                  child: Switch(
                                    thumbIcon: MaterialStateProperty
                                        .resolveWith<Icon?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return const Icon(Icons.male,
                                              color: Colors.black);
                                        }
                                        return const Icon(Icons.female,
                                            color: Colors.black);
                                      },
                                    ),
                                    inactiveThumbColor: customColor,
                                    activeColor: customColor,
                                    activeTrackColor:
                                        Colors.grey.withOpacity(0.5),
                                    inactiveTrackColor:
                                        Colors.grey.withOpacity(0.5),
                                    value: gender,
                                    onChanged: (bool value) {
                                      setState(() {
                                        gender = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "Unit:",
                                style:
                                    appstyle(18, Colors.black, FontWeight.bold),
                              ),
                              SizedBox(
                                width: 100,
                                height: 80,
                                child: FittedBox(
                                  child: Switch(
                                    thumbIcon: MaterialStateProperty
                                        .resolveWith<Icon?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Icon(
                                            MdiIcons.weightPound,
                                            color: Colors.black,
                                          );
                                        }
                                        return Icon(
                                          MdiIcons.weightKilogram,
                                          color: Colors.black,
                                        );
                                      },
                                    ),
                                    inactiveThumbColor: customColor,
                                    activeColor: customColor,
                                    activeTrackColor:
                                        Colors.grey.withOpacity(0.5),
                                    inactiveTrackColor:
                                        Colors.grey.withOpacity(0.5),
                                    value: unit,
                                    onChanged: (bool value) {
                                      setState(() {
                                        unit = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.05),
                            child: UserCredentialTextField(
                              controller: _height,
                              screenSize: screenSize,
                              label: "Height (cm):",
                              isObscure: false,
                              keyboardType: TextInputType.number,
                              validation: (value) {
                                if (value == "") {
                                  return "Please enter your height";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.05),
                            child: UserCredentialTextField(
                              controller: _weight,
                              screenSize: screenSize,
                              label: "Weight (${unit ? 'lbs' : 'kg'}):",
                              isObscure: false,
                              keyboardType: TextInputType.number,
                              validation: (value) {
                                if (value == "") {
                                  return "Please enter your weight";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.05),
                            child: UserCredentialTextField(
                              controller: _age,
                              screenSize: screenSize,
                              label: "Age:",
                              isObscure: false,
                              keyboardType: TextInputType.number,
                              validation: (value) {
                                if (value == "") {
                                  return "Please enter your age";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                width: screenSize.width * 0.35,
                                child: UserCredentialPrimaryButton(
                                  onPress: () {
                                    submitChanges();
                                  },
                                  label: "Calculate",
                                  labelSize: 16,
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.05),
                              SizedBox(
                                height: 50,
                                width: screenSize.width * 0.35,
                                child: UserCredentialSecondaryButton(
                                  onPress: () {
                                    _formKey.currentState?.reset();
                                  },
                                  label: "Discard",
                                  labelSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
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
