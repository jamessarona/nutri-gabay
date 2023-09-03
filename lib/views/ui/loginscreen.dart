import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';
import 'package:nutri_gabay/views/ui/calculatenutrition.dart';
import 'package:nutri_gabay/views/ui/mainscreen.dart';
import 'package:nutri_gabay/views/ui/resetscreen.dart';
import 'package:nutri_gabay/views/ui/signupscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  screenSize: screenSize, label: "Username", isObscure: false),
              const SizedBox(
                height: 15,
              ),
              UserCredentialTextField(
                  screenSize: screenSize, label: "Password", isObscure: true),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: screenSize.width * 0.6,
                child: UserCredentialPrimaryButton(
                    onPress: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => const CalculateNutritionScreen(),
                        ),
                      );
                    },
                    label: "Login"),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: appstyle(14, Colors.black, FontWeight.w500),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Create your account",
                      style: appstyle(
                          14,
                          const Color.fromARGB(255, 28, 117, 190),
                          FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 40,
                width: screenSize.width * 0.5,
                child: UserCredentialSecondaryButton(
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const ResetScreen(),
                      ),
                    );
                  },
                  label: "Forgot Password?",
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
