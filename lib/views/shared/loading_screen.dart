import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  final double height;
  final double weight;
  final String title;
  final double fontSize;
  const CircularContainer(
      {super.key,
      required this.height,
      required this.weight,
      required this.title,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: height,
      width: weight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: customColor[10],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: appstyle(fontSize, Colors.white, FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
