import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../controllers/mainscreen_provider.dart';
import 'bottom_nav_widget.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
        builder: (context, mainScreenNotifier, child) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 0;
                },
                selectedIndex: mainScreenNotifier.pageIndex == 0,
                icon: OctIcons.home_24,
              ),
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 1;
                },
                selectedIndex: mainScreenNotifier.pageIndex == 1,
                icon: OctIcons.search_24,
              ),
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 2;
                },
                selectedIndex: mainScreenNotifier.pageIndex == 2,
                assetIcon: 'doctor.png',
              ),
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 3;
                },
                selectedIndex: mainScreenNotifier.pageIndex == 3,
                assetIcon: 'healthy.png',
              ),
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 4;
                },
                selectedIndex: mainScreenNotifier.pageIndex == 4,
                icon: Ionicons.calculator_outline,
              ),
            ],
          ),
        ),
      );
    });
  }
}
