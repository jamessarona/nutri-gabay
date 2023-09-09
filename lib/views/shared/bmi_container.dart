import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class BmiContainer extends StatelessWidget {
  final double width;
  final String title;
  final String detail;
  final String icon;
  const BmiContainer(
      {super.key,
      required this.width,
      required this.title,
      required this.detail,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Text(
            title,
            style: appstyle(
              12,
              Colors.black,
              FontWeight.w800,
            ),
          ),
          Expanded(
            child: Image.asset(
              'assets/icons/$icon.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Text(
            detail,
            style: appstyle(
              12,
              Colors.black,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
