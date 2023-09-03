import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/ui/mainscreen.dart';
import '../shared/app_style.dart';
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
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                  screenSize: screenSize, label: "Height", isObscure: false),
              const SizedBox(height: 15),
              UserCredentialTextField(
                  screenSize: screenSize, label: "Weight", isObscure: false),
              const SizedBox(height: 15),
              UserCredentialTextField(
                  screenSize: screenSize, label: "Age", isObscure: false),
              const SizedBox(height: 15),
              UserCredentialTextField(
                  screenSize: screenSize, label: "Sex", isObscure: false),
              const SizedBox(height: 15),
              UserCredentialTextField(
                  screenSize: screenSize,
                  label: "Activity Level",
                  isObscure: false),
              const SizedBox(height: 15),
              UserCredentialTextField(
                  screenSize: screenSize,
                  label: "Underlying Disease",
                  isObscure: false),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: screenSize.width * 0.6,
                child: UserCredentialPrimaryButton(
                    onPress: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => MainScreen(),
                        ),
                      );
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
