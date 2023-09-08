import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/patient_nutrition_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';

class SetupNutritionalProfileScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const SetupNutritionalProfileScreen(
      {super.key, required this.auth, required this.onSignOut});

  @override
  State<SetupNutritionalProfileScreen> createState() =>
      _SetupNutritionalProfileScreenState();
}

class _SetupNutritionalProfileScreenState
    extends State<SetupNutritionalProfileScreen> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _sex = TextEditingController();
  var sex = ['Male', 'Female'];

  double calculateBmi() {
    double height = double.parse(_height.text) * 2;
    double weight = double.parse(_weight.text);
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

  void submitNutritionalProfile() {
    if (_formKey.currentState!.validate()) {
      saveNutritionalProfile();
    }
  }

  Future<void> saveNutritionalProfile() async {
    String uid = await widget.auth.currentUser();
    final docNutrition = FirebaseFirestore.instance
        .collection('patient_nutritional_profile')
        .doc();

    PatientNutrition user = PatientNutrition(
      id: docNutrition.id,
      uid: uid,
      height: double.parse(_height.text),
      weight: double.parse(_weight.text),
      age: int.parse(_age.text),
      sex: _sex.text,
      bmi: calculateBmi(),
      status: getBmiStatus(),
    );

    final json = user.toJson();
    await docNutrition.set(json);

    _height.clear();
    _weight.clear();
    _age.clear();
    _sex.clear();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenSize.height * 0.2,
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
                  const SizedBox(
                    height: 20,
                  ),
                  UserCredentialTextField(
                    controller: _height,
                    screenSize: screenSize,
                    label: "Height:",
                    isObscure: false,
                    keyboardType: TextInputType.number,
                    validation: (value) {
                      if (value == "") return "Please enter your height";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  UserCredentialTextField(
                    controller: _weight,
                    screenSize: screenSize,
                    label: "Weight:",
                    isObscure: false,
                    keyboardType: TextInputType.number,
                    validation: (value) {
                      if (value == "") return "Please enter your weight";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  UserCredentialTextField(
                    controller: _age,
                    screenSize: screenSize,
                    label: "Age:",
                    isObscure: false,
                    keyboardType: TextInputType.number,
                    validation: (value) {
                      if (value == "") return "Please enter your age";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  UserCredentialSelectionTextField(
                    controller: _sex,
                    screenSize: screenSize,
                    label: "Sex:",
                    isObscure: false,
                    keyboardType: TextInputType.none,
                    items: sex,
                    icon: Icons.arrow_drop_down,
                    validation: (value) {
                      if (value == "") return "Please select your sex";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: screenSize.width * 0.6,
                    child: UserCredentialPrimaryButton(
                        onPress: () {
                          submitNutritionalProfile();
                        },
                        label: "Proceed"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
