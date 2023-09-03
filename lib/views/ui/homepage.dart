import 'package:flutter/material.dart';
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
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenSize.width,
                height: screenSize.height * 0.13,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
                        height: 50,
                        width: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/logo-name.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ]),
              ),
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
                      FireBaseAuth().signOut();
                      setState(() {});
                    },
                    label: "SignOut"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
