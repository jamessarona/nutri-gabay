import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:nutri_gabay/views/shared/drawer_tile.dart';
import 'package:nutri_gabay/views/ui/calculator_screen.dart';
import 'package:nutri_gabay/views/ui/home_page.dart';
import 'package:nutri_gabay/views/ui/profile_screen.dart';
import 'package:nutri_gabay/views/ui/search_screen.dart';
import 'package:provider/provider.dart';
import '../../controllers/mainscreen_provider.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import '../shared/bottom_nav.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  MainScreen({super.key, required this.auth, required this.onSignOut});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Size screenSize;

  List<Widget> pageList = const [
    HomePage(),
    SearchScreen(),
    HomePage(),
    CalculatorScreen()
  ];

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<MainScreenNotifier>(
          builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: mainScreenNotifier.pageIndex != 3
              ? AppBar(
                  toolbarHeight: 50,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: const Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
                      height: 40,
                      width: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo-name.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          drawer: Drawer(
            width: screenSize.width * 0.6,
            child: SizedBox(
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 45,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo-name.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  const Divider(thickness: 1),
                  DrawerTile(
                    icon: "account.png",
                    title: "My Account",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  DrawerTile(
                    icon: "settings.png",
                    title: "Settings",
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  DrawerTile(
                    icon: "logout.png",
                    title: "Logout",
                    onTap: () {
                      FireBaseAuth()
                          .signOut()
                          .then((value) async => Phoenix.rebirth(context));
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          body: pageList[mainScreenNotifier.pageIndex],
          bottomNavigationBar: const BottomNav(),
        );
      }),
    );
  }
}
