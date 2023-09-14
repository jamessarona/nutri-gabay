import 'package:flutter/material.dart';
import 'app_style.dart';

class UserCredentialPrimaryButton extends StatelessWidget {
  final void Function() onPress;
  final String label;
  final double labelSize;
  const UserCredentialPrimaryButton(
      {super.key,
      required this.onPress,
      required this.label,
      required this.labelSize});

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
        style: appstyle(labelSize, Colors.white, FontWeight.bold),
      ),
    );
  }
}

class UserCredentialSecondaryButton extends StatelessWidget {
  final void Function() onPress;
  final String label;
  final double labelSize;
  final Color? color;
  const UserCredentialSecondaryButton(
      {super.key,
      required this.onPress,
      required this.label,
      required this.labelSize,
      this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: color ?? customColor[10],
        foregroundColor: Colors.white,
      ),
      child: Text(
        label,
        style: appstyle(labelSize, Colors.white, FontWeight.bold),
      ),
    );
  }
}
