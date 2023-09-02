import 'package:flutter/material.dart';

import '../shared/app_style.dart';
import '../shared/button_widget.dart';
import '../shared/text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                  screenSize: screenSize, label: "Name", isObscure: false),
              const SizedBox(height: 15),
              UserCredentialTextField(
                  screenSize: screenSize, label: "Email", isObscure: false),
              const SizedBox(height: 15),
              UserCredentialTextField(
                  screenSize: screenSize, label: "Password", isObscure: true),
              const SizedBox(height: 15),
              UserCredentialTextField(
                  screenSize: screenSize,
                  label: "Confirm Password",
                  isObscure: true),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: screenSize.width * 0.6,
                child: UserCredentialPrimaryButton(
                    onPress: () {}, label: "Create Account"),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: appstyle(14, Colors.black, FontWeight.w500),
                  ),
                  const SizedBox(width: 60),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Login",
                      style: appstyle(
                          14,
                          const Color.fromARGB(255, 28, 117, 190),
                          FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
