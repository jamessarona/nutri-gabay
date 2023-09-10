import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import '../shared/button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {},
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
        ),
        body: SizedBox(
          height: double.infinity,
          width: screenSize.width,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: 50,
                      width: screenSize.width * 0.6,
                      child: UserCredentialSecondaryButton(
                          onPress: () {
                            FireBaseAuth().signOut().then(
                                (value) async => Phoenix.rebirth(context));
                          },
                          label: "SignOut",
                          labelSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
