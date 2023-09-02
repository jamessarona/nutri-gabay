import 'package:flutter/material.dart';
import 'app_style.dart';

class UserCredentialPrimaryButton extends StatelessWidget {
  final void Function() onPress;
  final String label;
  const UserCredentialPrimaryButton(
      {super.key, required this.onPress, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: customColor,
        foregroundColor: Colors.white,
      ),
      child: Text(
        label,
        style: appstyle(16, Colors.white, FontWeight.bold),
      ),
    );
  }
}

class UserCredentialSecondaryButton extends StatelessWidget {
  final void Function() onPress;
  final String label;
  const UserCredentialSecondaryButton(
      {super.key, required this.onPress, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: customColor[10],
        foregroundColor: Colors.white,
      ),
      child: Text(
        label,
        style: appstyle(16, Colors.white, FontWeight.bold),
      ),
    );
  }
}
