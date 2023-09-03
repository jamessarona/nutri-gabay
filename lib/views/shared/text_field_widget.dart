import 'package:flutter/material.dart';

import 'app_style.dart';

class UserCredentialTextField extends StatelessWidget {
  final TextEditingController controller;
  final Size screenSize;
  final String label;
  final bool isObscure;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validation;
  const UserCredentialTextField({
    super.key,
    required this.controller,
    required this.screenSize,
    required this.label,
    required this.isObscure,
    required this.keyboardType,
    this.validation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validation,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: customColor),
          ),
          filled: true,
          hintStyle: appstyle(13, Colors.black, FontWeight.w500),
          hintText: label,
          fillColor: Colors.white70,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
        ),
        obscureText: isObscure,
      ),
    );
  }
}
