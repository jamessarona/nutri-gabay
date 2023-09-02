import 'package:flutter/material.dart';

import '../shared/app_style.dart';
import '../shared/button_widget.dart';
import '../shared/text_field_widget.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => ResetScreenState();
}

class ResetScreenState extends State<ResetScreen> {
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
                  screenSize: screenSize,
                  label: "Please enter an Email...",
                  isObscure: false),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: screenSize.width * 0.6,
                child: UserCredentialPrimaryButton(
                    onPress: () {}, label: "Send Reset Link"),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
