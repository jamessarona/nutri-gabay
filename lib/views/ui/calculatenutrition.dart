import 'package:flutter/material.dart';
import '../shared/button_widget.dart';
import '../shared/text_field_widget.dart';

class CalculateNutritionScreen extends StatefulWidget {
  const CalculateNutritionScreen({super.key});

  @override
  State<CalculateNutritionScreen> createState() =>
      _CalculateNutritionScreenState();
}

class _CalculateNutritionScreenState extends State<CalculateNutritionScreen> {
  late Size screenSize;
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _sex = TextEditingController();
  final TextEditingController _activity = TextEditingController();
  final TextEditingController _disease = TextEditingController();
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
                      label: "Height",
                      isObscure: false,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 15),
                  UserCredentialTextField(
                      controller: _weight,
                      screenSize: screenSize,
                      label: "Weight",
                      isObscure: false,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 15),
                  UserCredentialTextField(
                      controller: _age,
                      screenSize: screenSize,
                      label: "Age",
                      isObscure: false,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 15),
                  UserCredentialTextField(
                      controller: _sex,
                      screenSize: screenSize,
                      label: "Sex",
                      isObscure: false,
                      keyboardType: TextInputType.text),
                  const SizedBox(height: 15),
                  UserCredentialTextField(
                      controller: _activity,
                      screenSize: screenSize,
                      label: "Activity Level",
                      isObscure: false,
                      keyboardType: TextInputType.text),
                  const SizedBox(height: 15),
                  UserCredentialTextField(
                      controller: _disease,
                      screenSize: screenSize,
                      label: "Underlying Disease",
                      isObscure: false,
                      keyboardType: TextInputType.text),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: screenSize.width * 0.6,
                    child: UserCredentialPrimaryButton(
                        onPress: () {
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (ctx) => MainScreen(),
                          //   ),
                          // );
                        },
                        label: "Calculate"),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
