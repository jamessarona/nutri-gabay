import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class DrawerTile extends StatelessWidget {
  final String icon;
  final String title;
  final void Function()? onTap;
  const DrawerTile(
      {super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: SizedBox(
        height: 30,
        width: 30,
        child: Image.asset(
          'assets/icons/$icon',
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          title,
          style: appstyle(15, Colors.black, FontWeight.w600),
        ),
      ),
    );
  }
}
