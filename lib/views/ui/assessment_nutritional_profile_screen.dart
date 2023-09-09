import 'package:flutter/material.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';
import 'package:nutri_gabay/views/ui/assessment_type_screen.dart';

class AssessmentNutritionalProfileScreen extends StatefulWidget {
  final BaseAuth auth;
  const AssessmentNutritionalProfileScreen({
    super.key,
    required this.auth,
  });

  @override
  State<AssessmentNutritionalProfileScreen> createState() =>
      _AssessmentNutritionalProfileScreenState();
}

class _AssessmentNutritionalProfileScreenState
    extends State<AssessmentNutritionalProfileScreen> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _sex = TextEditingController();
  var sex = ['Male', 'Female'];

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
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
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
                        label: "Height (cm):",
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
                        label: "Weight (kg):",
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
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssessmentTypeScreen(
                                    auth: widget.auth,
                                    height: _height.text,
                                    weight: _weight.text,
                                    age: _age.text,
                                    sex: _sex.text,
                                  ),
                                ),
                              );
                            }
                          },
                          label: "Proceed",
                          labelSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
