import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class BottomNavWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool selectedIndex;
  final IconData? icon;
  final String? assetIcon;
  const BottomNavWidget({
    super.key,
    this.onTap,
    required this.selectedIndex,
    this.icon,
    this.assetIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 36,
        width: 36,
        child: icon != null
            ? Icon(
                icon,
                color: selectedIndex ? customColor : Colors.black,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  'assets/icons/$assetIcon',
                  fit: BoxFit.fitHeight,
                  color: selectedIndex ? customColor : Colors.black,
                ),
              ),
      ),
    );
  }
}
