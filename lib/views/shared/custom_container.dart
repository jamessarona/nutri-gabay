import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class ContainerWithLabel extends StatelessWidget {
  final String leading;
  final String title;
  final double height;
  final double width;
  const ContainerWithLabel(
      {super.key,
      required this.leading,
      required this.title,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Text(
            leading,
            style: appstyle(12, Colors.black, FontWeight.normal),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              style: appstyle(12, Colors.black, FontWeight.bold),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
