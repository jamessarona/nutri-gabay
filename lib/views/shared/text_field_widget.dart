import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_style.dart';

class UserCredentialTextField extends StatelessWidget {
  final TextEditingController controller;
  final Size screenSize;
  final String label;
  final bool isObscure;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validation;
  const UserCredentialTextField(
      {super.key,
      required this.controller,
      required this.screenSize,
      required this.label,
      required this.isObscure,
      required this.keyboardType,
      this.validation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validation,
        inputFormatters: keyboardType == TextInputType.number
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              ]
            : null,
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

class UserCredentialSelectionTextField extends StatelessWidget {
  final TextEditingController controller;
  final Size screenSize;
  final String label;
  final bool isObscure;
  final TextInputType keyboardType;
  final IconData icon;
  final List<String> items;
  final FormFieldValidator<String>? validation;

  const UserCredentialSelectionTextField({
    super.key,
    required this.controller,
    required this.screenSize,
    required this.label,
    required this.isObscure,
    required this.keyboardType,
    required this.items,
    required this.icon,
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
          suffixIcon: PopupMenuButton<String>(
            icon: Icon(icon),
            onSelected: (String value) {
              controller.text = value;
            },
            itemBuilder: (BuildContext context) {
              return items.map<PopupMenuItem<String>>((String value) {
                return PopupMenuItem(value: value, child: Text(value));
              }).toList();
            },
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
