import 'package:flutter/material.dart';

import 'app_style.dart';

class HomePageContainer extends StatelessWidget {
  final Size screenSize;
  final int colorIndex;
  final String? image;
  final IconData? icon;
  final String title;
  final void Function()? onTap;
  const HomePageContainer({
    super.key,
    required this.screenSize,
    required this.colorIndex,
    this.image,
    this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: colorIndex == 0 ? customColor : customColor[colorIndex]),
        height: 110,
        width: screenSize.width,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: image != null
                  ? Image.asset('assets/icons/$image')
                  : Icon(
                      icon,
                      size: 80,
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenSize.width * 0.6,
                  child: Text(
                    title,
                    style: appstyle(30, Colors.white, FontWeight.bold),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
