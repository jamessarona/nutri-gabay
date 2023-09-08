import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/ui/home_page.dart';
import 'package:provider/provider.dart';
import '../../controllers/mainscreen_provider.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import '../shared/bottom_nav.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  MainScreen({super.key, required this.auth, required this.onSignOut});

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
