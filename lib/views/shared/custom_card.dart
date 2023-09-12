import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class ProfileCard extends StatelessWidget {
  final String leading;
  final String title;
  final Size screenSize;
  final double fontSize;
  final bool isOverFlow;
  final void Function()? onTap;
  const ProfileCard(
      {super.key,
      required this.leading,
      required this.title,
      required this.screenSize,
      required this.fontSize,
      required this.isOverFlow,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(
            horizontal: screenSize.height * 0.02, vertical: 5),
        child: ListTile(
          onTap: onTap,
          title: !isOverFlow
              ? Row(
                  children: [
                    Text(
                      leading,
                      style:
                          appstyle(fontSize, Colors.black, FontWeight.normal),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: appstyle(fontSize, customColor, FontWeight.w700),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leading,
                      style:
                          appstyle(fontSize, Colors.black, FontWeight.normal),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: appstyle(fontSize, customColor, FontWeight.w700),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
