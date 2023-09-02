import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/ui/homepage.dart';
import 'package:provider/provider.dart';
import '../../controllers/mainscreen_provider.dart';
import '../shared/bottom_nav.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList = const [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
        builder: (context, mainScreenNotifier, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: pageList[mainScreenNotifier.pageIndex],
        bottomNavigationBar: const BottomNav(),
      );
    });
  }
}
