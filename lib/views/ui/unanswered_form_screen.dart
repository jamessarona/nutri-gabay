import 'package:flutter/material.dart';

class UnansweredFormScreen extends StatefulWidget {
  final String appointmentId;
  const UnansweredFormScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  State<UnansweredFormScreen> createState() => _UnansweredFormScreenState();
}

class _UnansweredFormScreenState extends State<UnansweredFormScreen> {
  late Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
                decoration: BoxDecoration(border: Border.all(width: 0.2))),
          ),
          toolbarHeight: 50,
          backgroundColor: Colors.white,
          elevation: 0,
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
          width: double.infinity,
          child: ListView(
            children: [
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
