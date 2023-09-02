import 'package:flutter/material.dart';

import 'app_style.dart';

class UserCredentialTextField extends StatelessWidget {
  final Size screenSize;
  final String label;
  final bool isObscure;
  const UserCredentialTextField(
      {super.key,
      required this.screenSize,
      required this.label,
      required this.isObscure});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
      height: 50,
      child: TextField(
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
        ),
        obscureText: isObscure,
      ),
    );
  }
}
